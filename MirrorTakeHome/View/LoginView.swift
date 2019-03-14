//
//  LoginView.swift
//  MirrorTakeHome
//
//  LoginView is the view on SplashViewController, which the user sees when they first launch the app. It
//  lets the user log in to an existing account.
//  It looks like:
//
//  EXISTING USER
//  [email field]
//  [password field]
//  LOG IN BUTTON
//  SIGN UP BUTTON <= when pressed, will take user to a different page to create a fresh account
//
//  Created by Kelly on 3/13/19.
//  Copyright © 2019 Kelly. All rights reserved.
//

import UIKit

struct LoginInfo {
    var email: String
    var password: String
}

// For LoginViewController to handle button events
protocol LoginDelegate: class {
    func didLogIn(info: LoginInfo)
    func didPressSignup()
}

class LoginView: UIView {
    var loginLabel: UILabel!
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    var loginButton: UIButton!
    
    var signupButton: UIButton!
    
    // For error or "loading..." type messages
    var statusLabel: UILabel!
    
    weak var delegate: LoginDelegate?
    weak var textfieldDelegate: UITextFieldDelegate?
    
    init(frame: CGRect, delegate: LoginDelegate, textfieldDelegate: UITextFieldDelegate) {
        self.delegate = delegate
        self.textfieldDelegate = textfieldDelegate
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        setupLoginLabel()
        setupEmailTextfield()
        setupPasswordTextfield()
        setupLoginButton()
        setupSignupButton()
        setupStatusLabel()
    }
    
    // MARK: UI Elements
    private func setupLoginLabel() {
        self.loginLabel = UIElementHelper.defaultLabel()
        self.loginLabel.text = kLoginLabelText
        self.addSubview(self.loginLabel)
        
        self.loginLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: CGFloat(kElementTopPadding)).isActive = true
        self.loginLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: CGFloat(kElementSidePadding)).isActive = true
        self.loginLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: CGFloat(-kElementSidePadding)).isActive = true
    }
    
    private func setupEmailTextfield() {
        self.emailTextField =  UIElementHelper.defaultTextfield()
        self.emailTextField.attributedPlaceholder =
            NSAttributedString(string:kEmailTextFieldText,
                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        self.addSubview(self.emailTextField)
        self.emailTextField.delegate = self.textfieldDelegate
        UIElementHelper.setBelow(topView: self.loginLabel, bottomView: self.emailTextField)
    }
    
    private func setupPasswordTextfield() {
        self.passwordTextField = UIElementHelper.defaultTextfield()
        self.passwordTextField.attributedPlaceholder =
            NSAttributedString(string:kPasswordTextFieldText,
                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        self.passwordTextField.isSecureTextEntry = true
        self.addSubview(self.passwordTextField)
        UIElementHelper.setBelow(topView: self.emailTextField, bottomView: self.passwordTextField)
    }
    
    private func setupLoginButton() {
        self.loginButton = UIElementHelper.defaultButton()
        self.loginButton.setTitle(kLoginButtonText, for: UIControl.State.normal)
        self.loginButton.addTarget(self, action: #selector(didPressLogin), for: UIControl.Event.touchUpInside)
        self.addSubview(self.loginButton)
        UIElementHelper.setBelow(topView: self.passwordTextField, bottomView: self.loginButton)
        self.loginButton.heightAnchor.constraint(equalToConstant: CGFloat(kButtonHeight)).isActive = true
    }
    
    private func setupSignupButton() {
        self.signupButton = UIElementHelper.defaultButton()
        self.signupButton.setTitle(kSignupButtonText, for: UIControl.State.normal)
        self.signupButton.addTarget(self, action: #selector(didPressSignup), for: UIControl.Event.touchUpInside)
        self.addSubview(self.signupButton)
        UIElementHelper.setBelow(topView: self.loginButton, bottomView: self.signupButton)
        self.signupButton.heightAnchor.constraint(equalToConstant: CGFloat(kButtonHeight)).isActive = true
    }
    
    // For "Logging in..." or error messages
    private func setupStatusLabel() {
        self.statusLabel = UIElementHelper.statusLabel()
        self.addSubview(self.statusLabel)
        UIElementHelper.setBelow(topView: self.signupButton, bottomView: self.statusLabel)
        // Set invisible until we need it
        self.statusLabel.alpha = 0
    }
    
    // We clear the fields when we log in, so that they will be clear when we log back out
    private func clearFields() {
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
    }
    
    // Checks that email and password fields are filled out before sending them to its LoginDelegate, LoginViewController
    @objc func didPressLogin() {
        guard let email = self.emailTextField.text, !email.isEmpty else {
            self.emailTextField.layer.borderWidth = 1.0
            self.emailTextField.layer.borderColor = UIColor.red.cgColor
            self.statusLabel.showError(errorText: kEmailError)
            return
        }
        
        guard let password = self.passwordTextField.text, !password.isEmpty else {
            self.passwordTextField.layer.borderWidth = 1.0
            self.passwordTextField.layer.borderColor = UIColor.red.cgColor
            self.statusLabel.showError(errorText: kPasswordError)
            return
        }
        
        let info = LoginInfo(email: email, password: password)
        
        self.delegate?.didLogIn(info: info)
        self.statusLabel.flash(text: kLoggingInText)
        clearFields()
    }
    
    // Takes user to the create account page, SignupViewController
    @objc private func didPressSignup() {
        clearFields()
        self.delegate?.didPressSignup()
    }
}
