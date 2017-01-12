//
//  DataService.swift
//  Service Provider
//
//  Created by Allen on 11/01/2017.
//  Copyright © 2017 IT Emergency Malaysia. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

let DB_BASE = FIRDatabase.database().reference()

class DataService {
    
    static let ds = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    
    var REF_BASE : FIRDatabaseReference {
        return _REF_BASE
    }
    var REF_USERS : FIRDatabaseReference {
        return _REF_USERS
    }
    
    var REF_USER_CURRENT : FIRDatabaseReference {
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let user = REF_USERS.child(uid!)
        return user
    }
    
    // MARK: Create user if new add createdDate to it
    func createFirebaseDBUser (uid: String, userData: Dictionary<String, String>){
        REF_USERS.observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            if snapshot.hasChild(uid) {
                self.REF_USERS.child(uid).updateChildValues(userData)
            } else {
                
                
                let unixTimestamp = 1480134638.0
                let date = NSDate(timeIntervalSince1970: unixTimestamp)
                
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
                dateFormatter.locale = NSLocale.current
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                let strDate = dateFormatter.string(from: date as Date)
                
                if let provider = userData["provider"] {
                
                self.REF_USERS.child(uid).updateChildValues(["createdDate": strDate, "provider": provider])
                }
            }
        })
        
    }
}
