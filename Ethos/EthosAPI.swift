//
//  EthosAPI.swift
//  Ethos
//
//  Created by Scott Fitsimones on 9/25/16.
//  Copyright © 2016 Bolt Visual, Inc. All rights reserved.
//

import UIKit
import Alamofire

class EthosAPI: NSObject {
    
    var headers : [String : Any]?
    static let shared = EthosAPI()
    static var ethosAuth = ""
    static var id = ""
    
    func registerAPI(ethosKey : String, id : String) {
          headers = ["Accept":"application/json","Content-Type":"application/json","X-Ethos-Auth":"\(EthosAPI.ethosAuth)", "X-Facebook-Id":"\(EthosAPI.id)"]

    
    }
    
//     func request(url: URLConvertible, type: HTTPMethod, body : [String : AnyObject]) {
//        
//        Alamofire.request("http://meetethos.azurewebsites.net/api/Group", method: .get, parameters: ["":""], encoding: JSONEncoding.default, headers: headers!)
//            .responseJSON { (response) in
//                
//        }
//       
//        }

}
