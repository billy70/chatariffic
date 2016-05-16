//
//  DataService.swift
//  chatariffic
//
//  Created by William L. Marr III on 5/14/16.
//  Copyright © 2016 William L. Marr III. All rights reserved.
//

import Foundation
import Firebase

let BASE_URL = "https://chatariffic.firebaseio.com"

// DataService is a globally-accessible singleton.
class DataService {
    static let ds = DataService()
    
    private var _REF_BASE = Firebase(url: "\(BASE_URL)")
    private var _REF_USERS = Firebase(url: "\(BASE_URL)/users")
    private var _REF_POSTS = Firebase(url: "\(BASE_URL)/posts")
    
    var REF_BASE: Firebase {
        return _REF_BASE
    }
    
    var REF_USERS: Firebase {
        return _REF_USERS
    }
    
    var REF_POSTS: Firebase {
        return _REF_POSTS
    }
    
    func createFirebaseUser(uid: String, user: Dictionary<String, String>) {
        REF_USERS.childByAppendingPath(uid).setValue(user)
    }
}
