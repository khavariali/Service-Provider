//
//  Constants.swift
//  Service Provider
//
//  Created by Allen on 24/12/2016.
//  Copyright © 2016 IT Emergency Malaysia. All rights reserved.
//

import UIKit

let SHADOW_GRAY: CGFloat = 120.0 / 255.0


let storyBoard = UIStoryboard(name: "Main", bundle: nil)
let signInVC = storyBoard.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
let sosRegisterVC = storyBoard.instantiateViewController(withIdentifier: "SosRegisterVC") as! SosRegisterVC
let forkVC = storyBoard.instantiateViewController(withIdentifier: "ForkVC") as! ForkVC
let userProfileVC = storyBoard.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileVC


let KEY_UID = "uid"
