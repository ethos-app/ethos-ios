//
//  CreateGroupViewController.swift
//  Ethos
//
//  Created by Scott Fitsimones on 10/7/16.
//  Copyright © 2016 Bolt Visual, Inc. All rights reserved.
//

import UIKit

class CreateGroupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var img: UIImageView!
    
    @IBOutlet var name: UITextField!
    
    @IBOutlet var dec: UITextField!
    
    var picker : UIImagePickerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.tintColor = Colors.primary
        dec.tintColor = Colors.primary
        name.becomeFirstResponder()
        img.image = UIImage(named: "ic_photo_camera_2x")
        img.layer.cornerRadius = 10
        img.isUserInteractionEnabled = true
        img.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.showImagePicker))
        tap.numberOfTapsRequired = 1
        img.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
        
    }
    
    func showImagePicker() {
        picker = UIImagePickerController()
        picker?.sourceType = .photoLibrary
        picker?.view.tintColor = Colors.primary
        picker?.delegate = self
        picker?.allowsEditing = true
        self.present(picker!, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        img.image = info[UIImagePickerControllerEditedImage] as! UIImage?
        img.contentMode = UIViewContentMode.scaleAspectFill
        img.clipsToBounds = true
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }


    @IBAction func createGroup(_ sender: AnyObject) {
        let groupName = name.text! as AnyObject
        let groupDesc = dec.text! as AnyObject
        let groupImage = UIImageJPEGRepresentation(img.image!, 0.3)
        let base64 = groupImage!.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
        
        let params = ["GroupTitle":groupName, "GroupDescription":groupDesc, "GroupImage":base64] as [String : Any]
    EthosAPI.shared.request(url: "Groups/Create", type: .post, body: params as [String : AnyObject]?) { (reply) in
        print(reply)
        self.presentingViewController?.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func dismiss(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
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
