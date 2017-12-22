//
//  PinCodeViewController.swift
//  ExamApp
//
//  Created by task on 12/22/17.
//  Copyright © 2017 Gayane Shahbazyan. All rights reserved.
//

import UIKit

class PinCodeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var pinTxtField: UITextField!
    @IBOutlet weak var checkPinAndEnterBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pinTxtField.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 4 // Bool
    }

    @IBAction func checkPinValidationAndEnter(_ sender: UIButton) {
       
        let logedPins = UserDefaults.standard.value(forKey: "userPins") as? [String]
        if let pinText = pinTxtField.text {
            if pinText.count > 0 && pinText.count <= 4 && logedPins != nil && logedPins!.contains(pinText) {
                let baseVC = self.storyboard?.instantiateViewController(withIdentifier: "BaseViewController") as? ViewController
                self.navigationController?.pushViewController(baseVC!, animated: true)
            }
        }
    }
    
    @IBAction func goToLoginVC(_ sender: UIButton) {
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        self.navigationController?.pushViewController(loginVC!, animated: true)
    }
}
