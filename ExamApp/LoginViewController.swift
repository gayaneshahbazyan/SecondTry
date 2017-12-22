//
//  LoginViewController.swift
//  ExamApp
//
//  Created by task on 12/22/17.
//  Copyright © 2017 Gayane Shahbazyan. All rights reserved.
//

import UIKit
import Security

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var newPinTxtField: UITextField!
    @IBOutlet weak var repeatPinTxtField: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var savePinAndEnter: UIButton!
    
    var loginedPins: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()
        newPinTxtField.delegate = self
        repeatPinTxtField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 4 // Bool
    }

    @IBAction func savePin(_ sender: Any) {
        if let pinText = newPinTxtField.text {
            if pinText.count > 0 && pinText.count <= 4 && repeatPinTxtField.text != nil && pinText == repeatPinTxtField.text! {
                loginedPins = UserDefaults.standard.value(forKey: "userPins") as? [String]
                if loginedPins?.contains(pinText) == nil {
                    if loginedPins == nil {
                        loginedPins = [String]()
                        loginedPins!.append(pinText)
                    }
                    else {
                        loginedPins!.append(pinText)
                    }
                    UserDefaults.standard.set(loginedPins, forKey: "userPins")
                    let baseVC = self.storyboard?.instantiateViewController(withIdentifier: "BaseViewController") as? ViewController
                    self.navigationController?.pushViewController(baseVC!, animated: true)
                }
            }
        }
       
    }
}
