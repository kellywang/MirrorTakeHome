//
//  RequestManager.swift
//  MirrorTakeHome
//
//  RequestManager is a singleton that makes requests to log in, sign up, get user account info, or update user
//  account info.
//  Error handling not the best here tbh
//
//  Created by Kelly on 3/12/19.
//  Copyright © 2019 Kelly. All rights reserved.
//

import UIKit

class RequestManager {
    let baseURL : String = "https://dev.refinemirror.com/api/v1/"
    
    static let sharedInstance : RequestManager = RequestManager()
    
    // MARK: endpoint constants
    static let createUserEndpoint : String = "auth/signup"
    static let loginUserEndpoint : String = "auth/login"
    static let userDetailsEndpoint : String = "user/me"
    
    // MARK: completion types
    typealias CreateUserCompletion = (_ success: Bool, _ token: String, _ error: String?) -> Void
    typealias LoginCompletion = (_ success: Bool, _ token: String?, _ error: String?) -> Void
    typealias GetUserDetailsCompletion = (_ success: Bool, _ userDetails:[String:AnyObject]?, _ error: String?) -> Void
    typealias UpdateUserDetailsCompletion = (_ success: Bool) -> Void
    
    // Makes a call to create the user. If successful, sends back a jwt token. If unsuccessful, sends back an error of some kind.
    func createUser(email: String, name: String, password: String, passwordConfirm: String, completion: @escaping CreateUserCompletion) {
        let url = baseURL + RequestManager.createUserEndpoint
        let jsonDict = ["email": email,
                                   "name": name,
                                   "password": password,
                                   "password2": passwordConfirm ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict)
        
        var request = URLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error -> Void in
            guard let data = data, error == nil else {
                print("error:", error ?? "nil")
                completion(false, "", "")
                return
            }
            let responseObject = try? JSONSerialization.jsonObject(with: data) as! [String:Any]
            // TODO: Handle expiration too?
            if let errorCode = responseObject?["error_short_code"] {
                completion(false, "", errorCode as? String)
            } else {
                let tokens = responseObject?["data"] as! [String:Any]
                let jwtToken = tokens["api_token"] as! String
                completion(true, jwtToken, "")
            }
        })
        task.resume()
    }
    
    // Logs in the user with the info given. If successful, returns a jwt token. If unsuccessful, sends back an error of some kind.
    func loginUser(email: String, password: String, completion: @escaping LoginCompletion) {
        let url = baseURL + RequestManager.loginUserEndpoint
        let jsonDict = ["email": email,
                        "password": password ]
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict)

        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error -> Void in
            
            guard let data = data, error == nil else {
                print("error:", error ?? "nil")
                completion(false, "", error.debugDescription)
                return
            }
  
            let responseObject = try? JSONSerialization.jsonObject(with: data) as! [String:Any]
            // Handle expiration too?
            if let errorCode = responseObject?["error_short_code"] {
                completion(false, "", errorCode as? String)
            } else {
                let tokens = responseObject?["data"] as! [String:Any]
                let jwtToken = tokens["api_token"] as! String
                completion(true, jwtToken, "")
            }
        })
        task.resume()
    }
    
    // Fetches additional user details given the jwt token. If successful, returns a dictionary of user info to the caller.
    func getUserDetails(token: String, completion: @escaping GetUserDetailsCompletion) {
        let url = baseURL + RequestManager.userDetailsEndpoint
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error -> Void in
            guard let data = data, error == nil else {
                print("error:", error ?? "nil")
                completion(false, nil, error?.localizedDescription)
                return
            }
        
            let responseObject = try? JSONSerialization.jsonObject(with: data) as! [String:AnyObject]
            if let errorCode = responseObject?["error_short_code"] {
                print(errorCode)
                completion(false, nil, errorCode as? String)
            } else {
                let details = responseObject?["data"] as! [String:AnyObject]
                completion(true, details, nil)
            }
        })
        task.resume()
    }
    
    // Updates the user's account info with the details dictionary, which can contain up to 3 fields: name, location, birthday.
    func updateUserDetails(session: UserSession, details: [String:String], completion: @escaping UpdateUserDetailsCompletion) {
        let url = baseURL + RequestManager.userDetailsEndpoint
        let jsonData = try? JSONSerialization.data(withJSONObject: details)
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "PATCH"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(session.jwtToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error -> Void in
            guard let data = data, error == nil else {
                print("error:", error ?? "nil")
                completion(false)
                return
            }
            let responseObject = try? JSONSerialization.jsonObject(with: data) as! [String:Any]
                if responseObject?["error_short_code"] != nil {
                    completion(false)
                } else {
                    completion(true)
                }
            
        })
        task.resume()
    }
}
