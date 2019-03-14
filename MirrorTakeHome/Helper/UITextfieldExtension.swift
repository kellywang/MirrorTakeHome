//
//  UITextfieldExtension.swift
//  MirrorTakeHome
//
//  We color the textfield border red to show an error with the input. This extension
//  is for changing the color back if the user enters input.
//
//  Created by Kelly on 3/12/19.
//  Copyright © 2019 Kelly. All rights reserved.
//

import UIKit

extension UIViewController : UITextFieldDelegate {
    // Want to make sure the textfield border is no longer red if user enters input
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if !textField.text!.isEmpty {
            textField.layer.borderWidth = 0
        }
    }
}
