//
//  SignInVC.swift
//  Service Provider
//
//  Created by Allen on 24/12/2016.
//  Copyright © 2016 IT Emergency Malaysia. All rights reserved.
//

import UIKit
import Firebase

class SignInVC: UIViewController, UITextFieldDelegate {
    
    var endUserOrPro: Bool? //*(EndUser= True) *(Service Provider = False) --> Recieved from IntroVC
    
    @IBOutlet var emailTxtFld: FancyFields!
    @IBOutlet var passwordTxtFld: FancyFields!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTxtFld.delegate = self
        passwordTxtFld.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide back btn on navigation controller****************
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        //*******************************************************
    }
    
    // Hide Keyboard when user touches any other places when keyboard is UP
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //************************************************
    @IBAction func backBtnTapped(_ sender: Any) {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
}
