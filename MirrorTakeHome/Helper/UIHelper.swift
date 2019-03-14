//
//  UIHelper.swift
//  MirrorTakeHome
//
//  UIHelper has a UIElementHelper class with static methods to easily create commonly used UIElements,
//  like UILabel, UITextfield, and UIButton. It also has a setBelow method to easily place UIElements
//  below each other.
//
//  Created by Kelly on 3/12/19.
//  Copyright © 2019 Kelly. All rights reserved.
//

import UIKit

class UIElementHelper {
    static func defaultLabel() -> UILabel {
        let defaultLabel = UILabel(frame: CGRect.zero)
        defaultLabel.font = FontHelper.primaryFont(size: 19)
        defaultLabel.translatesAutoresizingMaskIntoConstraints = false
        return defaultLabel
    }
    
    static func defaultTextfield() -> UITextField {
        let defaultTextField =  UITextField(frame: CGRect.zero)
        defaultTextField.font = FontHelper.primaryFontDefault()
        defaultTextField.borderStyle = UITextField.BorderStyle.roundedRect
        defaultTextField.autocorrectionType = UITextAutocorrectionType.no
        defaultTextField.keyboardType = UIKeyboardType.default
        defaultTextField.translatesAutoresizingMaskIntoConstraints = false
        return defaultTextField
    }
    
    static func defaultButton() -> UIButton {
        let defaultButton = UIButton(frame: CGRect.zero) // let preferred over var here
        defaultButton.titleLabel?.font = FontHelper.primaryFontDefault()
        defaultButton.backgroundColor = UIColor.black
        defaultButton.translatesAutoresizingMaskIntoConstraints = false
        return defaultButton
    }
    
    static func detailLabel() -> UILabel {
        let detailLabel = UILabel(frame: CGRect.zero)
        detailLabel.font = FontHelper.primaryFontDefault()
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        return detailLabel
    }
    
    static func statusLabel() -> UILabel {
        let statusLabel = UILabel(frame: CGRect.zero)
        statusLabel.font = FontHelper.primaryFontItalic(size: 15)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        return statusLabel
    }
    
    static func setBelow(topView: UIView, bottomView: UIView) {
        bottomView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant:CGFloat(kElementVerticalPadding)).isActive = true
        bottomView.leftAnchor.constraint(equalTo: topView.leftAnchor).isActive = true
        bottomView.rightAnchor.constraint(equalTo: topView.rightAnchor).isActive = true
    }
}
