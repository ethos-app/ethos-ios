//
//  IntroGroupsTableViewController.swift
//  Ethos
//
//  Created by Scott Fitsimones on 10/5/16.
//  Copyright © 2016 Bolt Visual, Inc. All rights reserved.
//


import UIKit
import Alamofire
import FBSDKCoreKit

class IntroGroupsTableViewController: UITableViewController, GroupDelegate {
    var ethosAuth = ""
    var id = ""
    var groups : NSMutableArray?
    var suggest = NSMutableArray()
    var float : UIButton?
    var suggestionView : GroupRecommend?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let newGroups = UIBarButtonItem(image: UIImage(named: "ic_add_white"), style: UIBarButtonItemStyle.done, target: self, action: #selector(self.showGroups))
        self.navigationItem.rightBarButtonItem = newGroups
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Groups", style: UIBarButtonItemStyle.plain, target: self, action: nil)
        
        self.tableView.backgroundColor = UIColor.hexStringToUIColor("e9e9e9")
        groups = NSMutableArray()
        self.navigationController?.navigationBar.barTintColor = UIColor.hexStringToUIColor("247BA0")
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white, NSFontAttributeName : UIFont(name: "Lobster 1.4", size: 30)!]
        self.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(5, for: UIBarMetrics.default)
        verifyToken()
        
        let done = UIButton()
        done.setTitle("Done", for: UIControlState.normal)
        done.frame = CGRect(x: self.view.frame.width-70, y: 25, width: 70, height: 30)
    done.setTitleColor(UIColor.hexStringToUIColor("247BA0"), for: UIControlState.normal)
        done.addTarget(self, action: #selector(self.leave), for: UIControlEvents.touchUpInside)
        self.view.addSubview(done)
    }
    func leave() {
        self.dismiss(animated: true, completion: nil)
    }
    func showGroups() {
        let groups = self.storyboard?.instantiateViewController(withIdentifier: "groups") as! SearchGroupsViewController
        let navCase = UINavigationController(rootViewController: groups)
        self.present(navCase, animated: true, completion: nil)
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
        print("Getting")
        let headers = ["Accept":"application/json","Content-Type":"application/json","X-Ethos-Auth":"\(ethosAuth)", "X-Facebook-Id":"\(id)"]
        Alamofire.request("http://meetethos.azurewebsites.net/api/Groups/Default", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { (response) in
                print(response)
                if let groups = response.result.value as? NSDictionary {
                    if let list = groups.object(forKey: "selectedGroups") as? NSArray {
                        self.update(groups: list)
                    }
                }
        }
    }
    func groupWith(id : Int) {
        
        EthosAPI.shared.request(url: "Group?groupId=\(id)", type: .get, body: nil) { (reply) in
            let reply = reply as! NSDictionary
            print(reply)
            if let g = reply.object(forKey: "selectedGroup") as? NSDictionary {
                let gid = g.object(forKey: "GroupId")
                let group = GroupCard(id: gid as! Int)
                
                group.groupTitle = g.object(forKey: "GroupTitle") as! String
                group.groupDesc = g.object(forKey: "GroupDescription") as! String
                group.groupImg = g.object(forKey: "GroupImage") as! String
                group.groupOwner = g.object(forKey: "GroupOwner") as! Int
                group.groupType = g.object(forKey: "GroupType") as! Int
                group.isOwner = g.object(forKey: "IsOwner") as! Bool
                group.isModerator = g.object(forKey: "IsModerator") as! Bool
                group.isFeatured = g.object(forKey: "IsFeatured") as! Bool
                group.isMember = g.object(forKey: "IsMember") as! Bool
                self.show(group: id, card: group)
            }
        }
        
    }
    func update(groups: NSArray) {
        print("UPDATING")
        self.groups?.removeAllObjects()
        for group in groups {
            let g = group as! NSDictionary
            print(g)
            let gid = g.object(forKey: "GroupId")
            let group = GroupCard(id: gid as! Int)

            group.groupTitle = g.object(forKey: "GroupTitle") as! String
            group.groupDesc = g.object(forKey: "GroupDescription") as! String
            group.groupImg = g.object(forKey: "GroupImage") as! String
            group.groupType = g.object(forKey: "GroupType") as! Int
            self.groups?.add(group)

           print("Here")
        }
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    func showGroup(id: Int) {
        print("Show %i", id)
        groupWith(id: id)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "c", for: indexPath) as! GroupTableViewCell
        let source = groups?.object(at: indexPath.row) as! GroupCard
        cell.groupTitle.text = source.groupTitle
        cell.groupDesc.text = source.groupDesc
        cell.groupTitle.sizeToFit()
        cell.groupDesc.sizeToFit()
        let url = URL(string: source.groupImg)
        cell.groupImg.hnk_setImageFromURL(url!)
        cell.option?.tag = indexPath.row
        cell.option?.addTarget(self, action: #selector(getGroup(rec:)), for: UIControlEvents.touchUpInside)
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
    
    func join(id : Int) {
        EthosAPI.shared.request(url: "Groups/JoinGroup?GroupId=\(id)", type: .get, body: nil) { (reply) in
            print(reply!)
        }
    }
    func getGroup(rec : UIButton) {
        let index = rec.tag
        rec.setTitle("Joined", for: UIControlState.normal)
        let group = groups?.object(at: index) as! GroupCard
        join(id : group.groupID)
    }
    
}

