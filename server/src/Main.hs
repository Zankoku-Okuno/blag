{-#LANGUAGE FlexibleInstances, FlexibleContexts #-}
module Main where

import Network.Wai
import Network.HTTP.Types
import Network.HTTP.Media
import Network.Wai.Handler.Warp (run)

import qualified Data.HashMap.Strict as HMap
import qualified Data.Vector as Vec
import Data.Maybe
import Text.Hamlet
import System.Environment
import System.Exit
import System.Directory
import Control.Monad.Catch (MonadThrow)
import Data.Monoid
import System.IO
import qualified Data.ByteString as BS
import qualified Data.ByteString.Lazy as LBS
import Data.Text (Text)
import qualified Data.Text as T
import qualified Data.Text.Lazy.IO as LT
import qualified Data.Text.Encoding as BS
import Data.Aeson
import Data.Aeson.Types (typeMismatch)
import Network.Mime
import Text.Blaze.Html.Renderer.Utf8 (renderHtmlBuilder)

import Path


------------------ Server ------------------

data AppConfig = AppConfig
    { articleDb :: Path Abs File
    , articleDir :: Path Abs Dir
    , httpPort :: Int
    , staticDir :: Path Abs Dir
    }
instance FromJSON AppConfig where
    parseJSON (Object v) = do
        articleDb <- parseJSON =<< v .: "articleDb"
        articleDir <- parseJSON =<< v .: "articleDir"
        httpPort <- v .: "httpPort"
        staticDir <- parseJSON =<< v .: "staticDir"
        pure AppConfig{..}
    parseJSON invalid = typeMismatch "AppConfig" invalid

bootApp :: AppConfig -> IO Application
bootApp config@AppConfig{..} = do
    articleDb <- eitherDecodeFileStrict' (fromAbsFile articleDb) >>= \case
            Right articles -> pure articles
            Left err -> putErrLn (concat ["Invalid article db (", show articleDb, "):"]) >> putErrLn err >> exitFailure
    let resources = whatIsWanted articleDb
    pure $ \request respond -> do
        accessLogLn request
        let accept = fromMaybe [] $ parseQuality =<< lookup hAccept (requestHeaders request)
        case resources request of
            Just resource -> do
                response <- generateResponse config articleDb resource accept
                respond response
            Nothing -> respond response404

main :: IO ()
main = do
    config@AppConfig{..} <- getArgs >>= \case
        [configJson] -> eitherDecodeFileStrict' configJson >>= \case
            Right config -> pure config
            Left err -> putErrLn (concat ["Invalid configuration (", configJson, "):"]) >> putErrLn err >> exitFailure
        _ -> putErrLn "Usage: okuno-blag-server <config file>" >> exitFailure
    app <- bootApp config
    putStrLn $ "http://localhost:" ++ show httpPort
    run httpPort app

accessLogLn req = putErrLn $ concat [show method, " ", show path, " ", show accept]
    where
    method = requestMethod req
    path = pathInfo req
    accept :: Maybe [Quality MediaType]
    accept = parseQuality =<< lookup hAccept (requestHeaders req)


------------------ Application ------------------

data Resource
    = Article (Path Rel File)
    | Index
    | Static (Path Rel File)
-- data Action -- method and client's parameters
-- data Client -- authentication
-- data ContentType -- already given by http-types[sp?]

whatIsWanted :: ArticleDb -> Request -> Maybe Resource
whatIsWanted articleDb request = case pathInfo request of
    [] -> Just Index
    ("article" : path) -> Article <$> munchToRelFile path -- FIXME use articleDB articles instead of raw file path
    ("static" : path) -> Static <$> munchToRelFile path
    _ -> Nothing

generateResponse :: AppConfig -> ArticleDb -> Resource -> [Quality MediaType] -> IO Response
generateResponse AppConfig{..} ArticleDb{..} Index accept = do
    let negotiated = mapQuality mimetypes accept
        render = fromMaybe (pure $ response406 (fst <$> mimetypes)) negotiated
    render
    where
    mimetypes =
        [ ("text/html", asHtml)
        ]
    asHtml = do
        pure $ responseBuilder
            status200
            [("Content-Type", "text/html; charset=utf-8")] -- FIXME set content-length
            (renderHtmlBuilder $ $(hamletFile "src/index.hamlet") ())
generateResponse AppConfig{..} _ (Article relfile) accept = do
    articleFile <- (articleDir </>) <$> relfile <.> "md"
    exists <- doesFileExist (fromAbsFile articleFile)
    if exists
    then do
        let negotiated = mapQuality mimetypes accept
            render = fromMaybe (\_ -> pure $ response406 (fst <$> mimetypes)) negotiated
        render articleFile
    else pure response404 -- FIXME un-hardcode
    where
    mimetypes = 
        [ ("text/html", asHtml)
        , ("text/markdown", asMarkdown)
        ]
    asMarkdown articleFile =
        pure $ responseFile
            status200
            [("Content-Type", "text/markdown; charset=utf-8")]
            (fromAbsFile articleFile)
            Nothing
    asHtml articleFile = do
        articleText <- LT.readFile (fromAbsFile articleFile)
        pure $ responseBuilder
            status200
            [("Content-Type", "text/html; charset=utf-8")] -- FIXME set content-length
            (renderHtmlBuilder $ $(hamletFile "src/article.hamlet") ())
generateResponse AppConfig{..} _ (Static relfile) accept = do
    serveStaticFile staticConfig relfile accept
    where
    staticConfig = StaticServerConfig
        { serveDir = staticDir
        , addExtensions = Nothing
        }

------------------ Domain Logic ------------------

data ArticleDb = ArticleDb
    { articles :: [ArticleMetadata]
    } deriving (Show)
instance FromJSON ArticleDb where
    parseJSON (Object v) = do
        articles <- (concat $) <$> (parseCategory `mapM` HMap.toList v)
        pure $ ArticleDb{..}
        where
        parseCategory (k, Array v) = do
            preArticles <- parseJSON `mapM` Vec.toList v
            pure $ ($ k) <$> preArticles
        parseCategory (_, invalid) = typeMismatch "[ArticleMetadata]" invalid
    parseJSON invalid = typeMismatch "ArticleDb" invalid

data ArticleMetadata = ArticleMetadata
    { articleTitle :: Text
    , articleHref :: Path Rel File
    , articleCategory :: Text
    -- , whenPublished :: Maybe Date
    -- , whenUpdated :: [Date]
    } deriving (Show)
instance FromJSON (Text -> ArticleMetadata) where
    parseJSON (Object v) = do
        articleTitle <- v .: "title"
        articleHref <- parseJSON =<< v .: "href"
        pure $ \articleCategory -> ArticleMetadata{..}
    parseJSON invalid = typeMismatch "ArticleMetadata" invalid


------------------ Prebuilt Applications ------------------

data StaticServerConfig = StaticServerConfig
    { serveDir :: Path Abs Dir
    , addExtensions :: Maybe [(MediaType, String)]
    }

serveStaticFile :: StaticServerConfig -> Path Rel File -> [Quality MediaType] -> IO Response
serveStaticFile StaticServerConfig{..} fileSubpath acceptMedia = do
    let extensions = fromMaybe fakeExts addExtensions
    case mapQualityWithKey extensions acceptMedia of
        Just (contentType, extension) -> do
            filePath <- (serveDir </>) <$> fileSubpath <.> extension
            exists <- doesFileExist (fromAbsFile filePath)
            if exists
            then pure $ responseFile
                    status200
                    [("Content-Type", renderHeader contentType)]
                    (fromAbsFile filePath)
                    Nothing
            else pure response404 -- FIXME un-hardcode
        Nothing -> pure $ response406 (fst <$> extensions) -- FIXME un-hardcode
    where
    fakeExts = [(fromJust . parseAccept $ defaultMimeLookup (T.pack $ fromRelFile fileSubpath), "")]

response404 :: Response
response404 = responseLBS
    status404
    [("Content-Type", "text/plain")]
    "Error 404:\nyour file could not be found.\nTry again later."

response406 :: [MediaType] -> Response
response406 acceptable = responseLBS
    status406
    [("Content-Type", "text/plain")]
    ("Error 406:\ncannot render content type.\nPlease try one of these:\n\n" <> acceptList)
    where
    acceptList = LBS.intercalate "\n" $ LBS.fromStrict . renderHeader <$> acceptable


------------------ Web Utilities ------------------

munchToRelFile :: MonadThrow m => [Text] -> m (Path Rel File)
munchToRelFile [] = parseRelFile "" -- NOTE leverage the existing parsing
munchToRelFile [filename] = parseRelFile (T.unpack filename)
munchToRelFile (dirname : rest) = parseRelDir (T.unpack dirname) <$$> (</>) <*> munchToRelFile rest

mapAcceptWithKey :: Accept a => [(a, b)] -> BS.ByteString -> Maybe (a, b)
mapAcceptWithKey options header = mapAccept (map (\(a, b) -> (a, (a, b))) options) header

mapQualityWithKey :: Accept a => [(a, b)] -> [Quality a] -> Maybe (a, b)
mapQualityWithKey options header = mapQuality (map (\(a, b) -> (a, (a, b))) options) header


------------------ Generic Utilities ------------------

putErrLn = hPutStrLn stderr

infixl 4 <$$>
(<$$>) :: Functor f => f a -> (a -> b) -> f b 
(<$$>) = flip (<$>)
