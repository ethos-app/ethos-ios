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
import SwiftLinkPreview

class OneCardViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, CardViewDelegate, UITextViewDelegate, UIGestureRecognizerDelegate, ImageSeekDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var ethosAuth = ""
    var id = ""
    var cardsToShow : NSMutableArray?
    
    @IBOutlet var bar: UIView!
    
    @IBOutlet var cardsButton: BarButton!
    
    @IBOutlet var netButton: BarButton!
    
    @IBOutlet var tableView: UITableView!
    
    var segment = 0
    
    var lookingFrame : CGRect?
    var cardView : CardContainerView?
    
    @IBOutlet var postBox: PostBox!
    var showingImage = false
    var writingPost = false
    var uplaodImage : UIImage?
    var postType = 0
    
    var picker : DKImagePickerController?
    
     var oPost : PostCard?
    
    
    @IBOutlet var comments: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
  
        
        let myFrame = CGRect(x: 0, y: 120, width: self.view.frame.width, height: self.view.frame.height-120)
        cardView = CardContainerView(frame: myFrame)
        UIApplication.shared.keyWindow?.addSubview(cardView!)
        cardView?.alpha = 0
        
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
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white, NSFontAttributeName : UIFont(name: "Lobster 1.4", size: 34)!]
        self.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(5, for: UIBarMetrics.default)
        
        let refreshC = UIRefreshControl()
        refreshC.addTarget(self, action: #selector(self.refreshContent(_:)), for: UIControlEvents.allEvents)
        self.tableView.addSubview(refreshC)
        
        
        self.view.backgroundColor = UIColor.hexStringToUIColor("c9c9c9")
        if FBSDKAccessToken.current() != nil {
            verifyToken()
        }
        else {
            let login = LoginViewController()
            //       self.navigationController?.pushViewController(login, animated: true)
            self.present(login, animated: true, completion: nil)
        }
        
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
        self.cardsToShow?.removeAllObjects()
        self.getPosts()
        self.getComments()
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
    
    
    func verifyToken() {
        print("VERIFYING")
        let id = FBSDKAccessToken.current().userID
        if let token = UserDefaults.standard.object(forKey: "token") as? String {
            if let id = UserDefaults.standard.object(forKey: "id") as? String {
                self.ethosAuth = token
                self.id = id
            }
        }
        
        let headers = ["Accept":"application/json","Content-Type":"application/json","X-Ethos-Auth":ethosAuth, "X-Facebook-Id":"\(id!)"]
        Alamofire.request("http://meetethos.azurewebsites.net/api/Users/AuthChecker", method: .get,parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { (response) in
                if let status = response.result.value as? NSDictionary {
                    print(status)
                    let ok = status.object(forKey: "status") as! String
                    print(ok)
                    print("YES")
                    if ok == "ok" {
                        self.updateFriends()
                        self.cardsToShow?.removeAllObjects()
                        self.getPosts()
                        self.getComments()
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
        if FBSDKAccessToken.current() != nil {
            if ethosAuth == "" {
                verifyToken()
            }
        }
        
    }
    
    
    func shouldMoveCard(_ card: CardView) -> Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        postBox.textView?.delegate = self
        postBox.delegate = self
        //     cardsButton.selectMe()
        //     netButton.deselectMe()
    }
    
    func updatePosts(_ array : NSArray) {
    
        for cardDictionary in array {
            let dict = cardDictionary as! NSDictionary
            let emoji = dict.object(forKey: "PosterEmoji") as! String
            let userText = dict.object(forKey: "UserText") as! String
            let type = dict.object(forKey: "Type") as! Int
            let dataCard = PostCard(posterEmoji: emoji, userText: userText, type: type)
            if let likeC = dict.object(forKey: "LikeCount") as? Int {
            dataCard.likeCount = likeC
            }
            dataCard.postID = dict.object(forKey: "PostId") as! Int
            if let comID = dict.object(forKey: "CommentId") as? Int {
            dataCard.comment = true
            dataCard.commentId = comID
            } else {
            dataCard.comment = false
            }
            if let liked =  dict.object(forKey: "UserLiked") as? Int {
            dataCard.userLiked = liked
            }
            dataCard.userOwned = dict.object(forKey: "UserOwned") as! Int
            if let cc = dict.object(forKey: "CommentCount") as? Int {
            dataCard.commentCount = cc
            }
            if let groupp = dict.object(forKey: "GroupId") as? Int {
            dataCard.groupID = groupp
            }
            if let lc = dict.object(forKey: "LikeCount") as? Int {
            dataCard.likeCount = lc
            }
            dataCard.posterID = dict.object(forKey: "PosterId") as! Int;
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
            let dater = formatter.string(from: date!)
            let result = date!.getElapsedInterval()
            dataCard.date = result
            print("CARDE")
            print(dataCard.userText)

            print(dataCard.comment)

            if dataCard.comment == false {
                print("FIRSTED")
            self.cardsToShow?.insert(dataCard, at: 0)
            } else {
                self.cardsToShow?.add(dataCard)

            }

        }
        self.tableView.reloadData()
    }
    func getPosts() {
        print("GET POSTS")
        
        
        let view = MRProgressOverlayView.showOverlayAdded(to: self.view, title: "", mode: MRProgressOverlayViewMode.indeterminate,
                                                          animated: true)
        view?.setTintColor(UIColor.hexStringToUIColor("247BA0"))
        //  view.createBlurView()
        self.cardsToShow?.removeAllObjects()
        print("TOKENS")
        print(ethosAuth)
        print(id)
        let postID = oPost!.postID
        let headers = ["Accept":"application/json","Content-Type":"application/json","X-Ethos-Auth":"\(ethosAuth)", "X-Facebook-Id":"\(id)"]
        Alamofire.request("http://meetethos.azurewebsites.net/api/Posts/\(postID)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { (response) in
                print(response)
                MRProgressOverlayView.dismissAllOverlays(for: self.view, animated: true)
                let array = response.result.value! as! NSDictionary
                let post = array.object(forKey: "selectedPost")
                self.updatePosts([post])
        }
    }
    
    func getComments() {
        print("GET COMMENTS")
        let view = MRProgressOverlayView.showOverlayAdded(to: self.view, title: "", mode: MRProgressOverlayViewMode.indeterminate,animated: true)
        view?.setTintColor(UIColor.hexStringToUIColor("247BA0"))
        //  view.createBlurView()
        self.cardsToShow?.removeAllObjects()
        print("TOKENS")
        print(ethosAuth)
        print(id)
        let postID = oPost!.postID
        print(postID)
        let headers = ["Accept":"application/json","Content-Type":"application/json","X-Ethos-Auth":"\(ethosAuth)", "X-Facebook-Id":"\(id)"]
        Alamofire.request("http://meetethos.azurewebsites.net/api/Comments?postId=\(postID)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { (response) in
                print(response)
                MRProgressOverlayView.dismissAllOverlays(for: self.view, animated: true)
                let array = response.result.value! as! NSDictionary
                if let posts = array.object(forKey: "selectedComments") as? NSArray {
                    print(posts)
                    self.updatePosts(posts)
                    
                } else {
                    MRProgressOverlayView.dismissAllOverlays(for: self.view, animated: true)
                    
                }
        }
    }
    
    func post() {
        let content = postBox.textView?.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        let headers = ["Accept":"application/json","Content-Type":"application/json","X-Ethos-Auth":"\(ethosAuth)", "X-Facebook-Id":"\(id)"]
        var mediaContent = "NULL"
        if postType == 2 { // Image Post
            let imageData = UIImageJPEGRepresentation(self.uplaodImage!, 0.3)
            
            let base64 = imageData?.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
            mediaContent = base64!
        }
        print("REPLY SEND")
        
        let params = ["UserText" : content!, "Content" : mediaContent, "CommentType" : postType as AnyObject, "PostId": oPost!.postID, "ResponseIds" : [] ] as [String : Any]
        print(params)
        Alamofire.request("http://meetethos.azurewebsites.net/api/Comments/Create", method: .post,parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { (response) in
                print(response)
                self.postBox.resetText()
                self.stopWritingPost()
                self.cardsToShow?.removeAllObjects()
                self.getPosts()
                self.getComments()
                
        }
    }
    func selectCards() {
        cardsButton.selectMe()
        segment = 0
        tableView.alpha = 1
        cardView?.alpha = 0
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
        cardView?.alpha = 1
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
        let postController = self.storyboard?.instantiateViewController(withIdentifier: "post") as! FullPostTableViewController
        
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(cardsToShow?.count)
        return cardsToShow!.count
    }
    
    
    func showOptions() {
        let alert =  UIAlertController(title: "Options", message: "", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        let share = UIAlertAction(title: "Share", style: .default) { (report) in
            //
        }
        let report = UIAlertAction(title: "Report", style: .default) { (report) in
            ///
        }
        let block = UIAlertAction(title: "Block User", style: .destructive) { (report) in
            //
        }
        alert.addAction(cancel)
        alert.addAction(share)
        alert.addAction(report)
        alert.addAction(block)
        
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
            if currentObject.comment == true {
                cellType = "image"
            }
        } else if type == 2 {
            cellType = "image"
        }
        print(type)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellType, for: indexPath) as? BizCardTableViewCell
        if currentObject.comment == true {
        cell?.bottomBar.alpha = 0
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        let imageURL = URL(string: currentObject.posterEmoji)
        let data = try? Data(contentsOf: imageURL!)
        cell?.img.image = UIImage(data: data!)
        cell?.img.contentMode = UIViewContentMode.scaleAspectFit
        
        cell?.desc.text = currentObject.userText
        cell!.date.text = currentObject.date
        
        cell!.options.addTarget(self, action: #selector(BizCardTableViewCell.showOptions), for: UIControlEvents.touchUpInside)
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
        let likes = currentObject.likeCount
        cell?.likesCount = likes
        cell?.comment.setTitle("\(commented)", for: UIControlState.normal)
        
        let like = UITapGestureRecognizer(target: self, action: #selector(CardStackTableViewController.like(_:)))
        like.cancelsTouchesInView = false
        like.numberOfTapsRequired = 1
        like.numberOfTouchesRequired = 1
        cell?.react?.tag = (indexPath as NSIndexPath).row
        cell?.react?.addGestureRecognizer(like)
        cell?.setCount(currentObject.likeCount)
        if currentObject.likeCount > 0 {
            cell?.react?.setTitle("\(currentObject.likeCount)", for: UIControlState())
        }
        
        cell?.tag = (indexPath as NSIndexPath).row
        if type == 1 && cellType == "link" {
        
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
            
            let myView = LnikViewer.loadFromNibNamed(nibNamed: "LinkViewBox") as! LnikViewer
            myView.linkImage.image = UIImage(named: "invalid_image")

            
            print(currentObject.content)
            let swiftLink = SwiftLinkPreview()
            print(self.canOpenURL(string: currentObject.content))
            if self.canOpenURL(string: currentObject.content) {
                swiftLink.preview(currentObject.content, onSuccess: { (success) in
                    print("SUCC")
                    print(success)
                    if success.count > 0 {
                        
                        myView.linkTitle.text = success["title"] as! String?
                        myView.linkURL.text = success["canonicalUrl"] as! String?
                        myView.linkDesc.text = success["description"] as! String?
                        let url = success["image"] as! String?
                        let fileURL = URL(string: url!)
                        
                        let task =   URLSession.shared.dataTask(with: fileURL!, completionHandler: { (myData, response, error) in
                            DispatchQueue.main.async(execute: {
                                if (indexPath as NSIndexPath).row == cell?.tag {
                                    let myImage = UIImage(data: myData!)
                                    currentObject.linkImage = myImage
                                    myView.linkImage.image = myImage
                                    
                                }
                            })
                        })
                        task.resume()
                        
                    }
                    }, onError: { (fail) in
                        // could not generate
                        print("FAIL")
                        print(fail)

                })
                
            }
            //    let embeddedView = URLEmbeddedView()
            //      embeddedView.loadURL(currentObject.content)
            if cell!.linkStack.arrangedSubviews.count < 1 {
                cell?.linkStack.addArrangedSubview(myView)
                
            }
        }
        if cellType == "image" {
            cell?.userImage.image = nil
            //    cell?.desc.text = "\n\n\n\n\n\n\n\n\n\n\n\n"
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
            
        }
    }
    
    // MARK: Text View Delegate methods
    func textViewDidBeginEditing(_ textView: UITextView) {
        writingPost = true
        print("began")
        textView.text = ""
        textView.textColor = UIColor.black
        let postButton = UIBarButtonItem(title: "Reply", style: UIBarButtonItemStyle.done, target: self, action: #selector(CardStackTableViewController.post))
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
}
