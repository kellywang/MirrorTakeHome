//
//  SplashViewController.swift
//  MirrorTakeHome
//
//  SplashViewController lets the user login with an email and password. There's also a button
//  to go to the SignupViewController, where the user can create a new account.
//
//  Created by Kelly on 3/12/19.
//  Copyright © 2019 Kelly. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController, LoginDelegate {
    var loginView: LoginView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setupViews()
    }
    init () {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Sets up the email and password textfields, and login and signup buttons. Sets constraints.
    private func setupViews() {
        self.loginView = LoginView(frame: CGRect.zero, delegate: self, textfieldDelegate: self)
        self.loginView?.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.loginView)
        
        let margins = self.view.layoutMarginsGuide
        self.loginView?.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        self.loginView?.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        self.loginView?.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        self.loginView?.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
    
    // Takes user to the sign up page
    func didPressSignup() {
        let signupVC =  SignupViewController()
        self.present(signupVC, animated: true, completion: nil)
    }
    
    // Makes a request to log in with the email and password
    func didLogIn(info: LoginInfo) {
        // This is the completion handler for the login. If the login is successful, this block:
        // 1. Updates the UserSession singleton with the returned jwtToken
        // 2. Creates a UserViewModel for the logged in user, and attaches it to UserSession
        // 3. Makes a call to fetch the rest of the account info, if any (birthdate, location)
        // 4. Presents the Account Details page for the user
        // Shows an error message if the login is unsuccessful.
        let completion: RequestManager.LoginCompletion = { (success, jwtToken, error) in
            if success {
                self.loginView?.statusLabel.hide()
                // Set up token and user
                UserSession.sharedInstance.jwtToken = jwtToken ?? ""
                let userViewModel = UserViewModel(email: info.email, password: info.password, name: nil)
                UserSession.sharedInstance.user = userViewModel
                
                // Request the rest of the user view model data (location, birthday)
                userViewModel.fetchAccountInfo()
                let accountDetailsVC = AccountDetailsViewController()
                DispatchQueue.main.async {
                    self.present(accountDetailsVC, animated: true, completion: nil)
                }
            } else {
                DispatchQueue.main.async {
                    self.loginView?.statusLabel.showError(errorText: kLoginError)
                }
            }
        }
        
        // Actual call to log in the user
        RequestManager.sharedInstance.loginUser(email: info.email, password: info.password, completion: completion)
    }
}

