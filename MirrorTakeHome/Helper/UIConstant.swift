//
//  UIConstant.swift
//  MirrorTakeHome
//
//  UIConstant is where I dumped constants, mostly for fonts, constraints, and texts
//
//  Created by Kelly on 3/12/19.
//  Copyright © 2019 Kelly. All rights reserved.
//

import Foundation
import UIKit

// MARK: fonts

let kPrimaryFontName : String = "Menlo"
let kPrimaryFontBoldName : String = "Menlo-Bold"
let kPrimaryFontItalicName : String = "Menlo-Italic"

struct FontHelper {
    static func primaryFontDefault() -> UIFont {
        return UIFont(name:kPrimaryFontName, size:15)!
    }
    
    static func primaryFont(size:CGFloat) -> UIFont {
        return UIFont(name:kPrimaryFontName, size:size)!
    }

    static func primaryFontBold(size:CGFloat) -> UIFont {
        return UIFont(name:kPrimaryFontBoldName, size:size)!
    }
    
    static func primaryFontItalic(size:CGFloat) -> UIFont {
        return UIFont(name:kPrimaryFontItalicName, size:size)!
    }
}

// MARK: UIElements

// Login
let kLoginLabelText = "EXISTING USER"
let kSignupLabelText = "CREATE ACCOUNT"
let kEmailTextFieldText = "email"
let kPasswordTextFieldText = "password"
let kLoginButtonText = "LOG IN"
let kSignupButtonText = "SIGN UP"
let kLoggingInText = "Logging in..."

// Signup
let kPasswordConfirmTextFieldText = "confirm password"
let kNameTextfieldText = "name"
let kBackButtonText = "BACK"
let kSigningUpText = "Signing up..."


// Account details
let kAccountDetailsText = "ACCOUNT DETAILS"
let kLogoutButtonText = "LOG OUT"
let kSaveButtonText = "SAVE"
let kSavingText = "Saving..."
let kSavedText = "Saved!"

let kNameLabelText = "Name: "
let kLocationLabelText = "Location: "
let kLocationFieldPlaceholder = "Enter location"
let kBirthdayLabelText = "Birthday: "

let kElementSidePadding = 45
let kElementTopPadding = 50
let kElementVerticalPadding = 25
let kButtonHeight = 30
let kLabelWidth = 100
let kDetailLabelFieldGap = 10

// Errors
let kLoginError = "Could not log in"
let kAccountDetailsError = "Had trouble saving :("

let kUserExistsError = "User with email already exists"
let kSignupGenericError = "Could not sign up :("
let kEmailError = "Need an email"
let kNameError = "Need a name"
let kPasswordError = "Need a password"
let kMatchingPasswordError = "Need matching passwords"
