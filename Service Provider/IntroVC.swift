//
//  ViewController.swift
//  Service Provider
//
//  Created by Allen on 24/12/2016.
//  Copyright © 2016 IT Emergency Malaysia. All rights reserved.
//

import UIKit

class IntroVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //******Sending a Bool which will define user type enduser/provider*************

    @IBAction func sosTapped(_ sender: Any) {
        signInVC.endUserOrPro = true
        goToSignVC()
    }
    @IBAction func serviceProTapped(_ sender: Any) {
        signInVC.endUserOrPro = false
        goToSignVC()
    }
    func goToSignVC() {
        self.navigationController?.pushViewController(signInVC, animated: true)
    }
    
    //*********************************END*******************************************
}

