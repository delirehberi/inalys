{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE ImpredicativeTypes #-}
{-# LANGUAGE StandaloneDeriving #-}


module Model.User where

import Database.Beam
import Database.Beam.Postgres
import Data.Text (Text)
import Database.PostgreSQL.Simple
import Lens.Micro

data UserT f = User
  { _userId :: Columnar f Int
  , _username :: Columnar f Text
  , _fullname :: Columnar f Text
  , _biography :: Columnar f Text
  , _profilePicture :: Columnar f Text
  , _verified :: Columnar f Bool
  , _mediaCount :: Columnar f Int
  , _followerCount :: Columnar f Int
  , _followingCount :: Columnar f Int
  , _userTagsCount :: Columnar f Int
  , _businessAccount :: Columnar f Bool
  } deriving (Generic, Beamable)

type User = UserT Identity
type UserId = PrimaryKey UserT Identity

deriving instance Show User
deriving instance Eq User

instance Table UserT where
  data PrimaryKey UserT f = UserId (Columnar f Int) deriving (Generic, Beamable)
  primaryKey = UserId . _userId

User (LensFor userId) (LensFor username) (LensFor fullname) (LensFor biography) (LensFor profilePicture) (LensFor verified) (LensFor mediaCount) (LensFor followerCount) (LensFor followingCount) (LensFor userTagsCount) (LensFor businessAccount) = tableLenses
