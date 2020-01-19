{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
module Main where
import Control.Arrow
import Control.Monad (join,mfilter)
import Data.Aeson
import qualified Data.ByteString.Lazy.Char8 as C8
import Data.Either.Unwrap (fromLeft,fromRight)
import qualified InstagramService.Client as IS
import InstagramType.Media
import InstagramType.User
import Text.RawString.QQ
import Data.Maybe (isNothing,fromMaybe)
import Data.Sort (sortOn, sortBy)
import Data.Ord (comparing)
import Data.List (isPrefixOf,group,sort)
import Data.List.Extra (groupOn)
import Database.PostgreSQL.Simple
import Model.User
import Database
import Database.Beam
import Database.Beam.Postgres
import Data.Text (Text)

main :: IO ()
main = do
  let userid = 1557623765;
  -- user <- getUserFromDatabase userid
  {-let params = IS.UserRequest {IS.username = Nothing, IS.userid = "303054725"}
  req <- IS.request "/user" params-}

  -- medias <- IS.repeatedRequestForMedia "1557623765" Nothing
  
  -- let recent_medias = take 6 medias
  -- let popular_medias = popularMedias medias 6
  -- let most_liked_media = head popular_medias
  -- let most_commented_medias = mostCommentedMedias medias 6
  
  -- let most_used_hashtags = take 20 $ hashtagPairedUsageCount medias
  {-let user = eitherDecode req :: Either String (Maybe User)-}

  
  -- print (length medias)
  -- print most_used_hashtags
  
  -- c <- dbConnection
  -- let u = Model.User.User
  --          { _userId = 1557623765
  --          , _username = "delirehberi"
  --          , _fullname = "Emre YILMAZ"
  --          , _biography = "emre"
  --          , _profilePicture = "https://scontent-lhr3-1.cdninstagram.com/vp/3a80835a3990630ee13dc0e46672c9bf/5E07560E/t51.2885-19/s150x150/47584350_222534715206002_6818633037668941824_n.jpg?_nc_ht=scontent-lhr3-1.cdninstagram.com"
  --          , _verified = False
  --          , _mediaCount = 50
  --          , _followerCount = 187
  --          , _followingCount = 6
  --          , _userTagsCount = 0
  --          , _businessAccount = False
  --          }
  -- runBeamPostgres c $ runInsert $
  --   insert (_inalysUsers inalysDatabase) $
  --   insertValues [u]
  u <- getUserFromDatabase dbConnection userid
  print u



popularMedias :: [Media] -> Int -> [Media]
popularMedias medias count = take count $ sortBy (flip (comparing (fromMaybe 0 . likeCount))) medias

mostCommentedMedias :: [Media] -> Int -> [Media]
mostCommentedMedias medias count = take count $ sortBy (flip (comparing (fromMaybe 0 . commentCount))) medias

hashtagPairedUsageCount :: [Media] -> [(String,Int)]
hashtagPairedUsageCount medias = sortBy (\(_,y) (_,x)-> x `compare` y) (groupCount (concatMap findTags medias) )
  where
    groupCount = map (fst.head &&& sum.map snd) . groupOn fst . sort

findTags :: Media -> [(String,Int)]
findTags media = 
  let hashtags = case caption media of  
                    Just c -> Prelude.filter (\x -> "#" `isPrefixOf` x) (words c)
                    Nothing -> []
  in
    ( map (head &&& length) . group . sort ) hashtags

dbConnection = connectPostgreSQL "host=localhost port=5432 dbname=inalysdb user=inalys password=123123"
