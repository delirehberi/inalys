{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module Main where

import InstagramType.User
import Data.Aeson
import Text.RawString.QQ


main :: IO ()
main = do
  let
    j = [r|
{
  "pk":"465107078",
  "username":"delirehberi",
  "full_name":"emre \u30c3",
  "is_private":false,
  "profile_pic_url":"https:\/\/scontent-lhr3-1.cdninstagram.com\/vp\/3a80835a3990630ee13dc0e46672c9bf\/5E07560E\/t51.2885-19\/s150x150\/47584350_222534715206002_6818633037668941824_n.jpg?_nc_ht=scontent-lhr3-1.cdninstagram.com",
  "profile_pic_id":"1946074695279692522_465107078",
  "is_verified":false,
  "has_anonymous_profile_picture":false,
  "media_count":421,
  "geo_media_count":0,
  "follower_count":190,
  "following_count":6,
  "following_tag_count":0,
  "biography":"\u30c3",
  "can_link_entities_in_bio":true,
  "biography_with_entities":{"raw_text":"\u30c3","entities":[]},
  "external_url":"http:\/\/emre.xyz\/",
  "external_lynx_url":"https:\/\/l.instagram.com\/?u=http%3A%2F%2Femre.xyz%2F&e=ATPjP0WU09cXnp7B6NyCqJCHDabXn-X6NN1Mwh6vZyB_iDwHjjjUQeZrow3r9DscP8flRVKoqOj46YBB",
  "has_biography_translation":true,
  "can_boost_post":false,
  "can_see_organic_insights":false,
  "show_insights_terms":false,
  "can_convert_to_business":true,
  "can_create_sponsor_tags":false,
  "can_be_tagged_as_sponsor":false,
  "total_igtv_videos":0,
  "total_ar_effects":0,
  "reel_auto_archive":"on",
  "is_profile_action_needed":false,
  "usertags_count":39,
  "usertag_review_enabled":true,
  "is_needy":true,
  "is_interest_account":false,
  "has_recommend_accounts":false,
  "has_chaining":false,
  "hd_profile_pic_url_info":{"url":"https:\/\/scontent-lhr3-1.cdninstagram.com\/vp\/97ecdd65fc5e2d73f29fd3ad822fbb90\/5DF573F4\/t51.2885-19\/47584350_222534715206002_6818633037668941824_n.jpg?_nc_ht=scontent-lhr3-1.cdninstagram.com","width":180,"height":180},
  "has_placed_orders":false,
  "can_tag_products_from_merchants":false,
  "show_conversion_edit_entry":true,
  "aggregate_promote_engagement":true,
  "allowed_commenter_type":"any",
  "is_video_creator":false,
  "has_profile_video_feed":false,
  "has_highlight_reels":true,
  "is_eligible_to_show_fb_cross_sharing_nux":true,
  "page_id_for_new_suma_biz_account":null,
  "eligible_shopping_signup_entrypoints":[],
  "can_be_reported_as_fraud":false,
  "is_business":false,
  "account_type":1,
  "is_call_to_action_enabled":null,
  "linked_fb_info":[],
  "include_direct_blacklist_status":true,
  "can_follow_hashtag":true,
  "is_potential_business":false,
  "feed_post_reshare_disabled":false,
  "besties_count":0,
  "show_besties_badge":true,
  "recently_bestied_by_count":0,
  "nametag":{"mode":1,"gradient":0,"emoji":"\ud83d\ude00","selfie_sticker":0},
  "auto_expand_chaining":false,
  "highlight_reshare_disabled":false,
  "show_post_insights_entry_point":false,
  "show_post_insights_settings_entry_point":false}
    |]
    d = eitherDecode j :: Either String (Maybe User)

  putStrLn $ show d
