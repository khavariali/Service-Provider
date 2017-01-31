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
    private var _REF_SERVICEPROVIDERS = DB_BASE.child("serviceProviders")
    
    var REF_BASE : FIRDatabaseReference {
        return _REF_BASE
    }
    var REF_USERS : FIRDatabaseReference {
        return _REF_USERS
    }
    var REF_SERVICEPROVIDERS : FIRDatabaseReference {
        return _REF_SERVICEPROVIDERS
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
                // MARK: Generating Unix TimeStamp
                let strDate = NSDate().timeIntervalSince1970
                
                var emailAdd: String = "nil"
                if let email = FIRAuth.auth()?.currentUser?.email {
                    emailAdd = email
                }
                //MARK: MODIFIED DATE ARRAY FOR FUTURE
                //let modifiedDate = ["date0": "nil"]
                self.REF_SERVICEPROVIDERS.child(uid).updateChildValues(["createdDate": "nil", "modifiedDate": "nil", "active": false, "activationDate": "nil", "photo":"nil" ])
                
                // MARK: TimeStamp to customized time format
                //let unixTimestamp = 1484277549.329164
                //let date = NSDate(timeIntervalSince1970: unixTimestamp)
                
                //let dateFormatter = DateFormatter()
                //dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
                //dateFormatter.locale = NSLocale.current
                //dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                //let strDate = dateFormatter.string(from: date as Date)
                
                
                
                if let provider = userData["provider"] {
                
                self.REF_USERS.child(uid).updateChildValues(["firstName": "nil","lastName": "nil", "createdDate": strDate, "modifiedDate":"nil", "mobileNo": "nil", "emailAddress": emailAdd,"photo":"nil", "provider": provider, "active":false])
                }
            }
        })
    }
    
    //MARK: CHECK STORED KEYCHAIN UID WITH DB BEFORE LOGIN
    typealias CompletionHandler = (_ success:Bool) -> Void
    
    func keyChainExamDbUser(uid: String,completionHandler: @escaping CompletionHandler) {
        var flag = false
        REF_USERS.observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            if snapshot.hasChild(uid) {
                print("EXIST")
                
                flag = true
            }
            completionHandler(flag)
        })
    }
    
    //MARK: CHECK user has service provider account or not in the beginning of forkVC
    typealias ProInit = (_ success: NSDictionary) -> Void

    func ServiceProInit(completionHandler: @escaping ProInit) {
        //var flag = false
        var resultDic: NSDictionary = [:]
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            REF_SERVICEPROVIDERS.child(uid).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
                if let snapshotv = snapshot.value as? NSDictionary {
                    if let actDate = snapshotv.value(forKey: "activationDate"), let ProStatus = snapshotv.value(forKey: "active") {
                        
                        resultDic = ["activationDate":actDate, "active":ProStatus]
                    }
                }
                completionHandler(resultDic)
            })
        }
    }
    func HireInit(completionHandler:@escaping (Bool) -> ()) {
        var resultDic = false
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            REF_USERS.child(uid).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
                if let snapshotv = snapshot.value as? NSDictionary {
                    if let status = snapshotv.value(forKey: "active") {
                        if (status as? Bool)! {
                            resultDic = status as! Bool
                        }
                    }
                }
                completionHandler(resultDic)
            })
        }
    }
}
