//
//  TwitterManager.swift
//  TwitterApp2
//
//  Created by 宮本武蔵 on 2015/12/05.
//  Copyright © 2015年 Takezo. All rights reserved.
//

import Foundation
import Social
import Accounts
import Alamofire

class TwitterManager{
    
    //staticなのでデータは必ず1つです。
    static var twitterAccount:ACAccount?
    
    static func login(completion:(account:ACAccount?)->Void){
        
        //既にアカウント取得済みなのでデータを返してあげる
        if let account = twitterAccount{
            completion(account: account)
            return
        }
        
        //アカウントがない場合　エラーなので空で返す
        if !SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
            completion(account: nil)
            return
        }
        let store = ACAccountStore()
        let type = store.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        store.requestAccessToAccountsWithType(type, options: nil) { (granted, error) -> Void in
            
            if error != nil || !granted {
                //通信エラーかアクセス拒否 エラーなので空で返す
                completion(account: nil)
                return
            }
            
            let accounts = store.accountsWithAccountType(type)
            //Twitterは複数アカウント対応してます。アカウント選択があっても良いかもです
            if let account = accounts.first as? ACAccount{
                self.twitterAccount = account //アカウントデータを保持
            }
            
            //取得したアカウントを返してあげる
            completion(account: self.twitterAccount)
        }
    }
    
    
    static func createRequest(endpoint: String, method:SLRequestMethod, parameters: [String: AnyObject] = [:]) -> NSURLRequest {
        
        let url = NSURL(string: "https://api.twitter.com/1.1/\(endpoint)")
        let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: method, URL: url, parameters: parameters)
        
        // アカウント情報を付与します
        request.account = self.twitterAccount
        
        return request.preparedURLRequest()
        
    }
    
    
    
    
    
    
}
