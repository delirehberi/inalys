{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module Main where
import Control.Monad (join)
import InstagramType.User
import InstagramType.Media
import qualified InstagramService.Client as IS
import Data.Aeson
import Text.RawString.QQ
import qualified Data.ByteString.Lazy.Char8 as C8
import Data.Maybe (isNothing)
import Data.Either.Unwrap (fromRight)
main :: IO ()
main = do
  let params = IS.UserRequest {IS.username=Nothing,IS.userid="303054725"}
  req <- IS.request "/user" params
  
  let mediaparams = IS.UserMediaRequest {IS.userid="303054725",IS.next_max_id=Just ""}
  medias <- mconcat <$> repeatedRequestForMedia "303054725" Nothing

  let user = eitherDecode req :: Either String (Maybe User)

  {-let medias = eitherDecode req2 :: Either String (Maybe MediaList)

  putStrLn $ show medias-}

  print user
  print medias

repeatedRequestForMedia :: String -> Maybe String -> IO [Maybe MediaList]
repeatedRequestForMedia userid next_max_id = do
    let endpoint = "/user/medias"
    let mediaparams = IS.UserMediaRequest {IS.userid=userid,IS.next_max_id=next_max_id}
    mediasResp <- IS.request endpoint mediaparams
    let medias = fromRight ( eitherDecode mediasResp :: Either String (Maybe MediaList) )

    if isNothing $ nextMaxId <$> medias 
        then
            return []
        else
            (medias:) <$> repeatedRequestForMedia endpoint (join (nextMaxId <$> medias))
