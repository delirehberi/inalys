{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}
module InstagramService.Client where
import Control.Monad (unless)
import GHC.Generics
import Network.Socket hiding (recv)
import Network.Socket.ByteString.Lazy (recv,sendAll)
import Data.Aeson

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

{-request :: String -> EmulatorRequestParameters -> IO [Char]-}
request endpoint parameters = do 
  let addr = SockAddrUnix "unix:///tmp/server_15420.sock" 
      fam = AF_UNIX

  sock <- socket fam Stream defaultProtocol
  connect sock addr

  let emulatorRequest = EmulatorRequest {
    endpoint = endpoint,
    parameters = parameters
    }
  let message = encode emulatorRequest
  sendAll sock message
  msg <- recv sock 1024
  close sock
  return msg
