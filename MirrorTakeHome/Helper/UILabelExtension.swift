//
//  UILabelExtension.swift
//  MirrorTakeHome
//
//  This UILabel extension is for animation purposes only. We animate labels for loading or error messages.
//
//  Created by Kelly on 3/14/19.
//  Copyright © 2019 Kelly. All rights reserved.
//

import UIKit

extension UILabel {
    // Flash text until user calls hide()
    func flash(text: String) {
        self.alpha = 1.0
        self.textColor = UIColor.black
        self.text = text
        UIView.animate(withDuration: 0.8,
                       delay:0.0,
                       options:[.allowUserInteraction, .curveEaseInOut, .autoreverse, .repeat],
                       animations: { [weak self] in self?.alpha = 0 },
                       completion: nil)
    }
    
    // Flash once and fade out
    func flashOnce(text: String) {
        self.alpha = 1.0
        self.textColor = UIColor.black
        self.text = text
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            UIView.animate(withDuration: 0.5,
                           delay: 0.0,
                           options: UIView.AnimationOptions.curveEaseOut,
                           animations: { [weak self] in self?.alpha = 0 },
                           completion: { (Bool) in
                            self.hide()
            })
        }
    }
    
    // Error in red text
    func showError(errorText: String) {
        self.alpha = 1.0
        self.textColor = UIColor.red
        self.text = errorText
    }
    
    // Hides the label
    func hide() {
        DispatchQueue.main.async {
            self.layer.removeAllAnimations()
            self.alpha = 0
        }
    }
}
