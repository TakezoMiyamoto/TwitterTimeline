//
//  TweetCell.swift
//  TwitterApp2
//
//  Created by 宮本武蔵 on 2015/12/05.
//  Copyright © 2015年 Takezo. All rights reserved.
//

import UIKit
import Alamofire
import TTTAttributedLabel
import SDWebImage



class TweetCell: UITableViewCell, TTTAttributedLabelDelegate {
    
    @IBOutlet weak var iconV: UIImageView!
    @IBOutlet weak var userLb: UILabel!
    @IBOutlet weak var tweetLb: TTTAttributedLabel!
    @IBOutlet weak var favBtn: FavButton!
    
    var tweet:Tweet?
    
    @IBAction func tapFavBtn(sender: UIButton) {
        favBtn.tapFavBton() //タップした時は、TwitterAPIへのアクセス
        
    }
    
    override func awakeFromNib() {
        iconV.layer.cornerRadius = 5.0
        iconV.layer.masksToBounds = true
    }
    
    
    func setTweet(tweet:Tweet) {
        
        self.tweet = tweet
        
        userLb.text = tweet.userName
        
        // TTTAttributedLabel関連
        tweetLb.delegate = self
        tweetLb.enabledTextCheckingTypes = NSTextCheckingType.Link.rawValue
        tweetLb.text = tweet.text
        
        iconV.sd_setImageWithURL(NSURL(string:tweet.userIcon ))
        
        favBtn.updateFavBtn(tweet)
        
    }
    
        
    // TTTAttributedLabel openURL リンクタップのデリゲートイベント
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        UIApplication.sharedApplication().openURL(url)
    }
    
}