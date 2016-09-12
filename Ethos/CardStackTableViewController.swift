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

class CardStackTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CardViewDelegate, UITextViewDelegate {
    
    var ethosAuth = ""
    var id = ""
    var cardsToShow : NSMutableArray?
    
    @IBOutlet var bar: UIView!
    
    @IBOutlet var cardsButton: BarButton!
    
    @IBOutlet var netButton: BarButton!
    
    @IBOutlet var tableView: UITableView!
    
    var segment = 0
    
    var cardView : CardContainerView?
    
    
    @IBOutlet var postBox: PostBox!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let request = NSMutableURLRequest(URL: url!)
        //        request.addValue("Bearer \(userToken?.idToken)", forHTTPHeaderField: "Authorization")
        //        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
        //            let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
        //            print(json)
        //            print("break")
        //            print(response)
        //            print(error)
        //
        //        }.resume()
        
        let myFrame = CGRectMake(0, 120, self.view.frame.width, self.view.frame.height-120)
        cardView = CardContainerView(frame: myFrame)
        UIApplication.sharedApplication().keyWindow?.addSubview(cardView!)
        cardView?.alpha = 0
        
        cardsToShow = NSMutableArray()
        //        cardsButton.imageFile = UIImage(named: "ic_home")
        //        cardsButton.label = "News Feed"
        //        cardsButton.backgroundColor = UIColor.clearColor()
        //        let gesture = UITapGestureRecognizer(target: self, action: "selectCards")
        //        cardsButton.addGestureRecognizer(gesture)
        //
        //        netButton.imageFile = UIImage(named: "ic_textsms")
        //        netButton.label = "    Notifications"
        //        netButton.backgroundColor = UIColor.clearColor()
        //        let gesture2 = UITapGestureRecognizer(target: self, action: "selectNet")
        //        netButton.addGestureRecognizer(gesture2)
        
        self.tableView.backgroundColor = UIColor.hexStringToUIColor("e9e9e9")
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let touch = UITapGestureRecognizer(target: self, action: #selector(self.stopWritingPost))
        self.tableView.addGestureRecognizer(touch)
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.navigationBar.barTintColor = UIColor.hexStringToUIColor("247BA0")
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName : UIFont(name: "Lobster 1.4", size: 34)!]
        self.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(5, forBarMetrics: UIBarMetrics.Default)
        
        
        // bar.backgroundColor = UIColor.whiteColor()
        
        let standardTextAttributes : [String : AnyObject] = [NSFontAttributeName : UIFont(name: "Raleway-Regular", size: 20)!, NSForegroundColorAttributeName : UIColor.hexStringToUIColor("DBE4EE")]
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        //  bar.frame = CGRectMake(0, bar.frame.origin.y, self.view.frame.width, 40)
        self.view.backgroundColor = UIColor.hexStringToUIColor("e9e9e9")
        createCards()
        
        //        let blur = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
        //        let effectView = UIVisualEffectView(effect: blur)
        //        effectView.alpha = 0.65
        //        effectView.frame = tableView.frame
        //        self.view.addSubview(effectView)
    }
    
//    func updateFriends() {
//        let headers = ["Accept":"application/json","Content-Type":"application/json","X-Ethos-Auth":"\(ethosAuth)", "X-Facebook-Id":"\(id)"]
//        friends =
//        Alamofire.request(.PUT, "api/Users/Me/Friends", parameters: params, encoding: .JSON, headers: headers)
//            .responseJSON { (response) in
//                print(response)
//        }
//        
//    }
    override func viewWillAppear(animated: Bool) {
        if let token = NSUserDefaults.standardUserDefaults().objectForKey("token") as? String {
            if let id = NSUserDefaults.standardUserDefaults().objectForKey("id") as? String {
                self.ethosAuth = token
                self.id = id
             //   updateFriends()
            }
        } else {
            let login = LoginViewController()
            self.presentViewController(login, animated: true, completion: nil)
        }
        getPosts()
        
    }
    
    
    func shouldMoveCard(card: CardView) -> Bool {
        return true
    }
    func createCards() {
        let firstCard = PostCard(posterEmoji: "https://meetethos.blob.core.windows.net/emojis/emoji1.png", userText: "Lorem ipsum doler sit amet nigga what geetyy wap", content: "yep", type: 0)
        
        let secondCard = PostCard(posterEmoji: "https://meetethos.blob.core.windows.net/emojis/emoji2.png", userText: "Quality content here. Yeah, top notch. This is a long rant. We will see how this table cell expands. Yeah. Keep expanding. That's right, iOS. I am your master. Get used to it. ", content: "yep", type: 0)
        
        cardsToShow?.addObject(firstCard)
        cardsToShow?.addObject(secondCard)

        
        self.tableView.reloadData()
    }
    override func viewDidAppear(animated: Bool) {
        postBox.textView?.delegate = self
        //     cardsButton.selectMe()
        //     netButton.deselectMe()
    }
    
    func getPosts() {
        
        let headers = ["Accept":"application/json","Content-Type":"application/json","X-Ethos-Auth":"\(ethosAuth)", "X-Facebook-Id":"\(id)"]
        
        Alamofire.request(.GET, "http://meetethos.azurewebsites.net/api/Posts", parameters: nil, encoding: .JSON, headers: headers)
            .responseJSON { (response) in
                print(response)
        }
        
    }
    func post() {
        let content = postBox.textView?.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let headers = ["Accept":"application/json","Content-Type":"application/json","X-Ethos-Auth":"\(ethosAuth)", "X-Facebook-Id":"\(id)"]
        
        let params : [String : AnyObject] = ["UserText" : content! , "Content" : "NULL", "PostType" : 0, "GroupId":""]
        Alamofire.request(.POST, "http://meetethos.azurewebsites.net/api/Create", parameters: params, encoding: .JSON, headers: headers)
            .responseJSON { (response) in
                print(response)
                self.postBox.resetText()
        }
    }
    func selectCards() {
        cardsButton.selectMe()
        segment = 0
        tableView.alpha = 1
        cardView?.alpha = 0
        let saveFrame = netButton.bottomLine?.frame
        UIView.animateWithDuration(0.3, animations: {
            self.netButton.bottomLine?.frame = CGRectOffset(self.netButton.bottomLine!.frame, -120, 0)
        }) { (done) in
            if done {
                self.netButton.deselectMe()
                self.netButton.bottomLine?.frame = saveFrame!
            }
        }
    }
    func selectNet() {
        netButton.selectMe()
        segment = 1
        tableView.alpha = 0
        cardView?.alpha = 1
        let saveFrame = cardsButton.bottomLine?.frame
        UIView.animateWithDuration(0.3, animations: {
            self.cardsButton.bottomLine?.frame = CGRectOffset(self.cardsButton.bottomLine!.frame, 125, 0)
        }) { (done) in
            if done {
                self.cardsButton.deselectMe()
                self.cardsButton.bottomLine?.frame = saveFrame!
            }
        }
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cardsToShow!.count
    }
    
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 145
//    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? BizCardTableViewCell
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        let currentObject = cardsToShow![indexPath.row] as! PostCard
        let imageURL = NSURL(string: currentObject.posterEmoji)
        let data = NSData(contentsOfURL: imageURL!)
        cell?.img.image = UIImage(data: data!)
        cell?.img.contentMode = UIViewContentMode.ScaleAspectFit
        cell?.desc.text = currentObject.userText
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        stopWritingPost()
    }
    
    // MARK: Text View Delegate methods
    func textViewDidBeginEditing(textView: UITextView) {
        print("began")
        textView.text = ""
        textView.textColor = UIColor.blackColor()
        let postButton = UIBarButtonItem(title: "Post", style: UIBarButtonItemStyle.Done, target: self, action: #selector(CardStackTableViewController.post))
        self.navigationItem.setRightBarButtonItem(postButton, animated: true)
        self.tableView.alpha = 0.15
        
        self.postBox.textView?.becomeFirstResponder()
    }
    
    func stopWritingPost() {
        self.tableView.alpha = 1.0
        let postButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Done, target: self, action: #selector(CardStackTableViewController.post))
        self.navigationItem.setRightBarButtonItem(postButton, animated: true)
        if ((postBox.textView?.text.isEmpty) != nil) {
            postBox.resetText()
            postBox.textView?.resignFirstResponder()
        }
        
    }
    
    
}
