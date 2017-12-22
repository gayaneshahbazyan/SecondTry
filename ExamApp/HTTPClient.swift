//
//  HTTPClient.swift
//  ExamApp
//
//  Created by Gayane Shahbazyan on 12/15/17.
//  Copyright © 2017 Gayane Shahbazyan. All rights reserved.
//

import UIKit

class HTTPClient {
    static let sharedInstance: HTTPClient = HTTPClient()
    var tasksInProgressArr: [URLSessionDataTask] = [URLSessionDataTask]()
    
    func checkURLValidation(_ urlString: String, completion: @escaping (HTTPURLResponse?, TimeInterval) -> Void) {
        let url = NSURL(string: urlString)! as URL
        let request = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let start: TimeInterval = NSDate.timeIntervalSinceReferenceDate
        let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
            let timeResponse: TimeInterval = NSDate.timeIntervalSinceReferenceDate - start
            if let httpResponse = response as? HTTPURLResponse {
                completion(httpResponse, timeResponse)
            }
            else {
                completion(nil, timeResponse)
            }
        })
        task.resume()
    }
}

