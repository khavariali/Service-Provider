//
//  UserProfile.swift
//  Service Provider
//
//  Created by Allen on 26/01/2017.
//  Copyright © 2017 IT Emergency Malaysia. All rights reserved.
//

import Foundation
import Firebase

class UserProfile {
    //private var _createdDate: String
    //private var _emailAddress: String
    private var _firstName: String
    private var _lastName: String
    private var _mobileNo: String
    private var _modifiedDate: String
   // private var _provider: String
    //private var _userID: String
    //private var _userProfileRef: FIRDatabaseReference
    
    //var createdDate: String {
     //   return _createdDate
    //}
    //var emailAddress: String {
     //   return _emailAddress
    //}
    var firstName: String {
        return _firstName
    }
    var lastName: String {
        return _lastName
    }
    var mobileNo: String {
        return _mobileNo
    }
    var modifiedDate: String {
        return _modifiedDate
    }
    //var provider: String {
      //  return _provider
    //}
    //var userID: String {
      //  return _userID
    //}
    
    init(firstName: String, lastName: String, mobileNo: String, modifiedDate: String) {
        self._firstName = firstName
        self._lastName = lastName
        self._mobileNo = mobileNo
        self._modifiedDate = modifiedDate
    }
    
}
