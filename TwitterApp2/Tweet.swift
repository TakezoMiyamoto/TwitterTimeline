//
//  Tweet.swift
//  TwitterApp
//
//  Created by 横山卓也 on 2015/11/29.
//  Copyright © 2015年 yokoyama. All rights reserved.
//

import Foundation
import SwiftyJSON

class Tweet {
    
    //TweetID
    var tweetID = ""        //id_str
    //本文
    var text = ""           //text
    //投稿者表示名
    var userName = ""       //user:name
    //投稿者アイコン
    var userIcon = ""       //user:profile_image_url_https
    //投稿の画像(ない時もあります)
    var image = ""          //extended_entities:media:0:media_url_https
    //リツイート数
    var retweetCount = 0    //retweet_count
    //自分がリツイートしているかフラグ
    var retweeted = false   //retweeted
    //ファボ(いいね)数
    var favoriteCount = 0   //favorite_count
    //ファボしているかフラグ
    var favorited = false   //favorited
    
    
    init(json:JSON){
        
        tweetID = json["id_str"].stringValue
        text = json["text"].stringValue
        userName = json["user"]["name"].stringValue
        userIcon = json["user"]["profile_image_url_https"].stringValue
        image = json["extended_entities"]["media"][0]["media_url_https"].stringValue
        retweetCount = json["retweet_count"].intValue
        retweeted = json["retweeted"].boolValue
        favoriteCount = json["favorite_count"].intValue
        favorited = json["favorited"].boolValue
        
    }
    
}