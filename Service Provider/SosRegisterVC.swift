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

class SosRegisterVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func signOutTapped(_ sender: Any) {
        let signOutResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("***REZA*** user data removed from keychain \(signOutResult)")
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
}
