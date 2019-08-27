{-# LANGUAGE OverloadedStrings #-}
module InstagramType.User where
import Data.Aeson
import Data.Text (Text)
import Control.Applicative

type Geo = (Maybe Float,Maybe Float)

data User = User { 
  instagramId :: !String,
  username :: String,
  fullName :: Maybe String,
  bio :: String,
  profilePic :: String,
  verified :: Bool,
  private :: Bool,
  mediaCount :: Int,
  followerCount :: Int,
  followingCount :: Int,
  userTagsCount :: Int,
  bussiness:: Bool,
  webSite :: String,
  hasChaining :: Bool,
  totalIGTvVideos :: Int,
  totalAREffects :: Int,
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
  hasHighlightReels :: Bool
  } deriving (Show)

instance FromJSON User where
  parseJSON (Object v) = do
    instagramId <- v .: "pk"
    username <- v .: "username"
    fullName <- v .: "full_name"
    bio <- v .: "biography"
    profilePic <- v .: "profile_pic_url"
    verified <- v .: "is_verified"
    private <- return False
    mediaCount <- v .: "media_count"
    followerCount <- v .: "follower_count"
    followingCount <- v .: "following_count"
    userTagsCount <- v .: "usertags_count"
    bussiness <- v .: "is_business"
    webSite <- v .: "external_url"
    hasChaining <- v .: "has_chaining"
    totalIGTvVideos <- v .: "total_igtv_videos"
    totalAREffects <- v .: "total_ar_effects"
    addressStreet <- (v .:? "address_street")
    instagramCategory <- v .:? "category"
    bussinessContactMethod <- v .:? "bussiness_contact_method"
    cityId <- v .:? "city_id"
    cityName <- v .:? "city_name"
    location_lat <- v .:? "latitude"
    location_lon <- v .:? "longitude"
    location <- return ((location_lat, location_lon))
    publicEmail <- v .:? "public_email"
    publicPhoneCountryCode <- v .:? "public_phone_country_code"
    publicPhoneNumber <- v .:? "public_phone_number"
    zipCode <- v .:? "zip"
    instagramLocationId <- v .:? "instagram_location_id"
    hasHighlightReels <- v .: "has_highlight_reels"
    return (User {
      instagramId = instagramId,
      username = username,
      fullName = fullName,
      bio = bio,
      profilePic = profilePic,
      verified = verified,
      private = private,
      mediaCount = mediaCount,
      followerCount = followerCount,
      followingCount = followingCount,
      userTagsCount = userTagsCount,
      bussiness = bussiness,
      webSite = webSite,
      hasChaining = hasChaining,
      totalIGTvVideos = totalIGTvVideos,
      totalAREffects = totalAREffects,
      addressStreet = addressStreet,
      instagramCategory = instagramCategory,
      bussinessContactMethod = bussinessContactMethod,
      cityId = cityId,
      cityName = cityName,
      location = location,
      publicEmail = publicEmail,
      publicPhoneNumber = publicPhoneNumber,
      publicPhoneCountryCode = publicPhoneCountryCode,
      zipCode = zipCode,
      instagramLocationId = instagramLocationId,
      hasHighlightReels = hasHighlightReels
      })
  parseJSON _ = empty
