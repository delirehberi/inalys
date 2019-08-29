{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module Main where

import InstagramType.User
import qualified InstagramService.Client as IS
import Data.Aeson
import Text.RawString.QQ
import qualified Data.ByteString.Lazy.Char8 as C8

main :: IO ()
main = do
  let params = IS.UserRequest {IS.username=Nothing,IS.userid="465107078"}
  req <- IS.request "/user" params
  let d = eitherDecode req :: Either String (Maybe User)

  putStrLn $ show d
