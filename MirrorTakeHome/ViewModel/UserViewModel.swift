//
//  UserViewModel.swift
//  MirrorTakeHome
//
//  UserViewModel is the view model for the UserModel. Provides account settings fields
//  in a readable manner. Also makes calls to create a new user, fetch account info after login,
//  or update account info.
//
//  Created by Kelly on 3/12/19.
//  Copyright © 2019 Kelly. All rights reserved.
//

import UIKit

class UserViewModel {
    typealias Completion = (_ success:Bool, _ error:String?) -> Void
    
    var updateUserViews: (() -> Void)?
    var updateLoadingStatus: (() -> Void)?
    
    init(email: String, password: String, name: String?) {
        let userModel = UserModel(email: email, password: password, name: name)
        self.userModel = userModel
    }
    
    init(userModel: UserModel) {
        self.userModel = userModel
    }
    
    // Update views if UserModel was reset
    private var userModel: UserModel {
        didSet {
            self.updateUserViews?()
        }
    }
    
    var name: String {
        return self.userModel.name ?? ""
    }
    
    var location: String {
        return self.userModel.location ?? ""
    }
    
    public var birthday: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from:self.userModel.birthday ?? "") ?? Date()
        return date
    }
    
    class func createNewUser(info: SignupInfo, completion: @escaping Completion) {
        let completion: RequestManager.CreateUserCompletion = { success, jwtToken, error in
            if success && !jwtToken.isEmpty {
                UserSession.sharedInstance.jwtToken = jwtToken
                let userViewModel = UserViewModel.viewModelFromInfo(info: info)
                UserSession.sharedInstance.user = userViewModel
            }
            completion(success, error)
        }
        RequestManager.sharedInstance.createUser(email: info.email, name: info.name, password: info.password, passwordConfirm: info.passwordConfirm, completion: completion)
    }
    
    func saveAccountInfo(info: AccountInfo, completion:@escaping Completion) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let birthdayStr = dateFormatter.string(from: info.birthday ?? Date())
        let details: Dictionary<String, String> = [
            "name": info.name,
            "location": info.location ?? "",
            "birthdate": birthdayStr
        ]
        RequestManager.sharedInstance.updateUserDetails(session: UserSession.sharedInstance, details: details) { (success) in
            completion(success, nil)
        }
    }
    
    func fetchAccountInfo() {
        RequestManager.sharedInstance.getUserDetails(token: UserSession.sharedInstance.jwtToken) { (success, userDetails, error) in
            if success {
                // create new UserModel to trigger didSet
                let newModel = UserModel.init(email: self.userModel.email, password: self.userModel.password, name: self.userModel.name)
            
                if let name = userDetails?["name"] {
                    newModel.name = name as? String
                }
                
                let profile = userDetails?["profile"] as! [String:AnyObject]
                
                if let birthdate = profile["birthdate"] {
                    newModel.birthday = birthdate as? String
                }
                if let loc = profile["location"] {
                    newModel.location = loc as? String
                }
                self.userModel = newModel
            } else {
                // TODO: error handling here
            }
        }
    }
    
    class func viewModelFromInfo(info: SignupInfo) -> UserViewModel {
        let userModel = UserModel(email: info.email, password: info.password, name: info.name)
        return UserViewModel(email: info.email, password: info.password, name: info.name)
    }
    
    class func viewModelStub1() -> UserViewModel {
        return UserViewModel(email: "hello@hello.com", password: "hello", name: "YES IT IS I")
    }
    
    class func viewModelStub2() -> UserViewModel {
        let userModel = UserModel(email: "hello@hello.com", password: "hello", name: "Yes It Is I")
        userModel.location = "Hawaii"
        userModel.birthday = "1995-08-31"
        return UserViewModel(userModel: userModel)
    }
}
