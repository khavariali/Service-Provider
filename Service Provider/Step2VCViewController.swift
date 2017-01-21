//
//  Step2VCViewController.swift
//  Service Provider
//
//  Created by Allen on 20/01/2017.
//  Copyright © 2017 IT Emergency Malaysia. All rights reserved.
//

import UIKit

class Step2VCViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func goToSignVC() {
        self.navigationController?.pushViewController(signInVC, animated: false)
    }

    @IBAction func getStartedTapped(_ sender: Any) {
        UserDefaults.standard.set("false", forKey: "tutorial")
        goToSignVC()

    }
}
