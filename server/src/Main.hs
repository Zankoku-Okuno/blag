{-#LANGUAGE FlexibleInstances #-}
module Main where

import Network.Wai
import Network.HTTP.Types
import Network.HTTP.Media
import Network.Wai.Handler.Warp (run)

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
    { articleDir :: Path Abs Dir
    , staticDir :: Path Abs Dir
    }
instance FromJSON AppConfig where
    parseJSON (Object v) = do
        articleDir <- parseJSON =<< v .: "articleDir"
        staticDir <- parseJSON =<< v .: "staticDir"
        pure AppConfig{..}
    parseJSON invalid = typeMismatch "Coord" invalid

app :: AppConfig -> Application
app config request respond = do
    accessLogLn request
    let accept = fromMaybe [] $ parseQuality =<< lookup hAccept (requestHeaders request)
    case whatIsWanted request of
        Nothing -> respond response404
        Just resource -> do
            respond =<< generateResponse config resource accept

main :: IO ()
main = do
    config <- getArgs >>= \case
        [configJson] -> eitherDecodeFileStrict' configJson >>= \case
            Right config -> pure config
            Left err -> putErrLn "Invalid configuration:" >> putErrLn err >> exitFailure
        _ -> putErrLn "Usage: okuno-blag-server <config file>" >> exitFailure
    putStrLn $ "http://localhost:8080/"
    run 8080 (app config)

accessLogLn req = putErrLn $ concat [show method, " ", show path, " ", show accept]
    where
    method = requestMethod req
    path = pathInfo req
    accept :: Maybe [Quality MediaType]
    accept = parseQuality =<< lookup hAccept (requestHeaders req)


------------------ Application ------------------

data Resource
    = Article (Path Rel File)
    | Static (Path Rel File)
-- data Action -- method and client's parameters
-- data Client -- authentication
-- data ContentType -- already given by http-types[sp?]

whatIsWanted :: Request -> Maybe Resource
whatIsWanted request = case pathInfo request of
    ("article" : path) -> Article <$> munchToRelFile path
    ("static" : path) -> Static <$> munchToRelFile path
    _ -> Nothing

generateResponse :: AppConfig -> Resource -> [Quality MediaType] -> IO Response
generateResponse AppConfig{..} (Article relfile) accept = do
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
    asMarkdownConfig = StaticServerConfig
        { serveDir = articleDir
        , addExtensions = Just
            [ ("text/markdown", "md")
            , ("text/plain; charset=utf-8", "md")
            ]
        }
generateResponse AppConfig{..} (Static relfile) accept = do
    serveStaticFile staticConfig relfile accept
    where
    staticConfig = StaticServerConfig
        { serveDir = staticDir
        , addExtensions = Nothing
        }


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
