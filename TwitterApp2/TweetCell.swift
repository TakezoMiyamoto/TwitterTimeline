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
    @IBOutlet weak var favBtn: UIButton!
    
    var tweet:Tweet?
    
    @IBAction func tapFavBtn(sender: UIButton) {
        
        guard let tweet = tweet else { return }
        
        // 連打対策
        favBtn.userInteractionEnabled = false
        
        var endPoint = "favorites/create.json"
        if tweet.favorited {
            endPoint = "favorites/destroy.json"
        }
        
        let request = TwitterManager.createRequest(endPoint, method: .POST, parameters:["id":tweet.tweetID])
        
        Alamofire.request(request).responseJSON { (response) -> Void in
            
            self.favBtn.userInteractionEnabled = true
            
            if let statusCode = response.response?.statusCode {
                Util.responseCheck(statusCode)
                
            }
            
            if response.result.isSuccess {
                tweet.favorited = !tweet.favorited // Booleの値を逆にします
                self.updateFavBtn()
            }
        }
        
        
        
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
    
    // TTTAttributedLabel openURL リンクタップのデリゲートイベント
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        UIApplication.sharedApplication().openURL(url)
    }
    
}