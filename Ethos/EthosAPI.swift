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
    fileprivate var full = "http://meetethos.azurewebsites.net/api/"
    
    public func request(url: String, type: HTTPMethod, body : [String : AnyObject]?, reply : @escaping (Any?) -> Void) {
     
        let headers = ["Accept":"application/json","Content-Type":"application/json","X-Ethos-Auth":"\(EthosAPI.ethosAuth)", "X-Facebook-Id":"\(EthosAPI.id)"]
        let path = full+url
        let convert = path as URLConvertible
        if body != nil {
            Alamofire.request(convert, method: type, parameters: body!, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { (response) in
                    print("ENDED")
                    reply(response.result.value)
            }

        } else {
            Alamofire.request(convert, method: type, parameters: nil, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { (response) in
                    print("ENDED")
                    reply(response.result.value)
            }

        }
    }
}
