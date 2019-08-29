{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}
module InstagramType.Media where
import           Data.Aeson.Types    (Parser)
import Data.Aeson
import Control.Monad
import Data.Text (Text)
import Control.Applicative
import InstagramType.Location
import InstagramType.User
import qualified Data.HashMap.Strict as HM
data MediaType = Image|Video|Carousel deriving (Show)

createMediaType:: Int -> MediaType
createMediaType 1 = Image
createMediaType 2 = Video
createMediaType 8 = Carousel

data File = File {
  url :: String,
  width :: Int,
  height :: Int
  }
  deriving (Show)
data MediaList = MediaList {
    items :: Maybe [Media],
    count :: Maybe Int,
    more :: Bool,
    nextMaxId :: Maybe String
  } deriving (Show)
data Media = Media{
  instagramId :: String,
  createdAt :: String,
  user :: User,
  image :: Maybe [File],
  video :: Maybe [File],
  carousel :: Maybe [File],
  caption :: Maybe String,
  tags :: Maybe [String],
  filter :: Maybe Int,
  likeCount :: Maybe Int,
  commentCount :: Maybe Int,
  _type :: MediaType,
  location :: Maybe Location,
  deviceTimestamp :: Maybe String,
  code :: Maybe String,
  hasAudio :: Maybe Bool,
  viewCount :: Maybe Int,
  videoDuration :: Maybe Float
  } deriving (Show)
instance FromJSON MediaList where
  parseJSON = withObject "MediaList" $ \v -> do
    items <- v .:? "items"
    count <- v .:? "num_results"
    more <- v .: "more_available"
    nextMaxId <- v .:? "next_max_id"
    return (MediaList{..})
instance FromJSON File where
  parseJSON = withObject "File" $ \v -> do
    url <- v .: "url"
    width <- v .: "width"
    height <- v .: "height"
    return (File{..})
instance FromJSON Media where
  parseJSON = withObject "Media" $ \v -> do
    instagramId <- v .: "pk"
    createdAt <- v .: "taken_at"
    user <- v .: "user"
    imageVersions <- v .: "image_versions2"
    imagez <- imageVersions .: "candidates"
    let image = return (imagez)
    caption <-fmap join $ v.:? "caption" >>= mapM (\x -> x .:? "text")
    tags <- v .:? "tags"
    filter <- v .:? "filter_type"
    likeCount <- v .:? "like_count"
    commentCount <- v .:? "comment_count"
    location <- v .:? "location"
    _type <- createMediaType <$> v .: "media_type"
    video <- v .:? "video_versions"
    code <- v .:? "code"
    deviceTimestamp <- v .:? "device_timestamp"
    hasAudio <- v .:? "has_auido"
    viewCount <- v .:? "view_count"
    videoDuration <- v .:? "video_duration"
    let carousel = Nothing
    return (Media{..})
