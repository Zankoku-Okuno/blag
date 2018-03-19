module Main where

import Network.Wai
import Network.HTTP.Types
import Network.Wai.Handler.Warp (run)

import System.Environment
import System.Exit
import System.Directory
import Control.Monad.Catch (MonadThrow)
import System.IO
import qualified Data.ByteString as BS
import Data.Text (Text)
import qualified Data.Text as T
import qualified Data.Text.Encoding as BS

import Path


------------------ Server ------------------

app :: Path Abs Dir -> Application
app config request respond = do
    accessLogLn request
    case whatIsWanted request of
        Nothing -> respond response404
        Just resource -> do
            respond =<< generateResponse config resource

response404 :: Response
response404 = responseLBS
    status404
    [("Content-Type", "text/plain")]
    "Error 404:\nyour file could not be found.\nTry again later."

main :: IO ()
main = do
    articleDir <- getArgs >>= \case
        [articleDir] -> parseAbsDir articleDir
        _ -> putErrLn "Usage: okuno-blag-server <article dir>" >> exitFailure
    putStrLn $ "http://localhost:8080/"
    run 8080 (app articleDir)


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

generateResponse :: Path Abs Dir -> Resource -> IO Response
generateResponse articleDir (Article relfile) = do
    let articlePath = articleDir </> relfile
    exists <- doesFileExist (fromAbsFile articlePath)
    pure $ if exists
    then responseFile
            status200
            [("Content-Type", "text/plain")]
            (fromAbsFile articlePath)
            Nothing
    else response404

------------------ Web Utilities ------------------

munchToRelFile :: MonadThrow m => [Text] -> m (Path Rel File)
munchToRelFile [] = parseRelFile "" -- NOTE leverage the existing parsing
munchToRelFile [filename] = parseRelFile (T.unpack filename)
munchToRelFile (dirname : rest) = parseRelDir (T.unpack dirname) <$$> (</>) <*> munchToRelFile rest


------------------ Generic Utilities ------------------

putErrLn = hPutStrLn stderr
accessLogLn req = putErrLn $ concat [show $ requestMethod req, " ", show $ pathInfo req]

infixl 4 <$$>
(<$$>) :: Functor f => f a -> (a -> b) -> f b 
(<$$>) = flip (<$>)
