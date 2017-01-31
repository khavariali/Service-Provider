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
    @IBOutlet var hireProBtn: UIButton!
    @IBOutlet var hireLbl: UILabel!
    @IBOutlet var serviceProLbl: UILabel!
    
    var activitySpin: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: check this user have service provider account or not
        
        //MARK: ACTIVITY INDICATOR VIEW
        activitySpin.center = self.view.center
        activitySpin.hidesWhenStopped = true
        activitySpin.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        view.addSubview(activitySpin)
        activitySpin.startAnimating()
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        DataService.ds.ServiceProInit(completionHandler: { (success) -> Void in
            
            if success["activationDate"] as? String != "nil",success["active"] as? Bool == true {
                
                self.stopActSpinner()
                
                self.serviceProBtn.setTitle("Service Providers", for: .normal)
                print("***REZA***You have applied for service provider account")
                
            } else if success["activationDate"] as? String != "nil", success["active"] as? Bool == false {
                self.stopActSpinner()
                
                self.serviceProBtn.isEnabled = false
                self.serviceProBtn.addTarget(self, action: #selector(self.serviceProDisabledPressed(button:)), for: .touchUpInside)
                self.serviceProBtn.setTitle("service providers", for: .normal)
                
                self.serviceProLbl.text = "Your account has been disabled"
                print("***REZA***service pro account is disabled")
                
            } else
            {
                self.stopActSpinner()
                
                self.serviceProBtn.addTarget(self, action: #selector(self.pressButton(button:)), for: .touchUpInside)
                self.serviceProBtn.setTitle("Become a service providers", for: .normal)
                
                self.serviceProLbl.text = "if you are providing a professional service click bellow"
                print("***REZA***you do not have service provider account or its disable")
            }
        })
        DataService.ds.HireInit (completionHandler: { (success) ->() in
            if success == false {
                self.hireLbl.text = "Please update your contact info before requesting any service"
            } else {
                self.hireLbl.text = "Many Professional Service Providers love to help you"
            }
        })
    }
    func stopActSpinner() {
        UIApplication.shared.endIgnoringInteractionEvents()
        self.activitySpin.stopAnimating()
    }
    
    func pressButton(button: UIButton) {
        NSLog("pressed!")
    }
    
    func serviceProDisabledPressed(button: UIButton) {
        NSLog("service pro account is disabled")
    }
}
