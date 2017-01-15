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
    //MARK: CALLING menu
    
    lazy var settingsLauncher: SettingsLauncher = {
        let launcher = SettingsLauncher()
        launcher.sosRegVC = self
        return launcher
    }()
    
    func handleMore() {
        settingsLauncher.showSettings()
    }
    //MARK: GOTO VIEW CONTROLLER
    func showControllerForSetting(setting: Setting) {
        // MARK: HOW TO CREAT VIEWCONTROLLER
        let dummySettingViewController = UIViewController()
        dummySettingViewController.navigationItem.title = setting.name
        dummySettingViewController.view.backgroundColor = UIColor.white
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blue]
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.pushViewController(dummySettingViewController, animated: true)
        
    }
    
    @IBAction func profileMenu(_ sender: Any) {
        handleMore()
    }
}
