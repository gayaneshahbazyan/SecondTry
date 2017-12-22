//
//  URLTableViewCell.swift
//  ExamApp
//
//  Created by Gayane Shahbazyan on 12/14/17.
//  Copyright © 2017 Gayane Shahbazyan. All rights reserved.
//
import UIKit

class URLTableViewCell: UITableViewCell {
    
    var isConstrated: Bool = false
    var urlLabel: UILabel!
    var urlStatusImgView: UIImageView!
    var activityIndicator: UIActivityIndicatorView!
    
    func constrateCell() {
        isConstrated = true
        
        self.selectionStyle = .none
        
        urlLabel = UILabel(frame: CGRect(x: 10, y: 0, width: self.frame.width * 0.8, height: self.frame.height * 0.8))
        urlLabel.center.y = self.frame.height / 2.0
        self.addSubview(urlLabel)
        
        urlStatusImgView = UIImageView(frame: CGRect(x: self.frame.width - 50, y: 0, width: 40, height: 40))
        urlStatusImgView.center.y = self.frame.height / 2.0
        self.addSubview(urlStatusImgView)
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.center = urlStatusImgView.center
        self.addSubview(activityIndicator)
    }
    
}
