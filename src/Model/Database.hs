{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE ImpredicativeTypes #-}


module Model.Database
  ( 
    inalysDatabase, _inalysUsers
  ) where

import Database.Beam
import Database.Beam.Postgres
import Data.Text (Text)
import Database.PostgreSQL.Simple
import Lens.Micro
import qualified Model.User as UserModel

data InalysDatabase f = InalysDatabase 
  { _inalysUsers :: f (TableEntity UserModel.UserT) }
  deriving (Generic, Database be)

InalysDatabase (TableLens inalysUser) = dbLenses

inalysDatabase :: DatabaseSettings be InalysDatabase
inalysDatabase = defaultDbSettings `withDbModification`
  dbModification {
    _inalysUsers =
      setEntityName "inalys_users" <>
        modifyTableFields 
          tableModification {
            UserModel._userId = fieldNamed "id",
            UserModel._username = fieldNamed "username",
            UserModel._biography = fieldNamed "biography",
            UserModel._profilePicture = fieldNamed "profile_picture",
            UserModel._mediaCount = fieldNamed "media_count",
            UserModel._followerCount  = fieldNamed "follower_count",
            UserModel._followingCount = fieldNamed "following_count",
            UserModel._userTagsCount = fieldNamed "user_tags_count",
            UserModel._businessAccount = fieldNamed "business_account"
          }
  }


getUserFromDatabase:: IO Connection -> Int -> m (Maybe a)
getUserFromDatabase connection userid = runBeamPostgres connection $
  runSelectReturningOne $ select $
  do user <- all_ (inalysDatabase ^. _inalysUsers)
     guard_ (user ^. UserModel.userId ==. val_ userid)
     pure (user)
