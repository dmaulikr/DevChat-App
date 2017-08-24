//
//  User.swift
//  DevChat
//
//  Created by Mark Price on 7/15/16.
//  Copyright © 2016 Devslopes. All rights reserved.
//

import UIKit

struct User {
    private var _firstName: String
    private var _uid: String
    
    var uid: String {
        return _uid
    }
    
    var firstName: String {
        return _firstName
    }
    
    init(uid: String, firstName: String) {
        _uid = uid
        _firstName = firstName
    }
    
    
}
