//
//  UserURLs.swift
//  ExamApp
//
//  Created by Gayane Shahbazyan on 12/14/17.
//  Copyright © 2017 Gayane Shahbazyan. All rights reserved.
//
import UIKit

class UserURL: NSObject, NSCoding {
    
    // loading = 999
    // active = 200
    // inactive = 404
    var status: Int!
    var urlString: String!
    var tag: Int!
    var requestDuration: TimeInterval!
    
    init(url: String) {
        super.init()
        urlString = url
        status = 999
        verifyURL()
    }
    required init(coder aDecoder: NSCoder) {
        self.urlString = aDecoder.decodeObject(forKey: "urlString") as? String
        self.tag = aDecoder.decodeObject(forKey: "tag") as! Int
        self.status = aDecoder.decodeObject(forKey: "status") as! Int
        self.requestDuration = aDecoder.decodeObject(forKey: "requestDuration") as! TimeInterval
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(urlString, forKey: "urlString")
        aCoder.encode(tag, forKey: "tag")
        aCoder.encode(status, forKey: "status")
        aCoder.encode(requestDuration, forKey: "requestDuration")
    }
    func verifyURL() {
        if urlString == "a" {
            urlString = "http://www.systeen.com/2016/11/29/add-uitextfield-uialertcontroller-swift-3/"
        }
        
        HTTPClient.sharedInstance.checkURLValidation(urlString) { response, duration in
            self.status = 404
            self.requestDuration = duration
            if response != .none && response?.statusCode == 200 {
                self.status = 200
            }
            let urlObj: [String : UserURL] = ["userUrlObj" : self]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "urlStatusChanged"), object: nil, userInfo: urlObj)
        }
    }

}
