//
//  SignInVC.swift
//  Service Provider
//
//  Created by Allen on 24/12/2016.
//  Copyright © 2016 IT Emergency Malaysia. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import FBSDKCoreKit

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
    
    
    //Implementing facebook login action*****************************
    
    @IBAction func facebookBtnTapped(_ sender: Any) {
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("***REZA*** Unable to authenticate with facebook\(error.debugDescription)")
            }else if result?.isCancelled == true {
                print("***REZA*** User cancled facebook authentication") // Might user didn't want to give its email address to this app.!!!!
            } else {
                print("***REZA*** Successfully authenticated with facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString) // Here we are passing facebook credential to firebase *Its very important to use .tokenString end of the statement
                self.firebaseAuth(credential) //calling our method which we write to login if their facebook auth was successfully *remember to put self in it because we are calling from inside a function.
            }
        }
    }
    
    //***************************************************************
    
    func firebaseAuth(_ credential : FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("***REZA*** Unable to authenticate with firebase\(error.debugDescription)")
            } else {
                print("***REZA*** Successfully Authenticated with firebase")
            }
        })
    }
    // Here we are checking whether user exist or not and then if its exist LOGIN else create user and log it in.
    @IBAction func signInTapped(_ sender: Any) {
        if let email = emailTxtFld.text, let pwd = passwordTxtFld.text { //check fields are not empty
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("***REZA*** Email User already exist and authenticated with firebase")
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("***REZA** Unable toauthenticate with firebase user email \(error.debugDescription)")
                            
                        } else {
                            print("***REZA*** Successfully authenticated with firebase user email")
                        }
                    })
                }
            })
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
