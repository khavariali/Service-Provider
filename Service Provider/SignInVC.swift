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
import GoogleSignIn
import SwiftKeychainWrapper

class SignInVC: UIViewController, UITextFieldDelegate, GIDSignInUIDelegate, GIDSignInDelegate {
    
    //****scrolview test
    var tutImages = [UIImageView]()
    
    @IBOutlet var tutScrollView: UIScrollView!
    
    //******************
    
    var endUserOrPro: Bool? //*(EndUser= True) *(Service Provider = False) --> Recieved from IntroVC
    
    @IBOutlet var emailTxtFld: FancyFields!
    @IBOutlet var passwordTxtFld: FancyFields!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //****scrolview test
        var contentWidth: CGFloat = 0.0
        for x in 0...1 {
            let image = UIImage(named: "\(x).png")
            let imageView = UIImageView(image: image)
            tutImages.append(imageView)
            
            var newX : CGFloat = 0.0
            
            newX = view.frame.minX + view.frame.size.width * CGFloat(x)
            contentWidth += newX
            tutScrollView.addSubview(imageView)
            imageView.frame = CGRect(x: newX, y: 0, width: view.frame.size.width, height: view.frame.size.height)
//            
//            let tutStartBtn = UIButton()
//            tutStartBtn.setTitle("Get Start", for: .normal)
//            tutScrollView.subviews(tutStartBtn)
            
            print("***reza***\(x).png")
        }
        tutScrollView.contentSize = CGSize(width: contentWidth * 2, height: view.frame.size.height)
        //******************
        
        emailTxtFld.delegate = self
        passwordTxtFld.delegate = self
        
        //****************
        //Google delegate*
        //****************
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        //*************************************
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //***************************************
        // MARK: Hide back btn on navigation controller*
        //***************************************
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        //*******************************************************
    }
    //********************************
    //Hide Keyboard when user touches*
    //any other places when keyboard *
    //is UP                          *
    //********************************
    
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
    
    
    //***********************************
    //Implementing facebook login action*
    //***********************************
    
    @IBAction func facebookBtnTapped(_ sender: Any) {
        facebookConnect()
    }
    
    func facebookConnect() {
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("***REZA*** Unable to authenticate with facebook\(error.debugDescription)")
            }else if result?.isCancelled == true {
                print("***REZA*** User cancled facebook authentication\(error.debugDescription)") // Might user didn't want to give its email address to this app.!!!!
            } else {
                print("***REZA*** Successfully authenticated with facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString) //Here we are passing facebook credential to firebase *Its very important to use .tokenString end of the statement
                
                self.firebaseAuth(credential) //calling our method which we write to login if their facebook auth was successfully *remember to put self in it because we are calling from inside a function.
            }
        }
    }
    
    //***************************************************************
    

    // MARK: Google signin tapped

    
    @IBAction func googleBtnTapped(_ sender: Any) {
        googleConnect()
    }
    
    func googleConnect() {
        GIDSignIn.sharedInstance().signIn()
    }
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("***REZA*** User Unable SignIned with google account\(error.localizedDescription)")
            return
        } else {
            print("***REZA*** User SignIned with google account")
        }
        
        guard let authentication = user.authentication else { return }
        let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        firebaseAuth(credential)
    }
    

    // MARK: Firebase auth (Signin) send here after
    //facebook or google successfuly authenticated
    
    func firebaseAuth(_ credential : FIRAuthCredential) {
        // TODO: Check new user or exist, set created date to it 
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("***REZA*** Unable to authenticate with firebase\(error.debugDescription)")
            } else {
                print("***REZA*** Successfully Authenticated with firebase")
                
                
                // MARK: Adding user to SwiftKeyChainWrapper*
                
                if let user = user {
                    let userData = ["provider": credential.provider]
                    
                    self.completeSignIn(id: user.uid, userData: userData, new: false)
                }
                
            }
        })
    }
    
    // MARK: User Login/Register Manager
    @IBAction func signInTapped(_ sender: Any) {
        var userProvider: String = ""
        if let email = emailTxtFld.text, let pwd = passwordTxtFld.text { // MARK: check fields are not empty
            
            
            _ = FIRAuth.auth()?.fetchProviders(forEmail: email, completion: { (result, error) in
                if error != nil {
                    print("***REZA****\(error.debugDescription)***")
                } else {
                    if let result = result {
                        
                        if result[0].contains("facebook.com") {
                            
                            // MARK: Already registered with facebook
                            userProvider = "Facebook"
                            
                            self.sendAlert(title: "Warning!", message: "Account already exist, Please login with your \(userProvider) Account", btnTxt: "ok", provider: userProvider)
                            
                        } else if result[0].contains("google.com") {
                            
                            // MARK: already registered with google
                            userProvider = "Google"
                            
                            self.sendAlert(title: "Warning!", message: "Account already exist, Please login with your \(userProvider) Account", btnTxt: "OK", provider: userProvider)
                            
                        } else {
                            // MARK: already registered with email/pass
                            userProvider = "Firebase/Email"
                            
                            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                                if error == nil {
                                    print("***REZA*** Email User already exist and authenticated with firebase")
                                    if let user = user {
                                        let userData = ["provider": user.providerID]
                                        self.completeSignIn(id: user.uid, userData: userData, new: false)
                                    }
                                } else {
                                    if let errSignin = FIRAuthErrorCode(rawValue: (error?._code)!)
                                    {
                                        switch errSignin {
                                        case .errorCodeWrongPassword :
                                            // MARK: ALERT WrongPassword
                                            self.sendAlert(title: "Warning!", message: "Wrong Password", btnTxt: "Try again", provider: "Forget")
                                            
                                        case .errorCodeUserDisabled :
                                            // MARK: UserDisabled
                                            self.sendAlert(title: "Warning!", message: "Your account has been disabled please contact support!", btnTxt: "ok", provider: "Support")
                                            
                                        default: print("def.......\(errSignin)")
                                        }
                                    }
                                    
                                    
                                }
                            })
                        }
                    } else {
                        // TODO: Not exist and have to register and check do error handlers
                        FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                            if error != nil {
                                
                                // MARK: CreateUser Error Handler
                                if let errCode = FIRAuthErrorCode(rawValue: (error?._code)!)
                                {
                                    switch errCode {
                                    case .errorCodeEmailAlreadyInUse :
                                        _ = FIRAuth.auth()?.fetchProviders(forEmail: email, completion: { (result, error) in
                                            if let result = result {
                                                
                                                // MARK: ALERT EmailAlreadyInUse
                                                let alertController = UIAlertController(title: "Warning", message: "This email already registered with your \(result) account, Please login with \(result))", preferredStyle: UIAlertControllerStyle.alert)
                                                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                                    (result : UIAlertAction) -> Void in
                                                    print("OK")
                                                }
                                                alertController.addAction(okAction)
                                                self.present(alertController, animated: true, completion: nil)
                                                
                                            }
                                        })
                                    case .errorCodeInvalidEmail :
                                        // MARK: ALERT InvalidEmail
                                        let alertController = UIAlertController(title: "Warning", message: "Invalid Email Address", preferredStyle: UIAlertControllerStyle.alert)
                                        let okAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default) {
                                            (result : UIAlertAction) -> Void in
                                            print("OK")
                                        }
                                        alertController.addAction(okAction)
                                        self.present(alertController, animated: true, completion: nil)
                                        
                                    case .errorCodeWeakPassword :
                                        // MARK: ALERT WeakPassword
                                        let alertController = UIAlertController(title: "Warning", message: "Weak Password ! Password should be at least 6 characters", preferredStyle: UIAlertControllerStyle.alert)
                                        let okAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default) {
                                            (result : UIAlertAction) -> Void in
                                            print("OK")
                                        }
                                        alertController.addAction(okAction)
                                        self.present(alertController, animated: true, completion: nil)
                                        
                                    default: print("def.......\(errCode)")
                                    }
                                }
                                
                                print("***REZA** Unable to authenticate with firebase user email \(error.debugDescription)")
                                
                            } else {
                                print("***REZA*** Successfully authenticated with firebase user email")
                                if let user = user {
                                    let userData = ["provider": user.providerID]
                                    self.completeSignIn(id: user.uid, userData: userData, new: true)
                                }
                            }
                        })
                        
                    }
                }
            })
            
            
            //*****************
            
        }
    }
    
    // MARK: Next Btn on Keyboard
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        if textField == emailTxtFld { // MARK: Switch focus to other text field
            passwordTxtFld.becomeFirstResponder()
        }
    }
    //*****************************
    
    // MARK: Go to sosRegisterVC
    func gotoSosVC() {
        self.navigationController?.pushViewController(sosRegisterVC, animated: true)
    }
    //******************
    
    // MARK: UserData -> KeyChain
    func completeSignIn(id: String, userData: Dictionary<String, String>, new: Bool) {
        
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        
        let keyChainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("***REZA** data save to keychain\(keyChainResult)")
        gotoSosVC()
    }
    //*********************
    
    //MARK: Send acurate Alert(message) in signin view
    func sendAlert(title: String, message: String, btnTxt: String, provider: String?) {
        if provider == nil {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
            let btnAction = UIAlertAction(title: btnTxt, style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
                print("\(btnTxt)ed")
            }
            alertController.addAction(btnAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            
            //TODO alert for two btns e.g. ok and facebook, try again and forget password
            
            switch provider! {
            case "Facebook" :
                let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
                let firstActionBtn = UIAlertAction(title: btnTxt, style: UIAlertActionStyle.default) {
                    (result : UIAlertAction) -> Void in
                    print("firstActionBtn")
                }
                let secActionBtn = UIAlertAction(title: provider, style: UIAlertActionStyle.destructive) {
                    (result : UIAlertAction) -> Void in
                    self.facebookConnect()
                }
                alertController.addAction(secActionBtn)
                alertController.addAction(firstActionBtn)
                self.present(alertController, animated: true, completion: nil)
                
            case "Google" :
                let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
                let firstActionBtn = UIAlertAction(title: btnTxt, style: UIAlertActionStyle.default) {
                    (result : UIAlertAction) -> Void in
                    print("firstActionBtn")
                }
                let secActionBtn = UIAlertAction(title: provider, style: UIAlertActionStyle.destructive) {
                    (result : UIAlertAction) -> Void in
                    self.googleConnect()
                }
                alertController.addAction(secActionBtn)
                alertController.addAction(firstActionBtn)
                self.present(alertController, animated: true, completion: nil)
            //TODO: I have to impelement this for wrong password
            case "Forget" :
                let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
                let firstActionBtn = UIAlertAction(title: btnTxt, style: UIAlertActionStyle.default) {
                    (result : UIAlertAction) -> Void in
                    print("firstActionBtn")
                }
                let secActionBtn = UIAlertAction(title: provider, style: UIAlertActionStyle.destructive) {
                    (result : UIAlertAction) -> Void in
                    print("SecactionBtn")
                }
                alertController.addAction(secActionBtn)
                alertController.addAction(firstActionBtn)
                self.present(alertController, animated: true, completion: nil)
            case "Support" :
                let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
                let firstActionBtn = UIAlertAction(title: btnTxt, style: UIAlertActionStyle.default) {
                    (result : UIAlertAction) -> Void in
                    print("firstActionBtn")
                }
                let secActionBtn = UIAlertAction(title: provider, style: UIAlertActionStyle.destructive) {
                    (result : UIAlertAction) -> Void in
                    print("SecactionBtn")
                }
                alertController.addAction(secActionBtn)
                alertController.addAction(firstActionBtn)
                self.present(alertController, animated: true, completion: nil)
                
            default : print("Default")
                
            }
        }
    }
}
