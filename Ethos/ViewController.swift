//
//  ViewController.swift
//  Ethos
//
//  Created by Scott Fitsimones on 8/30/16.
//  Copyright © 2016 Bolt Visual, Inc. All rights reserved.
//

import UIKit
import CFNetwork
struct Colors {
    static let primary = UIColor.hexStringToUIColor("247BA0")
}


extension UIView {
    class func loadFromNibNamed(nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
}


extension Date {
    
    func getElapsedInterval() -> String {
        
        var interval = (Calendar.current as NSCalendar).components(.year, from: self, to: Date(), options: []).year
        
        if interval! > 0 {
            return interval == 1 ? "\(interval!)" + " " + "yr" :
                "\(interval!)" + " " + "yrs"
        }
        
        interval = (Calendar.current as NSCalendar).components(.month, from: self, to: Date(), options: []).month
        if interval! > 0 {
            return interval == 1 ? "\(interval!)" + " " + "m" :
                "\(interval!)" + " " + "m"
        }
        
        interval = (Calendar.current as NSCalendar).components(.day, from: self, to: Date(), options: []).day
        if interval! > 0 {
            return interval == 1 ? "\(interval!)" + " " + "d" :
                "\(interval!)" + " " + "d"
        }
        
        interval = (Calendar.current as NSCalendar).components(.hour, from: self, to: Date(), options: []).hour
        if interval! > 0 {
            return interval == 1 ? "\(interval!)" + " " + "hr" :
                "\(interval!)" + " " + "hrs"
        }
        
        interval = (Calendar.current as NSCalendar).components(.minute, from: self, to: Date(), options: []).minute
        if interval! > 0 {
            return interval == 1 ? "\(interval!)" + " " + "min" :
                "\(interval!)" + " " + "min"
        }
        
        return "just now"
    }
}
extension UIImageView {
    public func imageFromUrl(_ url: URL) {
            let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error == nil {
                    DispatchQueue.main.async(execute: { 
                        self.image = UIImage(data: data!)
                    })
                }
            }).resume()
        }
}

extension UIColor {
    class func hexStringToUIColor (_ hex:String) -> UIColor {
        var cString = hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        if (cString.hasPrefix("#")) {
            cString = cString.substring(from: cString.characters.index(cString.startIndex, offsetBy: 1))
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

class ViewController: UIViewController {


    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.barTintColor = UIColor.blue
        self.navigationController?.navigationBar.tintColor = UIColor.blue

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

