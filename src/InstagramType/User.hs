{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-} 
module InstagramType.User where
import Data.Aeson
import Data.Text (Text)
import Control.Applicative
import InstagramType.Location

data User = User { 
  instagramId :: !String,
  username :: String,
  fullName :: Maybe String,
  bio :: Maybe String,
  profilePic :: String,
  verified :: Bool,
  private :: Bool,
  mediaCount :: Maybe Int,
  followerCount :: Maybe Int,
  followingCount :: Maybe Int,
  userTagsCount :: Maybe Int,
  bussiness:: Maybe Bool,
  webSite :: Maybe String,
  hasChaining :: Maybe Bool,
  totalIGTvVideos :: Maybe Int,
  totalAREffects :: Maybe Int,
  addressStreet :: Maybe String,
  instagramCategory :: Maybe String,
  bussinessContactMethod :: Maybe String,
  cityId :: Maybe String,
  cityName :: Maybe String,
  location :: Geo,
  publicEmail :: Maybe String,
  publicPhoneCountryCode :: Maybe String,
  publicPhoneNumber :: Maybe String,
  zipCode :: Maybe String,
  instagramLocationId :: Maybe String,
  hasHighlightReels :: Maybe Bool
  } deriving (Show)

instance FromJSON User where
  parseJSON = withObject "User" $ \v -> do
    instagramId <- v .: "pk"
    username <- v .: "username"
    fullName <- v .: "full_name"
    bio <- v .:? "biography"
    profilePic <- v .: "profile_pic_url"
    verified <- v .: "is_verified"
    let private = False
    mediaCount <- v .:? "media_count"
    followerCount <- v .:? "follower_count"
    followingCount <- v .:? "following_count"
    userTagsCount <- v .:? "usertags_count"
    bussiness <- v .:? "is_business"
    webSite <- v .:? "external_url"
    hasChaining <- v .:? "has_chaining"
    totalIGTvVideos <- v .:? "total_igtv_videos"
    totalAREffects <- v .:? "total_ar_effects"
    addressStreet <- (v .:? "address_street")
    instagramCategory <- v .:? "category"
    bussinessContactMethod <- v .:? "bussiness_contact_method"
    cityId <- v .:? "city_id"
    cityName <- v .:? "city_name"
    location <- (,) <$> v.:? "latitude" <*> v.:? "longitude"
    publicEmail <- v .:? "public_email"
    publicPhoneCountryCode <- v .:? "public_phone_country_code"
    publicPhoneNumber <- v .:? "public_phone_number"
    zipCode <- v .:? "zip"
    instagramLocationId <- v .:? "instagram_location_id"
    hasHighlightReels <- v .:? "has_highlight_reels"
    return (User {..})
