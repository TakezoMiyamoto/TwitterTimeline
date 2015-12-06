//
//  DetailViewController.swift
//  TwitterApp2
//
//  Created by 宮本武蔵 on 2015/12/06.
//  Copyright © 2015年 Takezo. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import SDWebImage

class DetailViewController: UIViewController, TTTAttributedLabelDelegate {
    
    var tweet:Tweet?
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var retweet: UILabel!
    @IBOutlet weak var favCount: UILabel!
    @IBOutlet weak var tweetLb: TTTAttributedLabel!
    @IBOutlet weak var iconV: UIImageView!
    @IBOutlet weak var detailImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()

    }
    
    // Detail画面更新
    func updateUI() {
        
        guard let tweet = tweet else {
            return
        }

        userName.text = tweet.userName
        retweet.text = "リツイート数: \(tweet.retweetCount)"
        
        tweetLb.delegate = self
        tweetLb.enabledTextCheckingTypes = NSTextCheckingType.Link.rawValue
        tweetLb.text = tweet.text
        
        iconV.sd_setImageWithURL(NSURL(string:tweet.userIcon ))
        iconV.layer.cornerRadius = 5.0
        iconV.layer.masksToBounds = true
        
        if tweet.image == ""{
            detailImageView.snp_makeConstraints(closure: { (make) -> Void in
                make.height.equalTo(0)
            })
            
        }else{
            detailImageView.sd_setImageWithURL(NSURL(string: tweet.image))
            
        }

    }
    

}
