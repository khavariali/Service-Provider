//
//  ViewController.swift
//  Service Provider
//
//  Created by Allen on 24/12/2016.
//  Copyright © 2016 IT Emergency Malaysia. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class IntroVC: UIViewController {
    
    //MARK: WelcomeScrollView
    var tutImages = [UIImageView]()
    @IBOutlet var tutScrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tut = UserDefaults.standard.object(forKey: "tutorial") {
            print("Show welcome tutorial ? \(tut)")
            if String(describing: tut) == "false" {
                goToSignVC()
            }
        }else {
            showTutorial()
        }
    }
    
    //******Sending a Bool which will define user type enduser/provider*************
    
    //    @IBAction func sosTapped(_ sender: Any) {
    //        signInVC.endUserOrPro = true
    //        goToSignVC()
    //    }
    //    @IBAction func serviceProTapped(_ sender: Any) {
    //        signInVC.endUserOrPro = false
    //        goToSignVC()
    //    }
    func goToSignVC() {
        self.navigationController?.pushViewController(signInVC, animated: false)
    }
    
    @IBAction func tutStartBtnTapped(_ sender: Any) {
        UserDefaults.standard.set("false", forKey: "tutorial")
        goToSignVC()
    }
    
    func showTutorial() {
        //MARK: WELCOME SCROLLVIEW
        var contentWidth: CGFloat = 0.0
        for x in 0...1 {
            let image = UIImage(named: "\(x).png")
            let imageView = UIImageView(image: image)
            tutImages.append(imageView)
            
            var newX : CGFloat = 0.0
            
            newX = view.frame.minX + view.frame.size.width * CGFloat(x)
            contentWidth += newX
            tutScrollView.addSubview(imageView)
            imageView.frame = CGRect(x: newX, y: 0, width: view.frame.size.width, height: tutScrollView.frame.size.height)
            
            print("***reza***\(x).png")
        }
        tutScrollView.contentSize = CGSize(width: contentWidth * 2, height: view.frame.size.height - 70)
    }
    
}

