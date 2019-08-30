{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module Main where

import InstagramType.User
import InstagramType.Media
import qualified InstagramService.Client as IS
import Data.Aeson
import Text.RawString.QQ
import qualified Data.ByteString.Lazy.Char8 as C8

main :: IO ()
main = do
  let params = IS.UserRequest {IS.username=Nothing,IS.userid="303054725"}
  req <- IS.request "/user" params
  
  let mediaparams = IS.UserMediaRequest {IS.userid="303054725",IS.next_max_id=(Just "")}
  req2 <- IS.request "/user/medias" mediaparams
  let user = eitherDecode req :: Either String (Maybe User)
  let medias = eitherDecode req2 :: Either String (Maybe MediaList)
  putStrLn $ show user
  putStrLn $ show medias
