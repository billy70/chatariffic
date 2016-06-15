//
//  DataService.swift
//  chatariffic
//
//  Created by William L. Marr III on 5/14/16.
//  Copyright © 2016 William L. Marr III. All rights reserved.
//

import Foundation
import Firebase

let BASE_URL = FIRDatabase.database().reference()

// DataService is a globally-accessible singleton.
class DataService {
    static let ds = DataService()
    
    private var _REF_BASE = BASE_URL
    private var _REF_USERS = BASE_URL.child("users")
    private var _REF_POSTS = BASE_URL.child("posts")
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USER_CURRENT: FIRDatabaseReference {
        let uid = NSUserDefaults.standardUserDefaults().valueForKey(FIREBASE_KEY_UID) as! String
        let user = _REF_USERS.child(uid)
        return user
    }
    
    func createFirebaseUser(uid: String, user: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(user)
    }
}
