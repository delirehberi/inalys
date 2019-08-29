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

data EmulatorRequestParameters = UserRequest {
    username :: Maybe String,
    userid :: String
  } deriving (Generic, Show)

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
  {-ByteString-}
  msg <- (mconcat <$> recvFull sock)

  close sock
  return msg
{-this function must be recursive-}
recvFull :: Socket -> IO [L.ByteString]
recvFull conn = do
  msg' <- recv conn 1024
  if (L.null msg')
   then
    return []
   else 
    (msg' :) <$> recvFull conn 

