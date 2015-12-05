//
//  Util.swift
//  TwitterApp2
//
//  Created by 宮本武蔵 on 2015/12/05.
//  Copyright © 2015年 Takezo. All rights reserved.
//

import UIKit

class Util {
    
    static func showError(msg: String) {
        
        let alert = UIAlertController(title: "エラー", message: msg, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        // alertの表示
        if let window = UIApplication.sharedApplication().delegate?.window {
            window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
            
        } // 現在起動しているアプリケーションの(この場合)ナビゲーションコントローラを取得し、アラートを表示しています。
    }
}
