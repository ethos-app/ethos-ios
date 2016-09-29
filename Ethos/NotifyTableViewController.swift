//
//  CardStackTableViewController.swift
//  Ethos
//
//  Created by Scott Fitsimones on 8/30/16.
//  Copyright © 2016 Bolt Visual, Inc. All rights reserved.
//


import UIKit
import MRProgress
import Alamofire
import FBSDKCoreKit
import Haneke

class NotifyTableViewController: UITableViewController, UITextViewDelegate {
    
    var notifications : NSMutableArray?
    
    @IBOutlet var bar: UIView!

    var ethosAuth = ""
    var id = ""
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        notifications = NSMutableArray()
            self.tableView.backgroundColor = UIColor.hexStringToUIColor("e9e9e9")
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.navigationBar.barTintColor = UIColor.hexStringToUIColor("247BA0")
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white, NSFontAttributeName : UIFont(name: "Lobster 1.4", size: 34)!]
        self.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(5, for: UIBarMetrics.default)
        
        
            if let token = UserDefaults.standard.object(forKey: "token") as? String {
            if let id = UserDefaults.standard.object(forKey: "id") as? String {
                self.ethosAuth = token
                self.id = id
            }
        }
        
    self.view.backgroundColor = UIColor.hexStringToUIColor("e9e9e9")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.tabBarController?.delegate = nil
        super.viewWillAppear(animated)
        self.getNotifications()
    }

    func getNotifications() {
        print(ethosAuth)
        print(id)
        let headers = ["Accept":"application/json","Content-Type":"application/json","X-Ethos-Auth":"\(ethosAuth)", "X-Facebook-Id":"\(id)"]
        Alamofire.request("http://meetethos.azurewebsites.net/api/Alerts", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { (response) in
                print(response)
                self.notifications?.removeAllObjects()
                if let array = response.result.value as? NSDictionary {
                let post = array.object(forKey: "selectedAlerts")
                self.updateNotes(notes: post as! NSArray)
                self.read()
                }
        }
        
    }
    func read() {
        let headers = ["Accept":"application/json","Content-Type":"application/json","X-Ethos-Auth":"\(ethosAuth)", "X-Facebook-Id":"\(id)"]
        Alamofire.request("http://meetethos.azurewebsites.net/api/Alerts/ReadAlerts", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { (response) in
                print(response)
          
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        //     cardsButton.selectMe()
        //     netButton.deselectMe()
    }
    func updateNotes(notes: NSArray) {
        for cardDictionary in notes {
            let dict = cardDictionary as! NSDictionary
            let emoji = dict.object(forKey: "SenderEmoji") as! String
            let userText = dict.object(forKey: "Message") as! String
            let type = dict.object(forKey: "ContentAlert") as! Int
            let dataCard = PostCard(posterEmoji: emoji, userText: userText, type: type)
            dataCard.message = userText
            dataCard.likeCount = ""
            dataCard.postID = dict.object(forKey: "PostId") as! Int
            dataCard.userLiked = 0
            dataCard.userOwned = 0
            dataCard.commentCount = ""
            dataCard.groupID = 0
            dataCard.notifyUserID = dict.object(forKey: "UserId") as! Int
            dataCard.posterID = dict.object(forKey: "AlertId") as! Int;
            dataCard.userRead = dict.object(forKey: "UserRead")  as! Bool
            if let content = dict.object(forKey: "Content") as? String {
                dataCard.content = content
            }
            let dateString = dict.object(forKey: "DateCreated") as! String
            print(dateString)
            let format = DateFormatter()
            format.timeZone = TimeZone(secondsFromGMT: 0)
            format.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"
            let date =  format.date(from: dateString)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "d MM HH"
            let result = date!.getElapsedInterval()
            dataCard.date = result
            self.notifications?.add(dataCard)
        }
        
        self.tableView.reloadData()
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notifications!.count
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let source = notifications?.object(at: indexPath.row) as! PostCard
        var typeString = "cells"
        
         if source.content == "" {
            typeString = "text"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: typeString, for: indexPath) as! NotifTableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        if indexPath.row < notifications!.count {
     
   
        if source.userRead == false {
        cell.backgroundColor = UIColor.hexStringToUIColor("247BA0").withAlphaComponent(0.14)
        } else {
            cell.backgroundColor = UIColor.white
        }
        // notification body
        cell.label.text = source.userText
        // load emoji
        let url = URL(string: source.posterEmoji)
        cell.emoji.hnk_setImageFromURL(url!)
        // display image next to notification
            if cell.previewImg != nil {
        if let previewUrl = URL(string: source.content) {
        cell.previewImg.hnk_setImageFromURL(previewUrl)
        } else {
        }
        }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let source = notifications?.object(at: indexPath.row) as! PostCard
        let selected = source.postID
        let postController = self.storyboard?.instantiateViewController(withIdentifier: "single") as! OneCardViewController
        postController.postID = selected
        self.navigationController?.pushViewController(postController, animated: true)

        
        // Present from CardsViewController
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "requestPost"), object: selected)
//        self.tabBarController?.selectedIndex = 0
        
    }
    

    
}
