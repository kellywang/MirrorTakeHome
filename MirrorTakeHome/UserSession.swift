//
//  UserSession.swift
//  MirrorTakeHome
//
//  UserSession is a singleton to keep track of jwtToken and the user that is currently logged in.
//  Singletons are scary and ill advised, but it was the easiest way for a small app like this to
//  keep track of the jwtToken and user.
//
//  Created by Kelly on 3/12/19.
//  Copyright © 2019 Kelly. All rights reserved.
//

import UIKit

class UserSession {
    var jwtToken: String
    var user: UserViewModel?
    // Do we need expiration?
    static let sharedInstance : UserSession = UserSession(jwtToken: "")
    
    init(jwtToken: String) {
        self.jwtToken = jwtToken
    }
    
    func invalidate() {
        self.jwtToken = ""
        self.user = nil
    }
    
    class func stub() -> UserSession {
        return UserSession(jwtToken: "stub-token")
    }
}
