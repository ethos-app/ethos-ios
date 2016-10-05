//
//  ProfileViewController.swift
//  Ethos
//
//  Created by Scott Fitsimones on 10/1/16.
//  Copyright © 2016 Bolt Visual, Inc. All rights reserved.
//

import UIKit
import Alamofire
import Haneke

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    @IBOutlet var bigImg: UIImageView!
    
    @IBOutlet var chnage: UIButton!
    
    @IBOutlet var history: UIButton!
    
    @IBOutlet var done: UIButton!
    
    var id = ""
    var ethosAuth = ""
    var emojiKey : UICollectionView?
    var emojiList : NSMutableArray?
    var myEmoji : URL?
    var header : UILabel?
    
    @IBAction func done(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeMoji(_ sender: AnyObject) {
        UIView.animate(withDuration: 0.3, animations: { 
            // Animation
            let height =  self.bigImg.frame.origin.y+self.bigImg.frame.height+20
            let lowerHalf = CGRect(x: 0, y:height, width: self.view.frame.width, height: self.view.frame.height-height)
            self.emojiKey?.frame = lowerHalf
            }, completion: nil)
       
    }
    @IBAction func showHistory(_ sender: AnyObject) {
        let postController = self.storyboard?.instantiateViewController(withIdentifier: "cards") as! CardStackTableViewController
        postController.showingType = CardStackTableViewController.ShowType.my
        let navigationCase = UINavigationController(rootViewController: postController)
        self.present(navigationCase, animated: true, completion: nil)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emojiList = NSMutableArray()
        let height =  self.view.frame.height
        let lowerHalf = CGRect(x: 0, y:height, width: self.view.frame.width, height: self.view.frame.height-height)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical
        flowLayout.itemSize = CGSize(width: 72, height: 72)
        flowLayout.minimumLineSpacing = 3
        flowLayout.minimumInteritemSpacing = 0
        emojiKey = UICollectionView(frame: lowerHalf, collectionViewLayout: flowLayout)
        emojiKey?.backgroundColor = UIColor.hexStringToUIColor("164E66")
        emojiKey?.delegate = self
        emojiKey?.dataSource = self
        emojiKey?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.view.addSubview(emojiKey!)
        self.chnage.setTitleColor(UIColor.hexStringToUIColor("247BA0"), for: UIControlState.normal)
         self.history.setTitleColor(UIColor.hexStringToUIColor("247BA0"), for: UIControlState.normal)
         self.done.setTitleColor(UIColor.hexStringToUIColor("247BA0"), for: UIControlState.normal)
        getEmojiURL()
        loadEm()
        bigImg.isUserInteractionEnabled = true
        let dismiss = UITapGestureRecognizer(target: self, action: #selector(self.close))
        dismiss.cancelsTouchesInView = false
        dismiss.numberOfTapsRequired = 1
        
        self.bigImg.addGestureRecognizer(dismiss)
    }
    func close() {
        print("CALL")
        UIView.animate(withDuration: 0.3, animations: {
            let height =  self.view.frame.height
            let lowerHalf = CGRect(x: 0, y:height, width: self.view.frame.width, height: self.view.frame.height-height)
            self.emojiKey?.frame = lowerHalf
            }, completion: nil)
    }

    func setEmoji() {
        let headers = ["Accept":"application/json","Content-Type":"application/json","X-Ethos-Auth":"\(ethosAuth)", "X-Facebook-Id":"\(id)"]
        bigImg.hnk_setImageFromURL(myEmoji!)
         Alamofire.request("http://meetethos.azurewebsites.net/api/Profile/Me?emojiUrl=\(myEmoji!)", method: .put, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { (done) in
               print(done)
        }
    }
    func loadEm() {
        Alamofire.request("http://meetethos.azurewebsites.net/api/Emoji/All")
            .responseJSON { (done) in
                if let response = done.result.value as? NSArray {
                    for emString in response {
                        if let responseURL = emString as? String {
                            let url = URL(string: responseURL)
                            self.emojiList?.add(url!)
                            self.emojiKey?.reloadData()
                        }
                    }
                }
                
        }
        
    }

    func getEmojiURL() {
        let headers = ["Accept":"application/json","Content-Type":"application/json","X-Ethos-Auth":"\(ethosAuth)", "X-Facebook-Id":"\(id)"]
        Alamofire.request("http://meetethos.azurewebsites.net/api/Profile/myEmoji", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
        .responseJSON { (response) in
            if let url = response.result.value as? String {
                if let address = URL(string: url) {
                    print(address)
                  self.bigImg.hnk_setImageFromURL(address)
                }
            }
            
            }
    }

    // MARK : Emoji keyboard
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojiList!.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        myEmoji = emojiList?.object(at: (indexPath as NSIndexPath).row) as! URL
              UIView.animate(withDuration: 0.3, animations: {
            self.emojiKey?.frame = CGRect(x: 0, y: self.view.frame.height, width: self.emojiKey!.frame.width, height: self.emojiKey!.frame.height)
        })
        setEmoji()
       
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let circleCase = UIView(frame: cell.contentView.frame)
        circleCase.backgroundColor = UIColor.hexStringToUIColor("247BA0")
        circleCase.layer.cornerRadius = cell.frame.width/2
        circleCase.contentMode = UIViewContentMode.scaleAspectFit
        let imageFrame = CGRect(x: cell.contentView.frame.origin.x+10, y: cell.contentView.frame.origin.y+10, width: cell.contentView.frame.width-20, height: cell.contentView.frame.height-20)
        let imageView = UIImageView(frame: imageFrame)
        if (emojiList?.count)! > (indexPath as NSIndexPath).row {
            if let url = emojiList!.object(at: (indexPath as NSIndexPath).row) as? URL {
                imageView.imageFromUrl(url)
            }
        }
        cell.contentView.addSubview(circleCase)
        cell.contentView.addSubview(imageView)
        return cell
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
