//
//  DataService.swift
//  chatariffic
//
//  Created by William L. Marr III on 5/14/16.
//  Copyright © 2016 William L. Marr III. All rights reserved.
//

import Foundation
import Firebase

// DataService is a globally-accessible singleton.
class DataService {
    static let ds = DataService()
    
    private var _REF_BASE = Firebase(url: "https://chatariffic.firebaseio.com")
    
    var REF_BASE: Firebase {
        return _REF_BASE
    }
}
