//
//  GroupRecommend.swift
//  Ethos
//
//  Created by Scott Fitsimones on 10/2/16.
//  Copyright © 2016 Bolt Visual, Inc. All rights reserved.
//

import UIKit

protocol GroupDelegate : class {
    func showGroup(id : Int)
}

class GroupRecommend: UIView {

    @IBOutlet var title: UILabel!
    @IBOutlet var one: UIImageView!
    @IBOutlet var two: UIImageView!
    @IBOutlet var three: UIImageView!
    @IBOutlet var four: UIImageView!
    @IBOutlet var oneText: UILabel!
    @IBOutlet var twoText: UILabel!
    @IBOutlet var threeText: UILabel!
    @IBOutlet var fourText: UILabel!

    var imgs = [UIImageView]()
    var texts = [UILabel]()
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.

    weak var delegate : GroupDelegate?

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        imgs = [one, two, three, four]
        texts = [oneText, twoText, threeText, fourText]
        format()
    }
    
    func format() {
        for (index, image) in imgs.enumerated() {
            image.layer.cornerRadius = one.frame.width/2
            image.layer.borderWidth = 2
            image.layer.borderColor = UIColor.darkGray.cgColor
            image.clipsToBounds = true
            image.isUserInteractionEnabled = true
        }
    }
    
    func tap(rec : UIGestureRecognizer) {
        print("yep")
        let index = rec.view?.tag
        delegate?.showGroup(id: index!)
    }
    
    func setGroup(index : Int, title: String, imgURL : String, id : Int) {
        texts[index].text = title
        if let url = URL(string: imgURL) {
        imgs[index].hnk_setImageFromURL(url)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tap(rec:)))
        tap.numberOfTapsRequired = 1
        imgs[index].tag = id
        imgs[index].addGestureRecognizer(tap)
    }
    

}
