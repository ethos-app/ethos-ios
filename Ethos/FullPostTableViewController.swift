//
//  FullPostTableViewController.swift
//  Ethos
//
//  Created by Scott Fitsimones on 9/17/16.
//  Copyright © 2016 Bolt Visual, Inc. All rights reserved.
//

import UIKit

class FullPostTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var oPost : PostCard?
    
    
    @IBOutlet var commentTable: UITableView!
    
    override func viewDidLoad() {
        //
        commentTable.dataSource = self
        commentTable.delegate = self
        commentTable.allowsSelection = false
        
    }
    override func viewDidAppear(_ animated: Bool) {
        //
    }
    
    // MARK - tableview delegate methods
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let card = OPCard.loadFromNibNamed(nibNamed: "PostXib") as! OPCard
        card.content.text = oPost?.userText
        
        return card
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentTable.dequeueReusableCell(withIdentifier: "cell")
        
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}

