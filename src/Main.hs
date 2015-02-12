import qualified Data.Attoparsec.Text as P (stringCI, takeWhile, skipWhile, Parser, parseOnly, anyChar, parse,
  Result(..), IResult(..))
import qualified Data.ByteString.Char8 as S (hPutStrLn, pack)
import Data.Maybe (fromJust)
import qualified Data.Text as T (Text)
import qualified Data.Text.IO as TIO (hPutStrLn)
import Data.Text.Encoding (decodeUtf8)
import Network.Http.Client (openConnectionSSL, baselineContextSSL, closeConnection, http,
  buildRequest, Method(GET), setAuthorizationBasic, RequestBuilder, sendRequest, emptyBody,
  receiveResponse, setHeader, getStatusCode, getStatusMessage, getHeader )
import OpenSSL (withOpenSSL)
import OpenSSL.Session (SSLContext, VerificationMode(..), contextSetVerificationMode)
import System.IO (hPutStrLn, stdout)
import qualified System.IO.Streams as Streams

import Requests
import Types

--no check certificate contex settings
settings :: IO SSLContext
settings = do
  ctx <- baselineContextSSL 
  contextSetVerificationMode ctx VerifyNone
  return ctx

parseCookie :: P.Parser Cookie
parseCookie = do
  P.skipWhile (\a -> a /= '=' )
  P.anyChar
  token <- P.takeWhile (\a -> a /= ';') 
  P.skipWhile (\a -> a /= '=' )
  P.anyChar
  expires <- P.takeWhile (\a -> a /= ';') 
  P.skipWhile (\a -> a /= '=' )
  P.anyChar
  path <- P.takeWhile (\a -> a /= ';') 
  P.skipWhile (\a -> a /= '=' )
  P.anyChar
  domain <- P.takeWhile (\a -> a /= ';') 
  return $ Cookie token expires path domain

establishConnection = do
  hPutStrLn stdout "wis automatic registering tool"
  withOpenSSL $ do  
    ctx <- settings
    c <- openConnectionSSL ctx "wis.fit.vutbr.cz" 443
    hPutStrLn stdout "connection established"

    cookieq <- buildRequest cookieRequest
    sendRequest c cookieq emptyBody 

    cookie <- receiveResponse c (\response stream -> do
      m <- Streams.read stream
      --S.hPutStrLn stdout . S.pack . show $ getStatusCode response
      case getStatusCode response of
        200 -> do
          hPutStrLn stdout "response OK"
          -- lets get the cookie
          return ( case  P.parse parseCookie $ decodeUtf8 $ fromJust $ getHeader response "Set-Cookie" of
            P.Done _ cookie ->
              hPutStrLn stdout "GOt cookie" >>
               return (Just cookie)
            otherwise -> 
              hPutStrLn stdout "no cookie obtained" >>
              return Nothing)

        _ -> do
          hPutStrLn stdout "invalid request to the server"
          return Nothing 

      case m of
        Just bytes -> return Nothing
        Nothing -> return Nothing)

    registerq <- buildRequest $ registerRequest $ fromJust cookie
    sendRequest c registerq emptyBody 
     
    return c

--register connection =
  

main :: IO ()
main = do 
  establishConnection >>= closeConnection >> hPutStrLn stdout "ending"
    
  
   
