//
//  FancyFields.swift
//  Service Provider
//
//  Created by Allen on 27/12/2016.
//  Copyright © 2016 IT Emergency Malaysia. All rights reserved.
//

import UIKit

class FancyFields: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        layer.borderColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.2).cgColor
//        layer.borderWidth = 1.0
//        let placeHolderX : CGFloat = 1.0
//        let placeHolderY : CGFloat = frame.size.height / 2
//        let placeHolderWidth : CGFloat = 19
//        let placeHolderHeight : CGFloat = 22
//        let lock : UIImageView
//        lock = UIImage(named: "mail")
        
        let border = CALayer()
        let width = CGFloat(0.5)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: frame.size.height - width, width:  frame.size.width, height: frame.size.height)
        
        border.borderWidth = width
        layer.addSublayer(border)
        layer.masksToBounds = true
        
        
        
//        layer.cornerRadius = 2.0
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 20.0, dy: 5.0)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 20, dy: 5)
    }
}
