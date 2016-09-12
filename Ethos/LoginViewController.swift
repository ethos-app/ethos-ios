//
//  LoginViewController.swift
//  Ethos
//
//  Created by Scott Fitsimones on 9/8/16.
//  Copyright © 2016 Bolt Visual, Inc. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Alamofire
import MBProgressHUD

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    var myEmoji : NSURL?
    var emojiList : NSMutableArray?
    var emojiKey : UICollectionView?
    var header : UILabel?
    override func viewDidLoad() {
        emojiList = NSMutableArray()
        let lowerThird = CGRectMake(0, self.view.frame.height-200, self.view.frame.width, 200)
        let top = CGRectMake(0, self.view.frame.height-250, self.view.frame.width, 50)
        header = UILabel(frame: top)
        header!.backgroundColor = UIColor.hexStringToUIColor("164E66")
        header!.textAlignment = NSTextAlignment.Center
        header!.font = UIFont(name: "Raleway-Regular", size: 20)
        header!.text = "First, pick your Emoji!"
        header!.textColor = UIColor.whiteColor()
        self.view.addSubview(header!)
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Vertical
        flowLayout.itemSize = CGSizeMake(72, 72)
        flowLayout.minimumLineSpacing = 3
        flowLayout.minimumInteritemSpacing = 0
        emojiKey = UICollectionView(frame: lowerThird, collectionViewLayout: flowLayout)
        emojiKey?.backgroundColor = UIColor.hexStringToUIColor("164E66")
        emojiKey?.delegate = self
        emojiKey?.dataSource = self
        emojiKey?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.view.backgroundColor = UIColor.hexStringToUIColor("247BA0")
        let topFrame = CGRectMake(0, 60, self.view.frame.width, 40)
        let welcome = UILabel(frame: topFrame)
        welcome.textAlignment = NSTextAlignment.Center
        welcome.font = UIFont(name: "Raleway-Light", size: 18)
        welcome.text = "welcome to"
        welcome.textColor = UIColor.whiteColor()
        self.view.addSubview(welcome)
        let nextFrame = CGRectMake(0, 100, self.view.frame.width, 40)
        let logo = UILabel(frame: nextFrame)
        logo.textAlignment = NSTextAlignment.Center
        logo.font = UIFont(name: "Lobster 1.4", size: 52)
        logo.text = "Ethos"
        logo.textColor = UIColor.whiteColor()
        self.view.addSubview(logo)
        let myFrame = CGRectMake(50, self.view.frame.width-100, self.view.frame.width-100, 50)
        let login = FBSDKLoginButton(frame: myFrame)
        login.readPermissions = ["public_profile", "email", "user_friends"]
        login.delegate = self
        login.center.y = self.view.frame.height * 0.9
        self.view.addSubview(login)
        
        self.view.addSubview(emojiKey!)
        loadEm()
    }
    func loadEm() {
        Alamofire.request(.GET, "http://meetethos.azurewebsites.net/api/Emoji/All")
        .responseJSON { (done) in
            if let response = done.result.value as? NSArray {
                for (var i = 0; i<response.count;i += 1) {
                    if let responseURL = response.objectAtIndex(i) as? String {
                    let url = NSURL(string: responseURL)
                    self.emojiList?.addObject(url!)
                    self.emojiKey?.reloadData()
                    }
                }
            }

            
        
//            let objects = response.result
//            for object in objects {
//                print(object)
//            }
        }

    }
    // MARK : Emoji keyboard
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojiList!.count
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        myEmoji = emojiList?.objectAtIndex(indexPath.row) as! NSURL
        UIView.animateWithDuration(0.3) {
            self.header?.frame = CGRectMake(0, self.view.frame.height-165, self.header!.frame.width, 165)
            self.header?.numberOfLines = 0
            self.header?.text = "Last step! 👇\n\n\n"
        }
        UIView.animateWithDuration(0.3) {
            self.emojiKey?.frame = CGRectMake(0, 700, self.emojiKey!.frame.width, self.emojiKey!.frame.height)
        }
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        let circleCase = UIView(frame: cell.contentView.frame)
        circleCase.backgroundColor = UIColor.hexStringToUIColor("247BA0")
        circleCase.layer.cornerRadius = cell.frame.width/2
        circleCase.contentMode = UIViewContentMode.ScaleAspectFit
        let imageFrame = CGRectMake(cell.contentView.frame.origin.x+10, cell.contentView.frame.origin.y+10, cell.contentView.frame.width-20, cell.contentView.frame.height-20)
        let imageView = UIImageView(frame: imageFrame)
        if emojiList?.count > indexPath.row {
        if let url = emojiList!.objectAtIndex(indexPath.row) as? NSURL {
            imageView.imageFromUrl(url)
        }
        }
        cell.contentView.addSubview(circleCase)
        cell.contentView.addSubview(imageView)
        return cell
    }
    // MARK : Login functions
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        header?.text = "verifying..."
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.mode = MBProgressHUDMode.AnnularDeterminate
        hud.color = UIColor.whiteColor()
        hud.progress = 0.2
        loginButton.alpha = 0
        print(result)
        let list = NSMutableArray()
        let friendsRequest = FBSDKGraphRequest(graphPath: "me/friends", parameters: nil)
        friendsRequest.startWithCompletionHandler { (connection, object, error) in
        
          let data = object.objectForKey("data") as! NSArray
            for object in data {
                if let id = object.objectForKey("id") as? String {
                list.addObject(id)
                }
            }
            // Register new user
            self.registerUser(list)
        }
    }
    func registerUser(friends : NSMutableArray) {
        let id = FBSDKAccessToken.currentAccessToken().userID
        let headers = ["Accept":"application/json","Content-Type":"application/json","X-Ethos-Auth":"token", "X-Facebook-Id":"\(id)"]
        let params : [String : AnyObject] = ["FacebookId" : "\(id)" , "FriendIds" : friends, "Emoji" : "\(myEmoji)"]
        
        print("called")
        
        Alamofire.request(.POST, "http://meetethos.azurewebsites.net/api/Users/register", parameters: params, encoding: .JSON, headers: headers)
            .responseJSON { (response) in
                print(response.result.value)
                if let repToken = response.result.value?.objectForKey("token") as? String {
                    self.verifyToken(repToken)
                }
        }

    }
    func verifyToken(token : String) {
        let id = FBSDKAccessToken.currentAccessToken().userID
        let headers = ["Accept":"application/json","Content-Type":"application/json","X-Ethos-Auth":token, "X-Facebook-Id":"\(id)"]
        let params : [String : AnyObject] = [:]
        
        Alamofire.request(.GET, "http://meetethos.azurewebsites.net/api/Users/AuthChecker", parameters: nil, encoding: .JSON, headers: headers)
        
        .responseJSON { (response) in
            if let status = response.result.value?.objectForKey("status") as? String {
                print(status)
                    if status == "ok" {
                        NSUserDefaults.standardUserDefaults().setObject(token, forKey: "token")
                        NSUserDefaults.standardUserDefaults().setObject(id, forKey: "id")
                        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        // failed try again TODO
                }
            }
            
        }
    }
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        //
        return true
    }
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        //
    }
    
}
