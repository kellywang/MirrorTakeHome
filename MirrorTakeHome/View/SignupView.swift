//
//  SignupView.swift
//  MirrorTakeHome
//
//  SignupView is the view with the fields the user needs to fill out to create a new account.
//  It also has a back button to take the user back to the log in page, SplashViewController.
//  It looks like:
//
//  CREATE ACCOUNT
//  [email field]
//  [name field]
//  [password field]
//  [confirm password field]
//  SIGN UP BUTTON
//  BACK BUTTON
//
//  Created by Kelly on 3/12/19.
//  Copyright © 2019 Kelly. All rights reserved.
//

import UIKit

struct SignupInfo {
    var email: String
    var password: String
    var passwordConfirm: String
    var name: String
}

// For SignupViewController to handle button press events
protocol SignupDelegate: class {
    func didSignup(info: SignupInfo)
    func didPressBack()
}

class SignupView: UIView {
    var signupLabel: UILabel!
    var emailField: UITextField!
    var passwordField: UITextField!
    var passwordConfirmField: UITextField!
    var nameField: UITextField!
    var signupButton: UIButton!
    var backButton: UIButton!
    
    // For error or "loading..." type messages
    var statusLabel: UILabel!
    
    weak var delegate: SignupDelegate?
    // For coloring the textfield from error red back to black. See Helper/UITextfieldExtension for more.
    weak var textfieldDelegate: UITextFieldDelegate?
    
    init(frame: CGRect, delegate: SignupDelegate, textfieldDelegate: UITextFieldDelegate) {
        self.delegate = delegate
        self.textfieldDelegate = textfieldDelegate
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Add "CREATE ACCOUNT" header and textfields
    private func setupViews() {
        setupSignupLabel()
        setupEditableFields()
        setupSignupButton()
        setupBackButton()
        setupStatusLabel()
    }
    
    // "CREATE ACCOUNT"
    private func setupSignupLabel() {
        self.signupLabel = UIElementHelper.defaultLabel()
        self.signupLabel.text = kSignupLabelText
        self.addSubview(self.signupLabel)
        
        self.signupLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: CGFloat(kElementTopPadding)).isActive = true
        self.signupLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: CGFloat(kElementSidePadding)).isActive = true
        self.signupLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: CGFloat(-kElementSidePadding)).isActive = true
    }
    
    // Textfields for email, name, password, password confirm
    private func setupEditableFields() {
        self.emailField = UIElementHelper.defaultTextfield()
        self.emailField.attributedPlaceholder =
            NSAttributedString(string:kEmailTextFieldText,
                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        self.emailField.delegate = self.textfieldDelegate
        self.addSubview(self.emailField)
        
        self.nameField = UIElementHelper.defaultTextfield()
        self.nameField.attributedPlaceholder =
            NSAttributedString(string:kNameTextfieldText,
                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        self.nameField.delegate = self.textfieldDelegate
        self.addSubview(self.nameField)
        
        self.passwordField = UIElementHelper.defaultTextfield()
        self.passwordField.attributedPlaceholder =
            NSAttributedString(string:kPasswordTextFieldText,
                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        self.passwordField.isSecureTextEntry = true
        self.passwordField.delegate = self.textfieldDelegate
        self.addSubview(self.passwordField)
        
        self.passwordConfirmField = UIElementHelper.defaultTextfield()
        self.passwordConfirmField.attributedPlaceholder =
            NSAttributedString(string:kPasswordConfirmTextFieldText,
                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        self.passwordConfirmField.isSecureTextEntry = true
        self.passwordConfirmField.delegate = self.textfieldDelegate
        self.addSubview(self.passwordConfirmField)
        
        UIElementHelper.setBelow(topView: self.signupLabel, bottomView: self.emailField)
        UIElementHelper.setBelow(topView: self.emailField, bottomView: self.nameField)
        UIElementHelper.setBelow(topView: self.nameField, bottomView: self.passwordField)
        UIElementHelper.setBelow(topView: self.passwordField, bottomView: self.passwordConfirmField)
    }
    
    private func setupSignupButton() {
        self.signupButton = UIElementHelper.defaultButton()
        self.signupButton.setTitle(kSignupButtonText, for: UIControl.State.normal)
        self.signupButton.addTarget(self, action: #selector(didPressSignup), for: UIControl.Event.touchUpInside)
        self.addSubview(self.signupButton)
        UIElementHelper.setBelow(topView: self.passwordConfirmField, bottomView: self.signupButton)
        self.signupButton.heightAnchor.constraint(equalToConstant: CGFloat(kButtonHeight)).isActive = true
    }
    
    private func setupBackButton() {
        self.backButton = UIElementHelper.defaultButton()
        self.backButton.setTitle(kBackButtonText, for: UIControl.State.normal)
        self.backButton.addTarget(self, action: #selector(didPressBack), for: UIControl.Event.touchUpInside)
        self.addSubview(self.backButton)
        UIElementHelper.setBelow(topView: self.signupButton , bottomView: self.backButton)
        self.backButton.heightAnchor.constraint(equalToConstant: CGFloat(kButtonHeight)).isActive = true
    }
    
    // For "Signing up..." or error type messages
    private func setupStatusLabel() {
        self.statusLabel = UIElementHelper.statusLabel()
        self.addSubview(self.statusLabel)
        UIElementHelper.setBelow(topView: self.backButton, bottomView: self.statusLabel)
        // Set invisible until we need it
        self.statusLabel.alpha = 0
    }
    
    // Sanity checks the sign up fields (email, name, password x2) and then tells the SignupDelegate,
    // SignupViewController, to sign up with the info given in the textfields
    @objc private func didPressSignup() {
        // Fields must not be empty, or we'll show a red border to indicate error
        guard let email = self.emailField.text, !email.isEmpty else {
            self.emailField.layer.borderColor = UIColor.red.cgColor
            self.emailField.layer.borderWidth = 1.0
            self.statusLabel.showError(errorText: kEmailError)
            return
        }
        
        guard let name = self.nameField.text, !name.isEmpty else {
            self.nameField.layer.borderColor = UIColor.red.cgColor
            self.nameField.layer.borderWidth = 1.0
            self.statusLabel.showError(errorText: kNameError)
            return
        }
        
        guard let password = self.passwordField.text, !password.isEmpty else {
            self.passwordField.layer.borderColor = UIColor.red.cgColor
            self.passwordField.layer.borderWidth = 1.0
            self.statusLabel.showError(errorText: kPasswordError)
            return
        }
        
        guard let passwordConfirm = self.passwordConfirmField.text, !passwordConfirm.isEmpty, password == passwordConfirm  else {
            self.passwordConfirmField.layer.borderColor = UIColor.red.cgColor
            self.passwordConfirmField.layer.borderWidth = 1.0
            self.statusLabel.showError(errorText: kMatchingPasswordError)
            return
        }
        
        let info = SignupInfo(email: email, password: password, passwordConfirm: passwordConfirm, name: name)
        self.delegate?.didSignup(info: info)
        self.statusLabel.flash(text: kSigningUpText)
    }
    
    @objc private func didPressBack() {
        self.delegate?.didPressBack()
    }
}
