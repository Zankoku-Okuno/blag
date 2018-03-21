module Main where

import Network.Wai
import Network.HTTP.Types
import Network.HTTP.Media
import Network.Wai.Handler.Warp (run)

import Data.Maybe
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
import qualified Data.Text.Encoding as BS

import Path


------------------ Server ------------------

app :: Path Abs Dir -> Application
app config request respond = do
    accessLogLn request
    let accept = fromMaybe [] $ parseQuality =<< lookup hAccept (requestHeaders request)
    case whatIsWanted request of
        Nothing -> respond response404
        Just resource -> do
            respond =<< generateResponse config resource accept

main :: IO ()
main = do
    articleDir <- getArgs >>= \case
        [articleDir] -> parseAbsDir articleDir
        _ -> putErrLn "Usage: okuno-blag-server <article dir>" >> exitFailure
    putStrLn $ "http://localhost:8080/"
    run 8080 (app articleDir)

accessLogLn req = putErrLn $ concat [show method, " ", show path, " ", show accept]
    where
    method = requestMethod req
    path = pathInfo req
    accept :: Maybe [Quality MediaType]
    accept = parseQuality =<< lookup hAccept (requestHeaders req)


------------------ Application ------------------

data Resource
    = Article (Path Rel File)
-- data Action -- method and client's parameters
-- data Client -- authentication
-- data ContentType -- already given by http-types[sp?]

whatIsWanted :: Request -> Maybe Resource
whatIsWanted request = case pathInfo request of
    ("article" : path) -> Article <$> munchToRelFile path
    _ -> Nothing

generateResponse :: Path Abs Dir -> Resource -> [Quality MediaType] -> IO Response
generateResponse articleDir (Article relfile) accept = do
    serveStaticFile articleConfig relfile accept
    where
    articleConfig = StaticServerConfig
        { serveDir = articleDir
        , extensions =
            [ ("text/markdown; charset=UTF-8", "md")
            , ("text/plain; charset=UTF-8", "md")
            ]
        }


------------------ Prebuilt Applications ------------------

data StaticServerConfig = StaticServerConfig
    { serveDir :: Path Abs Dir
    , extensions :: [(MediaType, String)]
    }

serveStaticFile :: StaticServerConfig -> Path Rel File -> [Quality MediaType] -> IO Response
serveStaticFile StaticServerConfig{..} fileSubpath acceptMedia =
    case mapQualityWithKey extensions acceptMedia of
        Just (contentType, extension) -> do
            putErrLn $ show (contentType, extension)
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
