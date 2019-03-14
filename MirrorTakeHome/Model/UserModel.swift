//
//  User.swift
//  MirrorTakeHome
//
//  UserModel is the model for the user, contains all the account settings fields.
//  NOTE: password is stored in plaintext right now which is bad. Should be sha256 both here and the backend.
//
//  Created by Kelly on 3/12/19.
//  Copyright © 2019 Kelly. All rights reserved.
//

import UIKit

class UserModel {
    var email: String
    var password: String
    var name: String?
    var location: String?
    var birthday: String?
    
    init(email: String, password: String, name: String?) {
        self.email = email
        self.password = password
        self.name = name
    }
}

