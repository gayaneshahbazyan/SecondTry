//
//  ViewController.swift
//  ExamApp
//
//  Created by Gayane Shahbazyan on 12/14/17.
//  Copyright © 2017 Gayane Shahbazyan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate {
    
    @IBOutlet weak var urlTblView: UITableView!
    @IBOutlet weak var addUrlBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!

    var urls: [UserURL]!
    var lastSortFunc: ()->Void = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        urls = getUrlsFromCache()
        // Navigation controller buttons.
        let sortBtn = UIBarButtonItem.init(title: "Sort", style: .plain, target: self, action: #selector(sortURLs))
        self.navigationController?.topViewController?.navigationItem.leftBarButtonItem = sortBtn
        
        let refreshBtn = UIBarButtonItem.init(title: "Refresh", style: .plain, target: self, action: #selector(refreshURLs))
        self.navigationController?.topViewController?.navigationItem.rightBarButtonItem = refreshBtn
        
        urlTblView.delegate = self
        urlTblView.dataSource = self
        urlTblView.register(URLTableViewCell.self, forCellReuseIdentifier: "cell")

        addUrlBtn.setImage(UIImage(named: "add"), for: .normal)
        searchBtn.backgroundColor = UIColor(red: 139.0 / 255, green: 83.0 / 255, blue: 183.0 / 255, alpha: 1)
        
        // notification for url availability status change
        NotificationCenter.default.addObserver(self, selector: #selector(reloadUrlTableView(_:)), name: NSNotification.Name(rawValue: "urlStatusChanged"), object: nil)
    }
    
    
    @IBAction func openSearchVC(_ sender: UIButton) {
        let searchVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController
        searchVC?.availableUrls = urls
        self.navigationController?.pushViewController(searchVC!, animated: true)

    }
    // sorting names from A to Z
    @objc func sortNameAZ() {
        lastSortFunc = sortNameAZ
        urls.sort() {
            one, two in
            one.urlString < two.urlString
        }
        urlTblView.reloadData()
    }
    
    // sorting name from Z to A
    @objc func sortNameZA() {
        lastSortFunc = sortNameZA
        urls.sort() {
            one, two in
            one.urlString > two.urlString
        }
        urlTblView.reloadData()
    }
    
    //sorting availability
    @objc func sortAvailability() {
        lastSortFunc = sortAvailability
        urls.sort() {
            one, two in
            one.status < two.status
        }
        urlTblView.reloadData()
    }
    
    @objc func sortDurationSF() {
        lastSortFunc = sortDurationSF
        urls.sort() {
            one, two in
            if one.requestDuration == nil {
                one.requestDuration = 999
            }
            if two.requestDuration == nil {
                two.requestDuration = 999
            }
            return one.requestDuration > two.requestDuration
        }
        urlTblView.reloadData()
    }
    
    @objc func sortDurationFS() {
        lastSortFunc = sortDurationFS
        urls.sort() {
            one, two in
            if one.requestDuration == nil {
                one.requestDuration = 0
            }
            if two.requestDuration == nil {
                two.requestDuration = 0
            }
            return one.requestDuration < two.requestDuration
        }
        urlTblView.reloadData()
    }
    
    @objc func sortURLs() {
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Choose Option", message: "", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in}
        actionSheetController.addAction(cancelActionButton)
        
        let nameAZ = UIAlertAction(title: "Name A-Z", style: .default)
        { _ in
            self.sortNameAZ()
        }
        actionSheetController.addAction(nameAZ)
        
        let nameZA = UIAlertAction(title: "Name Z-A", style: .default)
        { _ in
            self.sortNameZA()
        }
        actionSheetController.addAction(nameZA)
        
        let availability = UIAlertAction(title: "Availability", style: .default)
        { _ in
            self.sortAvailability()
        }
        actionSheetController.addAction(availability)
        
        let durationSF = UIAlertAction(title: "Duration slow-fast", style: .default)
        { _ in
            self.sortDurationSF()
        }
        actionSheetController.addAction(durationSF)
        
        let durationFS = UIAlertAction(title: "Duration fast-slow", style: .default)
        { _ in
            self.sortDurationFS()
        }
        actionSheetController.addAction(durationFS)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    @IBAction func addNewURL(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Add URL", message: "", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in
            let urlName = alertController.textFields![0] as UITextField
            
            if urlName.text != "" {
                let newURL = UserURL(url: urlName.text!)
                newURL.tag = self.urls.count
                self.urls.append(newURL)
                self.urlTblView.reloadData()
            }
            else {
                let errorAlert = UIAlertController(title: "Error", message: "Please enter URL", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {
                    alert -> Void in
                    self.present(alertController, animated: true, completion: nil)
                }))
                self.present(errorAlert, animated: true, completion: nil)
            }
        }))
        
        alertController.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = " Enter URL"
        })
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func refreshURLs() {
        
        for i in 0 ..< urls.count {
            urls[i].status = 999
        }
        urlTblView.reloadData()
        
        for urlObj in urls {
            HTTPClient.sharedInstance.checkURLValidation(urlObj.urlString) {
                response, duration in
                for i in 0 ..< self.urls.count {
                    if self.urls[i].urlString == urlObj.urlString {
                        self.urls[i].status = 404
                        self.urls[i].requestDuration = duration
                        if response != nil && response?.statusCode == 200 {
                            self.urls[i].status = 200
                        }
                        let urlObjDict: [String : UserURL] = ["userUrlObj" : self.urls[i]]
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "urlStatusChanged"), object: nil, userInfo: urlObjDict)
                        break
                    }
                }
                self.lastSortFunc()
            }
        }
        lastSortFunc() // we need it here too, because table should be sorted before request end.
    }
    
    @objc func reloadUrlTableView(_ notification:Notification) {
        if let urlObj = notification.userInfo?["userUrlObj"] as? UserURL {
            urls[urlObj.tag].status = urlObj.status
            DispatchQueue.main.async {
                self.urlTblView.reloadData()
                self.saveUrlInCache(self.urls)
            }
        }
    }
    
    func getUrlsFromCache() -> [UserURL] {
        if let decoded  = UserDefaults.standard.object(forKey: "userUrls") as? Data {
            let decodedUrls = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [UserURL]
            return decodedUrls
        }
        return [UserURL]()
    }
    func saveUrlInCache(_ userUrls: [UserURL]) {
        var userLoadedURLs: [UserURL] = [UserURL]()
        for urlObj in urls {
            if urlObj.status != 999 {
                userLoadedURLs.append(urlObj)
            }
        }
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: userLoadedURLs)
        UserDefaults.standard.setValue(encodedData, forKey: "userUrls")
    }
    
    // Table View Delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! URLTableViewCell
        
        if !cell.isConstrated {
            cell.constrateCell()
        }
        cell.urlLabel.text = urls[indexPath.row].urlString
        
        cell.tag = indexPath.row
        urls[indexPath.row].tag = indexPath.row
        cell.urlStatusImgView.isHidden = false
        switch urls[indexPath.row].status {
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urls.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            if urls[indexPath.row].status == 999 {
                let alertController = UIAlertController(title: "Unable to delete", message: "URL is still loading", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            urls.remove(at: indexPath.row)
            urlTblView.reloadData()
            saveUrlInCache(urls)
        }
    }
    
}

