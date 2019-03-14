//
//  SignupViewController.swift
//  MirrorTakeHome
//
//  SignupViewController handles sign up for a new user. Provides text views to fill in, and makes a call
//  to the endpoint to create the user. Can also choose to go back to the Login page (SplashVC)
//
//  Created by Kelly on 3/12/19.
//  Copyright © 2019 Kelly. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController, SignupDelegate {
    var signupView: SignupView?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Adds a SignupView and its constraints
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.signupView = SignupView(frame: CGRect.zero, delegate: self, textfieldDelegate: self)
        self.signupView?.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.signupView!)
        
        let margins = self.view.layoutMarginsGuide
        self.signupView?.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        self.signupView?.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        self.signupView?.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        self.signupView?.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
    
    // Makes a call to create a new user given the SignupInfo (email, name, password)
    func didSignup(info: SignupInfo) {
        // This is the completion handler, which is mostly for presenting the AccountDetailsViewController
        // and showing errors
        let completion: UserViewModel.Completion = { success, error in
            DispatchQueue.main.async {
                // Hide the "Signing up..."
                self.signupView?.statusLabel.hide()
            }
            if success  {
                DispatchQueue.main.async {
                    // Show view controller with the name we just signed up with
                    let accountDetailsVC = AccountDetailsViewController()
                    self.present(accountDetailsVC, animated: true, completion: nil)
                }
            } else {
                // Basic error handling
                if error == "error_user_already_exists" {
                    DispatchQueue.main.async {
                        self.signupView?.statusLabel.showError(errorText: kUserExistsError)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.signupView?.statusLabel.showError(errorText: kSignupGenericError)
                    }
                }
            }
        }
        
        // Actual call to create a new user
        UserViewModel.createNewUser(info: info, completion: completion)
    }
    
    // Back to the Login page (SplashVC)
    func didPressBack() {
        self.dismiss(animated: true, completion: nil)
    }
}
