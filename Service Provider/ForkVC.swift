//
//  ForkVC.swift
//  Service Provider
//
//  Created by Allen on 16/01/2017.
//  Copyright © 2017 IT Emergency Malaysia. All rights reserved.
//

import UIKit

class ForkVC: UIViewController {

    @IBOutlet var serviceProBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        //MARK: Check whether heis pro or not
        serviceProBtn.setTitle("test", for: .normal)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
