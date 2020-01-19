{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}
module InstagramService.Client where
import Control.Monad (unless)
import GHC.Generics
import Network.Socket hiding (recv)
import Network.Socket.ByteString.Lazy (recv,sendAll)
import Data.Aeson
import qualified Data.ByteString as S
import qualified Data.ByteString.Lazy as L
import InstagramType.Media
import Data.Maybe (isNothing,fromMaybe)

data EmulatorRequestParameters = UserRequest {
    username :: Maybe String,
    userid :: String
  }|
  UserMediaRequest {
    userid :: String,
    next_max_id :: Maybe String
  }deriving (Generic, Show)

data EmulatorRequest = EmulatorRequest {
  endpoint :: String,
  parameters :: EmulatorRequestParameters
  } deriving (Generic, Show)

instance ToJSON EmulatorRequest 
instance FromJSON EmulatorRequest 
instance ToJSON EmulatorRequestParameters
instance FromJSON EmulatorRequestParameters

request :: String -> EmulatorRequestParameters -> IO L.ByteString
request endpoint parameters = do 
  let addr = SockAddrUnix "/tmp/server_15420.sock" 
      fam = AF_UNIX

  sock <- socket fam Stream defaultProtocol
  connect sock addr

  let emulatorRequest = EmulatorRequest {
    endpoint = endpoint,
    parameters = parameters
    }
  let message = encode emulatorRequest
  sendAll sock message
  msg <- mconcat <$> recvFull sock
  close sock
  return msg

recvFull :: Socket -> IO [L.ByteString]
recvFull conn = do
  msg' <- recv conn 2048
  if L.null msg'
   then
    return []
   else 
    (msg' :) <$> recvFull conn 

repeatedRequestForMedia :: String -> Maybe String -> IO [Media]
repeatedRequestForMedia userid next_max_id = do
  let endpoint = "/user/medias"
  let mediaparams =
        UserMediaRequest {userid = userid, next_max_id = next_max_id}
  mediasResp <- request endpoint mediaparams

  let decodedMediaList x =  case (eitherDecode x :: Either String (Maybe MediaList)) of
                              Left x -> fail x
                              Right x -> x

  let mediaList = fromMaybe (error "something wrong") (decodedMediaList mediasResp)
  let medias = fromMaybe [] (items mediaList)
  let nextmaxid = nextMaxId mediaList
  if isNothing (nextMaxId mediaList)
    then return []
    else (++) medias <$> repeatedRequestForMedia userid (nextMaxId mediaList)

