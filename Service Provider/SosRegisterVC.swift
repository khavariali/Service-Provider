//
//  SosRegisterVC.swift
//  Service Provider
//
//  Created by Allen on 01/01/2017.
//  Copyright © 2017 IT Emergency Malaysia. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Google
import GoogleSignIn
import Firebase

class SosRegisterVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("this is provider is: \(FIRAuth.auth()?.currentUser?.providerID)")

        //***************************************
        //Hide back btn on navigation controller*
        //***************************************
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        //*******************************************************
    }

    @IBAction func signOutTapped(_ sender: Any) {
        let signOutResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("***REZA*** user data removed from keychain \(signOutResult)")
        try! FIRAuth.auth()?.signOut()
        _ = navigationController?.popViewController(animated: true) // To navigate back to the previuse view controller we have to use this.
//        _ = self.navigationController?.pushViewController(signInVC, animated: true)
    }
}
