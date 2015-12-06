//
//  FavButton.swift
//  TwitterApp2
//
//  Created by 宮本武蔵 on 2015/12/06.
//  Copyright © 2015年 Takezo. All rights reserved.
//

import UIKit
import Alamofire

class FavButton: UIButton {

    var tweet:Tweet?
    
    func tapFavBton() {
        
        guard let tweet = tweet else { return }
        
        // 連打対策
        userInteractionEnabled = false
        
        var endPoint = "favorites/create.json"
        if tweet.favorited {
            endPoint = "favorites/destroy.json"
        }
        
        let request = TwitterManager.createRequest(endPoint, method: .POST, parameters:["id":tweet.tweetID])
        
        Alamofire.request(request).responseJSON { (response) -> Void in
            
            self.userInteractionEnabled = true
            
            if let statusCode = response.response?.statusCode {
                Util.responseCheck(statusCode)
                
            }
            
            if response.result.isSuccess {
                tweet.favorited = !tweet.favorited // Booleの値を逆にします
                self.updateFavBtn(tweet)
            }
        }
    
    
    }
    
    func updateFavBtn(tweet:Tweet) { //引数でtweetをわたす
        
        self.tweet = tweet
        
        if tweet.favorited {
            setTitle("♥", forState: .Normal)
        } else {
            setTitle("♡", forState: .Normal)
        }
        
    }

}
