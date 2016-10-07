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
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class LoginViewController: UIViewController, FBSDKLoginButtonDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    /*!
     @abstract Sent to the delegate when the button was used to login.
     @param loginButton the sender
     @param result The results of the login
     @param error The error (if any) from the login
     */

    var myEmoji : URL?
    var header : UILabel?
    var emojiList : NSMutableArray?
    var emojiKey : UICollectionView?
    
    var email = ""
    var firstName = ""
    var lastName = ""
    var city = ""
    var rules : UIButton?
    var rulesWindow : UIView?
    override func viewDidLoad() {
        emojiList = NSMutableArray()
        let lowerThird = CGRect(x: 0, y: self.view.frame.height-200, width: self.view.frame.width, height: 200)
        let top = CGRect(x: 0, y: self.view.frame.height-250, width: self.view.frame.width, height: 50)
        header = UILabel(frame: top)
        header!.backgroundColor = UIColor.hexStringToUIColor("164E66")
        header!.textAlignment = NSTextAlignment.center
        header!.font = UIFont(name: "Raleway-Regular", size: 20)
        header!.text = "First, pick your Emoji!"
        header!.textColor = UIColor.white
        self.view.addSubview(header!)
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical
        flowLayout.itemSize = CGSize(width: 72, height: 72)
        flowLayout.minimumLineSpacing = 3
        flowLayout.minimumInteritemSpacing = 0
        emojiKey = UICollectionView(frame: lowerThird, collectionViewLayout: flowLayout)
        emojiKey?.backgroundColor = UIColor.hexStringToUIColor("164E66")
        emojiKey?.delegate = self
        emojiKey?.dataSource = self
        emojiKey?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.view.backgroundColor = UIColor.hexStringToUIColor("247BA0")
        let topFrame = CGRect(x: 0, y: 60, width: self.view.frame.width, height: 40)
        let welcome = UILabel(frame: topFrame)
        welcome.textAlignment = NSTextAlignment.center
        welcome.font = UIFont(name: "Raleway-Light", size: 18)
        welcome.text = "welcome to"
        welcome.textColor = UIColor.white
        self.view.addSubview(welcome)
        let nextFrame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: 40)
        let logo = UILabel(frame: nextFrame)
        logo.textAlignment = NSTextAlignment.center
        logo.font = UIFont(name: "Lobster 1.4", size: 52)
        logo.text = "Ethos"
        logo.textColor = UIColor.white
        
        self.view.addSubview(logo)
        let myFrame = CGRect(x: 50, y: self.view.frame.width-100, width: self.view.frame.width-100, height: 50)
        
        let login = FBSDKLoginButton(frame: myFrame)
        login.loginBehavior = .native
        login.readPermissions = ["public_profile", "email", "user_friends", "user_location"]
        login.delegate = self
        login.center.y = self.view.frame.height * 0.9
        self.view.addSubview(login)
        
        rulesWindow = UIView.loadFromNibNamed(nibNamed: "TermsView")
        rulesWindow?.frame = CGRect(x: 20, y: 40, width: self.view.frame.width-40, height: self.view.frame.width+60)
        rules = UIButton(frame: myFrame)
        rules?.setTitle("Accept Terms", for: UIControlState.normal)
        rulesWindow?.alpha = 0
        rules?.setTitleColor(UIColor.hexStringToUIColor("247BA0"), for: UIControlState.normal)
        rules?.backgroundColor = UIColor.hexStringToUIColor("EEEEEE")
        rules?.addTarget(self, action: #selector(self.showFB), for: UIControlEvents.touchUpInside)
        rules?.center.y = self.view.frame.height * 0.9
        self.view.addSubview(rules!)
        self.view.addSubview(rulesWindow!)
        self.view.addSubview(emojiKey!)
        loadEm()
        
    }
    func showFB() {
        self.header?.text = "Last step! 👇 \n\n\n"
        UIView.animate(withDuration: 0.3) {
                self.rulesWindow?.alpha = 0
                self.rules?.frame = CGRect(x: 0, y: 1000, width: (self.rules?.frame.width)!, height: (self.rules?.frame.height)!)
        }
    }
    func loadEm() {
        Alamofire.request("http://meetethos.azurewebsites.net/api/Emoji/All")
        .responseJSON { (done) in
            if let response = done.result.value as? NSArray {
                    for emString in response {
                    if let responseURL = emString as? String {
                    let url = URL(string: responseURL)
                    self.emojiList?.add(url!)
                    self.emojiKey?.reloadData()
                    }
                }
            }

        }

    }
    // MARK : Emoji keyboard
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojiList!.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        myEmoji = emojiList?.object(at: (indexPath as NSIndexPath).row) as! URL
        UIView.animate(withDuration: 0.3, animations: {
            self.header?.frame = CGRect(x: 0, y: self.view.frame.height-165, width: self.header!.frame.width, height: 165)
            self.header?.numberOfLines = 0
            self.rulesWindow?.alpha = 1
            self.header?.text = "Agree to the rules? \n\n\n"
        }) 
        UIView.animate(withDuration: 0.3, animations: {
            self.emojiKey?.frame = CGRect(x: 0, y: self.view.frame.height, width: self.emojiKey!.frame.width, height: self.emojiKey!.frame.height)
        }) 
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let circleCase = UIView(frame: cell.contentView.frame)
        circleCase.backgroundColor = UIColor.hexStringToUIColor("247BA0")
        circleCase.layer.cornerRadius = cell.frame.width/2
        circleCase.contentMode = UIViewContentMode.scaleAspectFit
        let imageFrame = CGRect(x: cell.contentView.frame.origin.x+10, y: cell.contentView.frame.origin.y+10, width: cell.contentView.frame.width-20, height: cell.contentView.frame.height-20)
        let imageView = UIImageView(frame: imageFrame)
        if emojiList?.count > (indexPath as NSIndexPath).row {
        if let url = emojiList!.object(at: (indexPath as NSIndexPath).row) as? URL {
            imageView.imageFromUrl(url)
        }
        }
        cell.contentView.addSubview(circleCase)
        cell.contentView.addSubview(imageView)
        return cell
    }
    // MARK : Login functions
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
       
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.annularDeterminate
        hud.color = UIColor.white
        hud.progress = 0.2
        loginButton.alpha = 0
        let list = NSMutableArray()
        
        let friendsRequest = FBSDKGraphRequest(graphPath: "me/friends", parameters: nil)
        friendsRequest?.start { (connection, object, error) in
            // FIX CRASH
            let object = object as! NSDictionary
            let data = object.object(forKey: "data") as! NSArray
            for obj in data {
                let obj = obj as! NSDictionary
                if let id = obj.object(forKey: "id") as? String {
                list.add(id)
                }
            }
            
            let params = ["fields":"name,email,location"]
            let infoReq = FBSDKGraphRequest(graphPath: "me", parameters: params)
            infoReq?.start(completionHandler: { (connection, object, error) in
                
                print(object)
                
                let object = object as! NSDictionary
                if let name = object.object(forKey: "name") as? String {
                var names = name.components(separatedBy: " ")
                    self.firstName = names[0]
                    self.lastName = names[1]
                }
                if let email = object.object(forKey: "email") as? String {
                    self.email = email
                }
                if let location = object.object(forKey: "location") as? NSDictionary
                {
                if let city = location.object(forKey: "name") as? String {
                    self.city = city
                }
                }
                // Register new user
                 self.registerUser(list)
            })
           
        }
    }
    func registerUser(_ friends : NSMutableArray) {
        let id = FBSDKAccessToken.current().userID
        let headers = ["Accept":"application/json","Content-Type":"application/json","X-Ethos-Auth":"token", "X-Facebook-Id":"\(id!)"]
        let params : [String : Any] = ["FacebookId" : "\(id!)" as Any, "FriendIds"  : friends, "Emoji" : "\(myEmoji!)" as Any, "FirstName":"\(firstName)", "LastName":"\(lastName)", "Email":"\(email)","Zipcode":"\(city)"]
    
        Alamofire.request("http://meetethos.azurewebsites.net/api/Users/Register", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { (response) in
           
                let rep = response.result.value as! NSDictionary
                if let repToken = rep.object(forKey: "token") as? String {
                    UserDefaults.standard.set(repToken, forKey: "token")
                    UserDefaults.standard.set(id!, forKey: "id")
                    self.verifyToken(repToken)
                } else {
                    let alert = UIAlertController(title: "Server Full", message: "We are doing our best to get more servers online. Try again later.", preferredStyle: UIAlertControllerStyle.alert)
                    let action = UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: { (action) in
                        //
                    })
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
        }

    }
    public func verifyToken(_ token : String) {
        let id = FBSDKAccessToken.current().userID
        let headers = ["Accept":"application/json","Content-Type":"application/json","X-Ethos-Auth":token, "X-Facebook-Id":"\(id!)"]
        
        Alamofire.request("http://meetethos.azurewebsites.net/api/Users/AuthChecker", method: .get,parameters: nil, encoding: JSONEncoding.default, headers: headers)
        
        .responseJSON { (response) in
             let arrayValue = response.result.value as! NSDictionary
             let status = arrayValue.object(forKey: "status") as! String
                    if status == "ok" {
                  
                        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        // TODO: failed try again
                }
        
        }
    }
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        //
        return true
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        //
    }
    
}
