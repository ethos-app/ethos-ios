//
//  SearchGroupsViewController.swift
//  Ethos
//
//  Created by Scott Fitsimones on 10/1/16.
//  Copyright © 2016 Bolt Visual, Inc. All rights reserved.
//

import UIKit



class SearchGroupsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

   
    @IBOutlet var search: UISearchBar!
    
    @IBOutlet var resultsTable: UITableView!
    
    var groups = NSMutableArray()
    
    var createGroup : GroupCard?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.resultsTable.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0)
        self.resultsTable.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        self.resultsTable.delegate = self
        self.resultsTable.dataSource = self
        self.search.delegate = self
        let done = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.close))
        self.navigationItem.leftBarButtonItem = done
        
        self.navigationController?.navigationBar.barTintColor = UIColor.hexStringToUIColor("247BA0")
        self.title = "Search Groups"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white, NSFontAttributeName : UIFont(name: "Lobster 1.4", size: 30)!]
        self.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(5, for: UIBarMetrics.default)
        createGroup = GroupCard(id: -1)
        createGroup?.groupTitle = "Create a Group"
        createGroup?.groupDesc = "Not finding the group you're looking for?"
        createGroup?.groupType = 0
        createGroup?.groupImg = "http://meetethos.blob.core.windows.net/emojis/group_add.png"
        createGroup?.isCreate = true
        createGroup?.isMember = false
    }
    
    override func viewDidAppear(_ animated : Bool) {
        super.viewDidAppear(animated)
        search.becomeFirstResponder()
        
    }
    
    func updateGroups(response: NSArray) {
        for rep in response {
            if let g = rep as? NSDictionary {
                let group = GroupCard(id: (g.object(forKey: "GroupId")) as! Int)
                group.groupTitle = g.object(forKey: "GroupTitle") as! String
                group.groupDesc = g.object(forKey: "GroupDescription") as! String
                group.groupImg = g.object(forKey: "GroupImage") as! String
                group.groupType = g.object(forKey: "GroupType") as! Int
                group.isMember = g.object(forKey: "IsMember") as! Bool
                group.requestedJoin = g.object(forKey: "Requested") as! Bool
                self.groups.add(group)
            }
        }
      
        self.resultsTable!.reloadData()
    }
    func showCreate() {
        if self.groups.count == 0 {
        self.groups.add(createGroup!)
        self.resultsTable!.reloadData()
        }
    }
    
    func getResults() {
        EthosAPI.shared.request(url: "Groups/Search?q=\(search.text!)", type: .get, body: nil) { (response) in
            if let dict = response as? NSDictionary {
                if let returned = dict.object(forKey: "selectedGroups") as? NSArray {
                    self.groups.removeAllObjects()
                    print(returned)
                    self.updateGroups(response: returned)
                } else {
                    self.showCreate()
                }
            }
            // handle response
        }
    }
    func create() {
        let create = self.storyboard?.instantiateViewController(withIdentifier: "createGroup") as! CreateGroupViewController
        self.present(create, animated: true, completion: nil)
    }
    func close() {
        self.dismiss(animated: true)
    }
    func join(id : Int) {
        EthosAPI.shared.request(url: "Groups/JoinGroup?GroupId=\(id)", type: .get, body: nil) { (reply) in
            print(reply!)
        }
    }
    func getGroup(rec : UIButton) {
        let index = rec.tag
        let group = groups.object(at: index) as! GroupCard
        if group.isCreate {
        create()
        } else {
        rec.setTitle("Joined", for: UIControlState.normal)
        join(id : group.groupID)
        }
    }
    func show(card : GroupCard) {
        let groupController = self.storyboard?.instantiateViewController(withIdentifier: "group") as! GroupViewController
        groupController.showID = card.groupID
        groupController.groupCard = card
        self.navigationController?.pushViewController(groupController, animated: true)
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = resultsTable.dequeueReusableCell(withIdentifier: "c") as! GroupTableViewCell
        let groupObj = groups.object(at: indexPath.row) as! GroupCard
        cell.groupTitle.text = groupObj.groupTitle
        cell.groupDesc.text = groupObj.groupDesc
        print("HELLO")
        print(groupObj.groupImg)
        if groupObj.groupImg != "" {

        let link = URL(string: groupObj.groupImg)
        cell.groupImg.hnk_setImageFromURL(link!)
        cell.option?.tag = indexPath.row
        }
        if groupObj.requestedJoin {
              cell.option?.setTitle("Pending", for: UIControlState.normal)
             cell.option?.sizeToFit()
        } else if groupObj.isMember {
             cell.option?.setTitle("Go", for: UIControlState.normal)
        }  else if  groupObj.isCreate {
            cell.option?.setTitle("Create", for: UIControlState.normal)
        } else {
            cell.option?.setTitle("Join", for: UIControlState.normal)
        }
        
        cell.option?.addTarget(self, action: #selector(getGroup(rec:)), for: UIControlEvents.touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.resultsTable.deselectRow(at: indexPath, animated: true)
        let group = groups.object(at: indexPath.row) as! GroupCard
        if group.isCreate {
        create()
        } else if group.isPending == false  {
        show(card: group)
        }
    }
    
     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if search.text!.characters.count > 2 {
            self.getResults()
        } else if search.text == "" {
            self.groups.removeAllObjects()
            self.resultsTable.reloadData()
        }
    }
    
    

}
