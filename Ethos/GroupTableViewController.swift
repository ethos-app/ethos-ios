//
//  GroupTableViewController.swift
//  Ethos
//
//  Created by Scott Fitsimones on 9/24/16.
//  Copyright © 2016 Bolt Visual, Inc. All rights reserved.
//

import UIKit
import Alamofire
import FBSDKCoreKit
class GroupTableViewController: UITableViewController {
    var ethosAuth = ""
    var id = ""
    var groups : NSMutableArray?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Groups", style: UIBarButtonItemStyle.plain, target: self, action: nil)
        
        self.tableView.backgroundColor = UIColor.hexStringToUIColor("e9e9e9")
        groups = NSMutableArray()
        self.navigationController?.navigationBar.barTintColor = UIColor.hexStringToUIColor("247BA0")
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white, NSFontAttributeName : UIFont(name: "Lobster 1.4", size: 34)!]
        self.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(5, for: UIBarMetrics.default)
        verifyToken()
        
    }
    func verifyToken() {
        if let token = UserDefaults.standard.object(forKey: "token") as? String {
            if let id = UserDefaults.standard.object(forKey: "id") as? String {
                self.ethosAuth = token
                self.id = id
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getGroups()
    }
    func getGroups() {
    let headers = ["Accept":"application/json","Content-Type":"application/json","X-Ethos-Auth":"\(ethosAuth)", "X-Facebook-Id":"\(id)"]
     Alamofire.request("http://meetethos.azurewebsites.net/api/Group", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
        .responseJSON { (response) in
            self.groups?.removeAllObjects()
            if let groups = response.result.value as? NSDictionary {
                let list = groups.object(forKey: "selectedGroups") as! NSArray
                self.update(groups: list)
            }
        }
    }
    func update(groups: NSArray) {
        for group in groups {
            let g = group as! NSDictionary
            let gid = g.object(forKey: "GroupId")
            let group = GroupCard(id: gid as! Int)
            group.groupTitle = g.object(forKey: "GroupTitle") as! String
            group.groupDesc = g.object(forKey: "GroupDescription") as! String
            group.groupImg = g.object(forKey: "GroupImage") as! String
            group.groupOwner = g.object(forKey: "GroupOwner") as! Int
            group.groupType = g.object(forKey: "GroupType") as! Int
            group.isOwner = g.object(forKey: "IsOwner") as! Bool
            group.isModerator = g.object(forKey: "IsModerator") as! Bool
            self.groups?.add(group)
        }
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func show(group : Int, card : GroupCard) {
        let groupController = self.storyboard?.instantiateViewController(withIdentifier: "group") as! GroupViewController
        groupController.showID = group
        groupController.groupCard = card
        self.navigationController?.pushViewController(groupController, animated: true)

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groups!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GroupTableViewCell
     
        let source = groups?.object(at: indexPath.row) as! GroupCard
        cell.groupTitle.text = source.groupTitle
        cell.groupDesc.text = source.groupDesc
        let url = URL(string: source.groupImg)
        cell.groupImg.hnk_setImageFromURL(url!)
        
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let source = groups?.object(at: indexPath.row) as! GroupCard
        let id = source.groupID
        show(group: id, card: source)
    }

}
