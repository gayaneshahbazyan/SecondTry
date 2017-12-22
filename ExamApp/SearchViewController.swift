//
//  SearchViewController.swift
//  ExamApp
//
//  Created by Gayane Shahbazyan on 12/15/17.
//  Copyright © 2017 Gayane Shahbazyan. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var searchTxtField: UITextField!
    @IBOutlet weak var searchTblView: UITableView!
    var searchTxt = ""
    var availableUrls: [UserURL]!
    var searchResult: [UserURL] = [UserURL]() {
        didSet {
            self.searchTblView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        searchTxtField.delegate = self
        
        searchTblView.delegate = self
        searchTblView.dataSource = self
        searchTblView.register(URLTableViewCell.self, forCellReuseIdentifier: "Cell1")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchResult = availableUrls.filter({(str:UserURL) -> Bool in
            let stringMatch = str.urlString.containsIgnoringCase(find: textField.text!)
            return stringMatch
        })
        textField.resignFirstResponder()
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! URLTableViewCell
        
        if !cell.isConstrated {
            cell.constrateCell()
        }
        cell.urlLabel.text = searchResult[indexPath.row].urlString
        cell.urlStatusImgView.isHidden = false
        cell.urlStatusImgView.frame = CGRect(x: self.view.frame.width - 50, y: 0, width: 40, height: 40)

        switch searchResult[indexPath.row].status {
        case 404:
            cell.urlStatusImgView.image = UIImage(named:"notSuccess")
            cell.activityIndicator.stopAnimating()
        case 200:
            cell.urlStatusImgView.image = UIImage(named:"success")
            cell.activityIndicator.stopAnimating()
        default:
            cell.urlStatusImgView.isHidden = true
            cell.activityIndicator.startAnimating()
        }
        return cell
    }
}

extension String {
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}
