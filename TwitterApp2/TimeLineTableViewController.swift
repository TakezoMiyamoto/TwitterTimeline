//
//  TimeLineTableViewController.swift
//  TwitterApp2
//
//  Created by 宮本武蔵 on 2015/12/05.
//  Copyright © 2015年 Takezo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import SVProgressHUD
import SnapKit



class TimeLineTableViewController: UITableViewController {
    
    // Tweetクラスの配列
    var tweetAr:[Tweet] = []

    // 通信中のフラグ
    var isLoading = false
    
    // リフレッシュのくるくる
    var refreshUI = UIRefreshControl()
    
    
    
    // 初回に一度だけ呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.show()
        
        refreshUI.addTarget(self, action: "refresh", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshUI)
        
        
        // Changed Navigation Color
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.barTintColor = UIColor.hexStr("#39B9A1", alpha: 1)
        
        // ログイン
        TwitterManager.login { (account) -> Void in

            guard let _ = account else {
                // エラー表示
                Util.showError("アカウントがありません") //アクセス権などのエラー内容は省略しています
                return
            }
            // ログイン成功時
            
            self.requestTimeLine()
        }

        
    }
    
    func refresh() {
        
        isLoading = false
//        tweetAr = []
        requestTimeLine(isRefresh: true)
       
        
    }
    
    
    
    func requestTimeLine(parameters: [String: AnyObject] = [:], isRefresh:Bool = false) {
        
        if isLoading { // 通信中なら処理を行わない
            return
        }
        
        isLoading = true
        
        
        // Twitter Managerを使って色々なTwitterAPIを使ってみる
//        let request = TwitterManager.createRequest("https://api.twitter.com/1.1/statuses/home_timeline.json", method: .GET)
        
        let request = TwitterManager.createRequest("https://api.twitter.com/1.1/statuses/home_timeline.json", method: .GET, parameters:parameters)
        
        Alamofire.request(request).responseJSON { (response) -> Void in
            
            // ステータスコードをチェック
            if let statusCode = response.response?.statusCode {
                Util.responseCheck(statusCode)
            }
            
            // 値チェック
            guard let value = response.result.value else {
                return
            }
            
            // リフレッシュの際は配列を空にする!!!
            if isRefresh {
                self.tweetAr = []
            }
            
            let json = JSON(value)
            for tweetJSON in json.arrayValue {
                let tweet = Tweet(json: tweetJSON)
                self.tweetAr.append(tweet)
                
            }
            
            SVProgressHUD.dismiss()
            // テーブル表示を更新
            self.tableView.reloadData()
            self.refreshUI.endRefreshing()
            
            self.isLoading = false
            
        }
    }

    
    // MARK: - Table view data source

    
    // Tableのセクションの数 セクションは何個？と聞かれます。
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    
    // 「section」番号ごとの列件数は何個？
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tweetAr.count
    }

    // セルの表示
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: TweetCell!
        
        if indexPath.row % 2 == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier("Cell1", forIndexPath: indexPath) as! TweetCell
            
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("Cell2", forIndexPath: indexPath) as! TweetCell

        }
        
        cell.setTweet(tweetAr[indexPath.row])

        return cell
    }
    
    
    // 実際の表示よりもちょっと早いイベント
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // 以下で昔のTweetを読み込んでる
        if tweetAr.count - indexPath.row < 5 {
            
            // tweetArの最後のデータを取り出して
            // tweetIDがInt型になるかをチェックします
            if let tweet = tweetAr.last,
                let tweetID = Int64(tweet.tweetID) {
                    
                    let max_id = tweetID - 1 // tweetIDから1を引く仕様なので、従う
                    requestTimeLine(["max_id": "\(max_id)"])
            }
        }
    }

    

}

extension UIColor {
    class func hexStr (var hexStr : NSString, alpha : CGFloat) -> UIColor {
        hexStr = hexStr.stringByReplacingOccurrencesOfString("#", withString: "")
        let scanner = NSScanner(string: hexStr as String)
        var color: UInt32 = 0
        if scanner.scanHexInt(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red:r,green:g,blue:b,alpha:alpha)
        } else {
            print("invalid hex string")
            return UIColor.whiteColor();
        }
    }
}

