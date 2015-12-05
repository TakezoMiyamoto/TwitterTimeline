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


class TweetCell: UITableViewCell {
    
    @IBOutlet weak var iconV: UIImageView!
    @IBOutlet weak var userLb: UILabel!
    @IBOutlet weak var tweetLb: UILabel!
    @IBOutlet weak var favBtn: UIButton!
    
    
    @IBAction func tapFavBtn(sender: UIButton) {
        
    }
    
    override func awakeFromNib() {
        iconV.layer.cornerRadius = 5.0
        iconV.layer.masksToBounds = true
    }
    
    
}

class TimeLineTableViewController: UITableViewController {
    
    // Tweetクラスの配列
    var tweetAr:[Tweet] = []

    // 初回に一度だけ呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.show()
        
        // Changed Navigation Color
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.barTintColor = UIColor.hexStr("#39B9A1", alpha: 1)
        
        
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
    
    
    
    func requestTimeLine() {
        
        // Twitter Managerを使って色々なTwitterAPIを使ってみる
        let request = TwitterManager.createRequest("https://api.twitter.com/1.1/statuses/home_timeline.json", method: .GET)
        
        Alamofire.request(request).responseJSON { (response) -> Void in
            guard let value = response.result.value else {
                return
            }
            
            let json = JSON(value)
            for tweetJSON in json.arrayValue {
                let tweet = Tweet(json: tweetJSON)
                self.tweetAr.append(tweet)
                
            }
            SVProgressHUD.dismiss()
            self.tableView.reloadData()
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

    //
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: TweetCell!
        
        if indexPath.row % 2 == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier("Cell1", forIndexPath: indexPath) as! TweetCell
            
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("Cell2", forIndexPath: indexPath) as! TweetCell

        }
        
        let tweet = tweetAr[indexPath.row]
        
        cell.userLb.text = tweet.userName
        cell.tweetLb.text = tweet.text
        cell.iconV.sd_setImageWithURL(NSURL(string:tweet.userIcon ))
        
        
        
        
        return cell!
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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

