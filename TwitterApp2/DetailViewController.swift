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
    @IBOutlet weak var favBtn: FavButton!
    
    
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
        favCount.text = "ファボ数: \(tweet.favoriteCount)"
        
        tweetLb.delegate = self
        tweetLb.enabledTextCheckingTypes = NSTextCheckingType.Link.rawValue
        tweetLb.text = tweet.text
        
        iconV.sd_setImageWithURL(NSURL(string:tweet.userIcon ))
        iconV.layer.cornerRadius = 5.0
        iconV.layer.masksToBounds = true
        
        // コンテンツ画像が空文字の場合
        if tweet.image == ""{
            detailImageView.snp_remakeConstraints(closure: { (make) -> Void in
                make.height.equalTo(0) // 画像の高さを0にして画像の高さを詰める
            })
            
        }else{
            //空文字じゃない場合
            detailImageView.sd_setImageWithURL(NSURL(string: tweet.image))
            
        }
        
        favBtn.updateFavBtn(tweet)

    }
    
    @IBAction func tapFavBtn(sender: FavButton) {
        
        favBtn.tapFavBton()
    }
    
    

}
