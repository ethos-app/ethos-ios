//
//  CreateGroupViewController.swift
//  Ethos
//
//  Created by Scott Fitsimones on 10/7/16.
//  Copyright © 2016 Bolt Visual, Inc. All rights reserved.
//

import UIKit

class CreateGroupViewController: UIViewController {

    @IBOutlet var img: UIImageView!
    
    @IBOutlet var name: UITextField!
    
    @IBOutlet var dec: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    @IBAction func createGroup(_ sender: AnyObject) {
        let groupName = name.text!
        let groupDesc = dec.text!
        let groupImage = UIImagePNGRepresentation(img.image!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
