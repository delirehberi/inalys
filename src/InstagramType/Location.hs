{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}
module InstagramType.Location where

import Data.Aeson
import Data.Text
import Control.Applicative

type Geo = (Maybe Float, Maybe Float)

data Location = Location {
  instagramId :: String,
  location :: Geo,
  name :: Maybe String,
  city :: Maybe String,
  address :: Maybe String
} deriving (Show)
instance FromJSON Location where
  parseJSON = withObject "Location" $ \v -> do
    instagramId <- v .: "pk"
    location <- (,) <$> v .:? "lat" <*> v.:? "lng"
    name <- v .:? "name"
    city <- v .:? "city"
    address <- v .:? "address"
    return (Location {..})
