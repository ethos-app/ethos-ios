//
//  CardStackTableViewController.swift
//  Ethos
//
//  Created by Scott Fitsimones on 8/30/16.
//  Copyright © 2016 Bolt Visual, Inc. All rights reserved.
//

import UIKit

class CardStackTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var bar: UIView!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var cardsButton: UIButton!

    @IBOutlet var netButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = cardsButton.imageView?.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        cardsButton.imageView?.image = image
        cardsButton.setImage(image, forState: UIControlState.Normal)
        cardsButton.imageView?.tintColor = UIColor.hexStringToUIColor("DBE4EE")
        let image2 = netButton.imageView?.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        netButton.imageView?.image = image2
        netButton.setImage(image2, forState: UIControlState.Normal)
        netButton.imageView?.tintColor = UIColor.hexStringToUIColor("DBE4EE")
        
        self.tableView.backgroundColor = UIColor.hexStringToUIColor("e9e9e9")
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.navigationBar.barTintColor = UIColor.hexStringToUIColor("090909")
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.hexStringToUIColor("DBE4EE"), NSFontAttributeName : UIFont(name: "Lobster 1.4", size: 34)!]
            self.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(5, forBarMetrics: UIBarMetrics.Default)
        bar.backgroundColor = UIColor.hexStringToUIColor("50514f")
        
        let standardTextAttributes : [String : AnyObject] = [NSFontAttributeName : UIFont(name: "Raleway-Regular", size: 20)!, NSForegroundColorAttributeName : UIColor.hexStringToUIColor("DBE4EE")]
    
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        bar.frame = CGRectMake(0, bar.frame.origin.y, self.view.frame.width, 60)
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
        return 4
    }

    
     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 170
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
   //     cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
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
