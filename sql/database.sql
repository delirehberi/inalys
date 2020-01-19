CREATE TABLE IF NOT EXISTS inalys_users
  (
    id INTEGER PRIMARY KEY,
    username VARCHAR NOT NULL,
    fullname VARCHAR NOT NULL,
    biography TEXT,
    profile_picture VARCHAR,
    verified BOOLEAN DEFAULT FALSE,
    media_count INTEGER DEFAULT 0,
    follower_count INTEGER DEFAULT 0,
    following_count INTEGER DEFAULT 0,
    user_tags_count INTEGER DEFAULT 0,
    business_account BOOLEAN DEFAULT FALSE
  );
