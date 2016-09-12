//
//  CardStackTableViewController.swift
//  Ethos
//
//  Created by Scott Fitsimones on 8/30/16.
//  Copyright © 2016 Bolt Visual, Inc. All rights reserved.
//


import UIKit
class NotifyTableViewController: UITableViewController, CardViewDelegate, UITextViewDelegate {
    
    var cardsToShow : NSMutableArray?
    
    @IBOutlet var bar: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //        let url = NSURL(string: "http://meetethos.azurewebsites.net/api/matches/get")
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
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.tableView.delegate = self
        self.tableView.dataSource = self
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
    }
    
    func shouldMoveCard(card: CardView) -> Bool {
        return true
    }
    func createCards() {
        

        
        self.tableView.reloadData()
    }
    override func viewDidAppear(animated: Bool) {
        //     cardsButton.selectMe()
        //     netButton.deselectMe()
    }
    func sidebar() {
        
    }
    func post() {
        
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? UITableViewCell
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
       
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    

    
}
