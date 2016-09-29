//
//  CardStackTableViewController.swift
//  Ethos
//
//  Created by Scott Fitsimones on 8/30/16.
//  Copyright © 2016 Bolt Visual, Inc. All rights reserved.
//


import UIKit
import FBSDKCoreKit
import Alamofire
import MRProgress
import DKImagePickerController
import URLEmbeddedView
import Firebase
import MBProgressHUD
import CWStatusBarNotification

class CardStackTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIGestureRecognizerDelegate, ImageSeekDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, UITabBarControllerDelegate {
    
    var ethosAuth = ""
    var id = ""
    var cardsToShow : NSMutableArray?
    
    @IBOutlet var bar: UIView!
    
    @IBOutlet var cardsButton: BarButton!
    
    @IBOutlet var netButton: BarButton!
    
    @IBOutlet var tableView: UITableView!
    
    var segment = 0
    
    var lookingFrame : CGRect?
    
    @IBOutlet var postBox: PostBox!
    var showingImage = false
    var writingPost = false
    var uplaodImage : UIImage?
    var postType = 0
    var attemptingLoad = false
    
    var picker : DKImagePickerController?
    var loadNext = 2;
    var posting = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.show(postI:)), name: NSNotification.Name(rawValue: "requestPost"), object: nil)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: nil)
        
        cardsToShow = NSMutableArray()
        self.tableView.backgroundColor = UIColor.hexStringToUIColor("e9e9e9")
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let touch = UITapGestureRecognizer(target: self, action: #selector(self.stopWritingPost))
        touch.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(touch)
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.navigationBar.barTintColor = UIColor.hexStringToUIColor("247BA0")
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white, NSFontAttributeName : UIFont(name: "Lobster 1.4", size: 32)!]
        self.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(5, for: UIBarMetrics.default)
        
        let refreshC = UIRefreshControl()
        refreshC.addTarget(self, action: #selector(self.refreshContent(_:)), for: UIControlEvents.allEvents)
        self.tableView.addSubview(refreshC)
        
        let progress = UIProgressView()
        progress.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 50)
        self.view.addSubview(progress)

    }
    func show(postI : NSNotification) {
        print("YEAh")
        let num = postI.object!
        let postController = self.storyboard?.instantiateViewController(withIdentifier: "single") as! OneCardViewController
        self.navigationController?.popToRootViewController(animated: true)
        postController.postID = num as? Int
        self.navigationController?.pushViewController(postController, animated: true)

    }
    
    func postFriends(_ string : NSArray) {
        // let finalDict = ["friendsList" : string]
        let headers = ["Accept":"application/json","Content-Type":"application/json","X-Ethos-Auth":"\(ethosAuth)", "X-Facebook-Id":"\(id)"]
        Alamofire.request("http://meetethos.azurewebsites.net/api/Users/Me/Friends", method: .put, parameters: ["friendsList" : string], encoding: JSONEncoding.default, headers: headers)
            .responseJSON { (response) in
                print(response)
        }
    }
    func refreshContent(_ refreshControl : UIRefreshControl) {
        self.updateFriends()
        self.getPosts()
        refreshControl.endRefreshing()
    }
    
    func updateFriends() {
        //let friendsRequest = FBSDKGraphRequest(graphPath: "me/friends", parameters: nil, tokenString:ethosAuth, version: nil, HTTPMethod: nil)
        let friendsRequest = FBSDKGraphRequest(graphPath: "me/friends", parameters: nil)
        friendsRequest?.start { (connection, object, error) in
            print(error)
            print(object)
            if error == nil {
                let myObject = object as! NSDictionary
                let data = myObject.object(forKey: "data") as! NSArray
                let list = NSMutableArray()
                for obj in data {
                    let obj = obj as! NSDictionary
                    let id = obj.object(forKey: "id") as! String
                    list.add(id)
                }
                
                self.postFriends(list)
            }  else {
                print(error)
            }
        }
        
        
    }
    
    func startFirebase() {
        if let token = FIRInstanceID.instanceID().token() {
            print("REGISTER")
        let headers = ["Accept":"application/json","Content-Type":"application/json","X-Ethos-Auth":ethosAuth, "X-Facebook-Id":"\(id)"]
        Alamofire.request("http://meetethos.azurewebsites.net/api/Users/Me/FirebaseToken", method: .put,parameters: ["FirebaseToken":token], encoding: JSONEncoding.default, headers: headers)
        .responseJSON { (response) in
            print(response)
            print("DONE")
        }
        }
    }
    func verifyToken() {
        print("VERIFYING")
        if let token = UserDefaults.standard.object(forKey: "token") as? String {
            if let id = UserDefaults.standard.object(forKey: "id") as? String {
                self.ethosAuth = token
                self.id = id
                startFirebase()
            }
        }
        
        let headers = ["Accept":"application/json","Content-Type":"application/json","X-Ethos-Auth":ethosAuth, "X-Facebook-Id":"\(id)"]
        Alamofire.request("http://meetethos.azurewebsites.net/api/Users/AuthChecker", method: .get,parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { (response) in
                print(response)
                if let status = response.result.value as? NSDictionary {
                    print(status)
                    let ok = status.object(forKey: "status") as! String
                    print(ok)
                    print("YES")
                    if ok == "ok" {
                        self.updateFriends()
                        self.getPosts()
                        print("GOT POSTS")
                    } else {
                        // Fail
                        FBSDKAccessToken.setCurrent(nil)
                        let login = LoginViewController()
                        self.present(login, animated: true, completion: nil)
                    }
                    
                }
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
//        let note = CWStatusBarNotification()
//        note.notificationLabelBackgroundColor = UIColor.orange.withAlphaComponent(0.6)
//        note.display(withMessage: "Jay LOVES dicks!!", forDuration: 5.0)
//        
        
        self.navigationController?.tabBarController?.delegate = self

        self.view.backgroundColor = UIColor.hexStringToUIColor("e9e9e9")
        if FBSDKAccessToken.current() != nil {
            verifyToken()
        }
        else {
            let login = LoginViewController()
            self.present(login, animated: true, completion: nil)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        postBox.textView?.delegate = self
        postBox.delegate = self

    }
    
    func updatePosts(_ array : NSArray) {
        for cardDictionary in array {
            let dict = cardDictionary as! NSDictionary
            let emoji = dict.object(forKey: "PosterEmoji") as! String
            let userText = dict.object(forKey: "UserText") as! String
            let type = dict.object(forKey: "Type") as! Int

            let dataCard = PostCard(posterEmoji: emoji, userText: userText, type: type)
            dataCard.postID = dict.object(forKey: "PostId") as! Int
            dataCard.userLiked = dict.object(forKey: "UserLiked") as! Int
            dataCard.userOwned = dict.object(forKey: "UserOwned") as! Int
            dataCard.commentCount = dict.object(forKey: "CommentCount") as! String
            dataCard.groupID = dict.object(forKey: "GroupId") as! Int
            dataCard.likeCount = dict.object(forKey: "LikeCount") as! String
            dataCard.posterID = dict.object(forKey: "PosterId") as! Int
            if var groupName = dict.object(forKey: "GroupName") as? String {
                if groupName != "" {
                groupName = "in "+groupName
                }
                dataCard.groupString = groupName
            }
            if dataCard.posterID == 1 {
                dataCard.isEthos = true
            }
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
            if let result = date?.getElapsedInterval() {
            dataCard.date = result
            }
        
            self.cardsToShow?.add(dataCard)
        }
        
        self.tableView.reloadData()
    }
    func getPosts() {
        print("GET POSTS")
        if cardsToShow?.count == 0 {
        let view = MRProgressOverlayView.showOverlayAdded(to: self.view, title: "", mode: MRProgressOverlayViewMode.indeterminate, animated: true)
        view?.backgroundColor = UIColor.hexStringToUIColor("c9c9c9")
        view?.setTintColor(UIColor.hexStringToUIColor("247BA0"))
        }
        
        let headers = ["Accept":"application/json","Content-Type":"application/json","X-Ethos-Auth":"\(ethosAuth)", "X-Facebook-Id":"\(id)"]
        Alamofire.request("http://meetethos.azurewebsites.net/api/Posts", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { (response) in
                print(response)
                self.loadNext = 2
                self.cardsToShow?.removeAllObjects()
                
                MRProgressOverlayView.dismissAllOverlays(for: self.view, animated: true)
                if let array = response.result.value as? NSDictionary {
                if let posts = array.object(forKey: "selectedPosts") as? NSArray {
                    print(posts)
                    self.updatePosts(posts)
                } else {
                    MRProgressOverlayView.dismissAllOverlays(for: self.view, animated: true)
                    
                }
                }
        }
    }
    func nextPosts(page : Int) {
        print("GET NEXT "+String(page))
        if cardsToShow?.count == 0 {
            let view = MRProgressOverlayView.showOverlayAdded(to: self.view, title: "", mode: MRProgressOverlayViewMode.indeterminate, animated: true)
            view?.backgroundColor = UIColor.hexStringToUIColor("c9c9c9")
            view?.setTintColor(UIColor.hexStringToUIColor("247BA0"))
        }
        
        let headers = ["Accept":"application/json","Content-Type":"application/json","X-Ethos-Auth":"\(ethosAuth)", "X-Facebook-Id":"\(id)"]
        Alamofire.request("http://meetethos.azurewebsites.net/api/Posts?page=\(page)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { (response) in
                print(response)
                
                MRProgressOverlayView.dismissAllOverlays(for: self.view, animated: true)
                if let array = response.result.value as? NSDictionary {
                    if let posts = array.object(forKey: "selectedPosts") as? NSArray {
                        print(posts)
                        self.updatePosts(posts)
                        self.loadNext += 1;
                        self.attemptingLoad = false
                    } else {
                        MRProgressOverlayView.dismissAllOverlays(for: self.view, animated: true)
                        self.attemptingLoad = false
                    }
                }
        }
    }
    
    
    func post() {
        if posting == false && postBox.textView?.text != "" {
            posting = true
        var content = postBox.textView?.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        var mediaContent = "NULL"
        
        // detect if link post |  Type = 1
        if ((content?.lowercased().range(of: "http://")) != nil)  || ((content?.lowercased().range(of: "www.")) != nil) {
            print("yep")
            content = content?.lowercased()
            let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let matches = detector.matches(in: content!, options: [], range: NSRange(location: 0, length: content!.utf16.count))
            let linkRange = matches.first
            let contentString = NSString(string: content!)
            let link = contentString.substring(with: linkRange!.range)
            print(link)
            mediaContent = link
            content = content?.replacingOccurrences(of: link, with: "")
            postType = 1
        }
        let headers = ["Accept":"application/json","Content-Type":"application/json","X-Ethos-Auth":"\(ethosAuth)", "X-Facebook-Id":"\(id)"]
        if postType == 2 { // Image Post
          //  let fakeImage = UIImage(cgImage: (self.uplaodImage?.cgImage)!, scale: 1.0, orientation: UIImageOrientation.right)
            let imageData = UIImageJPEGRepresentation(self.uplaodImage!, 0.3)
            
            let base64 = imageData?.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
            mediaContent = base64!
        }
        let params : [String : AnyObject] = ["UserText" : content! as AnyObject , "Content" : mediaContent as AnyObject, "PostType" : postType as AnyObject, "GroupId":"" as AnyObject]
        Alamofire.request("http://meetethos.azurewebsites.net/api/Posts/Create", method: .post,parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { (response) in
                print(response)
                self.postBox.resetText()
                self.stopWritingPost()
                self.getPosts()
                self.posting = false
        }
        }
    }
    func selectCards() {
        cardsButton.selectMe()
        segment = 0
        tableView.alpha = 1
        let saveFrame = netButton.bottomLine?.frame
        UIView.animate(withDuration: 0.3, animations: {
            self.netButton.bottomLine?.frame = self.netButton.bottomLine!.frame.offsetBy(dx: -120, dy: 0)
            }, completion: { (done) in
                if done {
                    self.netButton.deselectMe()
                    self.netButton.bottomLine?.frame = saveFrame!
                }
        })
    }
    func selectNet() {
        netButton.selectMe()
        segment = 1
        tableView.alpha = 0
        let saveFrame = cardsButton.bottomLine?.frame
        UIView.animate(withDuration: 0.3, animations: {
            self.cardsButton.bottomLine?.frame = self.cardsButton.bottomLine!.frame.offsetBy(dx: 125, dy: 0)
            }, completion: { (done) in
                if done {
                    self.cardsButton.deselectMe()
                    self.cardsButton.bottomLine?.frame = saveFrame!
                }
        })
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    override var prefersStatusBarHidden : Bool {
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showPost(at: Int) {
        let postController = self.storyboard?.instantiateViewController(withIdentifier: "single") as! OneCardViewController
        
        postController.oPost = cardsToShow?.object(at: at) as! PostCard?
        self.navigationController?.pushViewController(postController, animated: true)
    }
    func like(_ sender : UIGestureRecognizer) {
        let tag = sender.view!.tag
        let post = cardsToShow?.object(at: tag) as! PostCard
        let postID = post.postID
        if post.userLiked == 0 {
            // post needs to be liked
            post.userLiked = 1
            let headers = ["Accept":"application/json","Content-Type":"application/json","X-Ethos-Auth":"\(ethosAuth)", "X-Facebook-Id":"\(id)"]
            
            let params : [String : AnyObject] = ["LikeType" : "0" as AnyObject, "PostId" : postID as AnyObject]
            Alamofire.request("http://meetethos.azurewebsites.net/api/Likes/New", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { (response) in
                    print(response)
            }
        } else {
            // post already liked, unlike post
            let headers = ["Accept":"application/json","Content-Type":"application/json","X-Ethos-Auth":"\(ethosAuth)", "X-Facebook-Id":"\(id)"]
            
            Alamofire.request("http://meetethos.azurewebsites.net/api/Likes?postId=\(postID)", method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { (response) in
                    print(response)
            }
            
        }
    }
    
    
    
    // MARK: - Table view data source
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
        if (scrollView.contentOffset.y > scrollView.contentSize.height * 0.7) {
            if attemptingLoad == false {
            nextPosts(page: loadNext)
            attemptingLoad = true
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(cardsToShow?.count)
        return cardsToShow!.count
    }
    
    
    func showOptions(sender : UILabel) {
        let source = cardsToShow?.object(at: sender.tag) as! PostCard
        let alert =  UIAlertController(title: "", message: "Options", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        let share = UIAlertAction(title: "Share", style: .default) { (report) in
            //
            self.share(index: sender.tag)
        }
        alert.addAction(share)

        if source.userOwned == 1 {
            let block = UIAlertAction(title: "Delete", style: .destructive) { (report) in
                self.delete(post: source.postID)
            }
            alert.addAction(block)

        } else {
        let report = UIAlertAction(title: "Report", style: .default) { (report) in
            ///
            self.report(post: source)
        }
        let block = UIAlertAction(title: "Block User", style: .destructive) { (report) in
            self.block(userID: source.posterID)
        }
            alert.addAction(report)
            alert.addAction(block)

        }
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        alert.view.tintColor = UIColor.hexStringToUIColor("247BA0")
        
    }
    func zoomModalPic(_ image : UIGestureRecognizer) {
        
    }
    func dismissModalImage(_ recognizer : UILongPressGestureRecognizer) {
        print("called")
        if recognizer.state == UIGestureRecognizerState.began {
            if let modalImage = recognizer.view as? UIImageView {
                UIView.animate(withDuration: 0.4, animations: {
                    modalImage.frame = self.lookingFrame!
                    modalImage.layer.cornerRadius = 2
                    }, completion: { (done) in
                        if done == true {
                            modalImage.removeFromSuperview()
                            self.showingImage = false
                        }
                })
                
            }
        }
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    func expand(_ sender : UIGestureRecognizer) {
        if (writingPost == true) {
            self.stopWritingPost()
            
            return
        }
        showingImage = true
        self.setNeedsStatusBarAppearanceUpdate()
        if let img = sender.view as? UIImageView {
            lookingFrame  = self.view.convert(sender.view!.bounds, from: sender.view)
            let tempView = UIImageView(frame: lookingFrame!)
            tempView.contentMode = UIViewContentMode.scaleAspectFill
            tempView.clipsToBounds = true
            tempView.image = img.image
            tempView.isUserInteractionEnabled = true
            let zoomPic = UIPinchGestureRecognizer(target: self, action: #selector(self.zoomModalPic(_:)))
            zoomPic.delegate = self
            let dismissPic = UILongPressGestureRecognizer(target: self, action: #selector(self.dismissModalImage(_:)))
            dismissPic.minimumPressDuration = 0.01
            dismissPic.delegate = self
            // tempView.addGestureRecognizer(zoomPic)
            tempView.addGestureRecognizer(dismissPic)
            UIApplication.shared.keyWindow?.addSubview(tempView)
            UIView.animate(withDuration: 0.4, animations: {
                tempView.frame = UIScreen.main.bounds
                
                }, completion: { (done) in
                    // done
            })
        }
    }
    func commentPressed(rec : UIGestureRecognizer) {
        showPost(at: rec.view!.tag)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentObject = cardsToShow![(indexPath as NSIndexPath).row] as! PostCard
        let type = currentObject.type
        
        var cellType = "cell"
        if type == 1 {
            cellType = "link"
        } else if type == 2 {
            cellType = "image"
        }
        print(type)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellType, for: indexPath) as? BizCardTableViewCell
        cell?.options.tag = indexPath.row
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        let imageURL = URL(string: currentObject.posterEmoji)
        cell?.img.hnk_setImageFromURL(imageURL!)
        cell?.img.contentMode = UIViewContentMode.scaleAspectFit
        cell?.reply?.alpha = 0

        cell?.groupLabel?.text = currentObject.groupString
        if currentObject.isEthos {
        cell?.backMoji.backgroundColor = UIColor.hexStringToUIColor("247BA0")
        } else if currentObject.userOwned == 1 {
        cell?.backMoji.backgroundColor = UIColor.hexStringToUIColor("247BA0").withAlphaComponent(0.4)
        }
        cell?.desc.text = currentObject.userText
        cell!.date.text = currentObject.date
        
        cell!.options.addTarget(self, action: #selector(self.showOptions(sender:)), for: UIControlEvents.touchUpInside)
        let commented = currentObject.commentCount
        let comm = UITapGestureRecognizer(target: self, action: #selector(self.commentPressed(rec:)))
        cell?.comment.tag = indexPath.row
        comm.cancelsTouchesInView = false
        comm.numberOfTapsRequired = 1
        comm.numberOfTouchesRequired = 1
        cell?.comment.addGestureRecognizer(comm)
        let liked = currentObject.userLiked
        if liked == 1 {
            cell?.like()
        }
        let likes = Int(currentObject.likeCount)
        cell?.likesCount = likes ?? -1
        
        cell?.comment.setTitle("\(commented)", for: UIControlState.normal)
        
        let like = UITapGestureRecognizer(target: self, action: #selector(CardStackTableViewController.like(_:)))
        like.cancelsTouchesInView = false
        like.numberOfTapsRequired = 1
        like.numberOfTouchesRequired = 1
        cell?.react?.tag = (indexPath as NSIndexPath).row
        cell?.react?.addGestureRecognizer(like)
        cell?.setCount(cell!.likesCount)
        cell?.react?.setTitle("\(currentObject.likeCount)", for: UIControlState())
        
        
        cell?.tag = (indexPath as NSIndexPath).row
        if type == 1 {
            cell?.linkStack.spacing = 2
            let title = UILabel()
            title.text = "Bing"
            title.font = UIFont.boldSystemFont(ofSize: 18)
            title.textColor = UIColor.hexStringToUIColor("3366BB")
            let desc = UILabel()
            desc.text = "Search the world"
            desc.font = UIFont(name: "Raleway-Regular", size: 14)
            
            let destination = UILabel()
            destination.font = UIFont(name: "Raleway-Regular", size: 12)
            destination.text = "www.bing.com"
          
//            let myView = cell?.linkStack.arrangedSubviews.first as! LnikViewer
//            myView.linkImage.image = UIImage(named: "ic_link_2x")
//            
            for subview in cell!.linkStack.arrangedSubviews {
                subview.removeFromSuperview()
            }
            let linkEmbed = URLEmbeddedView()
            linkEmbed.loadURL(currentObject.content)
            if cell!.linkStack.subviews.count < 1 {
            cell!.linkStack.addArrangedSubview(linkEmbed)
            }

            
//            if currentObject.hasLinkData == true {
//                print(currentObject.userText)
//                print("HAS")
//                myView.linkTitle.text = currentObject.linkTitle
//                myView.linkURL.text = currentObject.linkURL
//                myView.linkDesc.text = currentObject.linkDesc
//                myView.linkImage.image = currentObject.linkImage
//                
//                print(currentObject.linkImage?.size.height)
//            } else {
//                if self.canOpenURL(string: currentObject.content) {
//                    let url = URL(string: currentObject.content)
//                    Readability.parse(url: url!, completion: { (data) in
//                        
//                        myView.linkTitle.text = data!.title
//                        myView.linkDesc.text =  data!.description!
//                        myView.linkURL.text = currentObject.content
//                        if data!.topImage != nil {
//                            let url = URL(string: data!.topImage!)
//                            myView.linkImage.hnk_setImageFromURL(url!)
//                        }
//                        
//                    })
//                        
//
//                    
//                }
            
                
                
          //  }
        }
        if type == 2 {
            cell?.userImage.image = nil
            cell?.userImage.contentMode = UIViewContentMode.scaleAspectFill
            cell?.userImage.clipsToBounds = true
            cell?.userImage.layer.borderWidth = 1
            cell?.userImage.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.expand(_:)))
            tap.numberOfTapsRequired = 1
            tap.numberOfTouchesRequired = 1
            cell?.userImage.addGestureRecognizer(tap)
            cell?.userImage.isUserInteractionEnabled = true
            let imageURL = URL(string: currentObject.content)
            print(imageURL)
            
            if currentObject.hasImage {
                cell?.userImage.contentMode = UIViewContentMode.scaleAspectFill
                cell?.userImage.clipsToBounds = true
                cell?.userImage.image = currentObject.imageStore!
            } else {
                let task =   URLSession.shared.dataTask(with: imageURL!, completionHandler: { (myData, response, error) in
                    DispatchQueue.main.async(execute: {
                        if (indexPath as NSIndexPath).row == cell?.tag {
                            /// FIX CRASH
                            let myImage = UIImage(data: myData!)
                            cell?.userImage.image = myImage
                            currentObject.imageStore = myImage
                            currentObject.hasImage =  true
                        }
                    })
                })
                task.resume()
            }
        }
        cell?.layoutIfNeeded()
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        if writingPost == true {
            stopWritingPost()
            print("writing")
        } else {
            self.showPost(at: indexPath.row)
            
            
        }
    }
    
    // MARK: Text View Delegate methods
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        writingPost = true
        print("began")
        textView.text = ""
        
        textView.textColor = UIColor.black
        let postButton = UIBarButtonItem(title: "Post", style: UIBarButtonItemStyle.done, target: self, action: #selector(CardStackTableViewController.post))
        self.navigationItem.setRightBarButton(postButton, animated: true)
        
        self.postBox.textView?.becomeFirstResponder()
    }
    
    func stopWritingPost() {
        imageCancelled()
        postBox.restorePicker()
        self.tableView.alpha = 1.0
        let postButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.done, target: self, action: #selector(CardStackTableViewController.post))
        self.navigationItem.setRightBarButton(postButton, animated: true)
        if ((postBox.textView?.text.isEmpty) != nil) {
            postBox.resetText()
            postBox.textView?.resignFirstResponder()
        }
        let triggerTime = (Int64(Double(NSEC_PER_SEC) * 0.3))
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(triggerTime) / Double(NSEC_PER_SEC), execute: { () -> Void in
            self.writingPost = false
        })
        
        
    }
    
    // MARK: Image Seek Delegate
    func imageCancelled() {
        self.postType = 0
        self.uplaodImage = nil
    }
    func showImagePicker() {
        print("called")
        
        picker = DKImagePickerController()
        picker!.singleSelect = true
        picker!.assetType = DKImagePickerControllerAssetType.allPhotos
        picker!.didSelectAssets = { (assets: [DKAsset]) in
            print("didSelectAssets")
            let done = false
            assets.first?.fetchOriginalImage(done, completeBlock: { (image, info) in
                self.postBox.pickButton?.image = image
                self.uplaodImage = image
                self.postType = 2
                UIView.animate(withDuration: 0.4, animations: {
                    self.postBox.pickButton?.frame = CGRect(x: self.postBox.frame.width-75, y: self.postBox.frame.height-70, width: self.postBox.frame.height-25, height: self.postBox.frame.height-25)
                    self.postBox.pickButton?.contentMode = UIViewContentMode.scaleToFill
                    self.postBox.cancelMedia?.alpha = 1
                })
                
            })
            print(assets.first)
        }
        self.present(picker!, animated: true)
    }
    
    func canOpenURL(string: String?) -> Bool {
        guard let urlString = string else {return false}
        guard let url = NSURL(string: urlString) else {return false}
        if !UIApplication.shared.canOpenURL(url as URL) {return false}
        
        //
        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        return predicate.evaluate(with: string)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(info)
    }
    


    // MARK: moderation methods
    func getOptions(sender : UIButton) {
    
    }
    func delete(post: Int) {
        
        let headers = ["Accept":"application/json","Content-Type":"application/json","X-Ethos-Auth":"\(ethosAuth)", "X-Facebook-Id":"\(id)"]
        Alamofire.request("http://meetethos.azurewebsites.net/api/Posts?postId=\(post)", method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { (response) in
                print(response)
                self.getPosts()
        }
        
    }
    
    func block(userID : Int) {
        let headers = ["Accept":"application/json","Content-Type":"application/json","X-Ethos-Auth":"\(ethosAuth)", "X-Facebook-Id":"\(id)"]
        Alamofire.request("http://meetethos.azurewebsites.net/api/Moderation/Block?blockUserId=\(userID)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { (response) in
                print("REPP")
                print(response)
                self.getPosts()
        }
    }
    
    func report(post : PostCard) {
        let report = UIAlertController(title: "Report Post", message: "Thanks for helping us create a positive community. Why are you reporting this?", preferredStyle: UIAlertControllerStyle.alert)
        report.addTextField { (textField) in
            textField.placeholder = "Comments (optional)"
        }
        let rep = UIAlertAction(title: "Report", style: UIAlertActionStyle.default) { (action) in
            // reported
        }
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        report.addAction(rep)
        report.addAction(cancel)
        self.present(report, animated: true, completion: nil)
       MRProgressOverlayView.showOverlayAdded(to: self.view, title: "", mode: MRProgressOverlayViewMode.cross, animated: true)
        let headers = ["Accept":"application/json","Content-Type":"application/json","X-Ethos-Auth":"\(ethosAuth)", "X-Facebook-Id":"\(id)"]
        let params = [  "PostId": post.postID,
                        "Type": 2,
                        "ContentType": post.comment,
                        "UserComments": "iOS does not support user comments yet. More important stuff to fix rn."] as [String : Any]
        Alamofire.request("http://meetethos.azurewebsites.net/api/Moderation/Create", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { (response) in
                print(response)
                self.getPosts()
        MRProgressOverlayView.dismissAllOverlays(for: self.view, animated: true)
    }
    }
    
    func share(index : Int) {
        
        let postController = self.storyboard?.instantiateViewController(withIdentifier: "single") as! OneCardViewController
        postController.oPost = cardsToShow?.object(at: index) as! PostCard?
        self.navigationController?.pushViewController(postController, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            postController.share()

        }

    }
    
    // MARK - Tab bar delegate
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("call")
       if self.navigationController?.tabBarController?.selectedIndex == 0 {
            let index = IndexPath(row: 0, section: 0)
            tableView.scrollToRow(at: index, at: UITableViewScrollPosition.top, animated: true)
        }
    }
  
    
    
    
}
