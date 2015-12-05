//
//  TweetCell.swift
//  TwitterApp2
//
//  Created by 宮本武蔵 on 2015/12/05.
//  Copyright © 2015年 Takezo. All rights reserved.
//

import UIKit


class TweetCell: UITableViewCell {
    
    @IBOutlet weak var iconV: UIImageView!
    @IBOutlet weak var userLb: UILabel!
    @IBOutlet weak var tweetLb: UILabel!
    @IBOutlet weak var favBtn: UIButton!
    
    var tweet:Tweet?
    
    @IBAction func tapFavBtn(sender: UIButton) {
        guard let tweet = tweet else { return }
        
        tweet.favorited = !tweet.favorited // Booleの値を逆にします
        updateFavBtn()
        
    }
    
    override func awakeFromNib() {
        iconV.layer.cornerRadius = 5.0
        iconV.layer.masksToBounds = true
    }
    
    
    func setTweet(tweet:Tweet) {
        
        self.tweet = tweet
        
        userLb.text = tweet.userName
        tweetLb.text = tweet.text
        iconV.sd_setImageWithURL(NSURL(string:tweet.userIcon ))
        
        updateFavBtn()
    }
    
    func updateFavBtn() {
        
        guard let tweet = tweet else { return }
        
        if tweet.favorited {
            favBtn.setTitle("♥", forState: .Normal)
        } else {
            favBtn.setTitle("♡", forState: .Normal)
        }
        
    }
    
}