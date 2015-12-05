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
    
    
    @IBAction func tapFavBtn(sender: UIButton) {
        
        sender.setTitle("♥", forState: .Normal)
        
    }
    
    override func awakeFromNib() {
        iconV.layer.cornerRadius = 5.0
        iconV.layer.masksToBounds = true
    }
    
    
    func setTweet(tweet:Tweet) {
        
        userLb.text = tweet.userName
        tweetLb.text = tweet.text
        iconV.sd_setImageWithURL(NSURL(string:tweet.userIcon ))
        
    }
    
}