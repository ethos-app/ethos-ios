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
class LoginViewController: UIViewController, FBSDKLoginButtonDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    var myEmoji = 0
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
        myEmoji = indexPath.row
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
        let token = result.token
        let id = FBSDKAccessToken.currentAccessToken().userID
          let headers = ["Accept":"application/json","Content-Type":"application/json","X-Ethos-Auth":"token", "X-Facebook-Id":"\(id)"]
        let params : [String : AnyObject] = ["FacebookId" : "\(id)" , "FriendIds" : [], "Emoji" : "1"]

        print("called")
        Alamofire.request(.POST, "http://meetethos.azurewebsites.net/api/Users/register", parameters: params, encoding: .JSON, headers: headers)
        .responseString { (response) in
            print(response)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        //
        return true
    }
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        //
    }
    
}
