//
//  AccountDetailsViewController.swift
//  MirrorTakeHome
//
//  
//
//  Created by Kelly on 3/12/19.
//  Copyright © 2019 Kelly. All rights reserved.
//

import UIKit

class AccountDetailsViewController: UIViewController, AccountDetailsDelegate {
    var accountDetailsView: AccountDetailsView?
   
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupViewModelBindings()
    }
    
    private var user: UserViewModel {
        return UserSession.sharedInstance.user!
    }
    
    private func setupView() {
        self.view.backgroundColor = UIColor.white
        self.accountDetailsView = AccountDetailsView(frame: CGRect.zero, name: self.user.name, location: self.user.location, birthday: self.user.birthday, delegate: self)
        self.accountDetailsView?.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.accountDetailsView!)
        
        let margins = self.view.layoutMarginsGuide
        self.accountDetailsView?.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        self.accountDetailsView?.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        self.accountDetailsView?.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        self.accountDetailsView?.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
    
    private func setupViewModelBindings() {
        self.user.updateUserViews = { [weak self] () in
            let info = AccountInfo(
                name: (self?.user.name)!,
                location: self?.user.location,
                birthday: self?.user.birthday
            )
            DispatchQueue.main.async {
                self?.accountDetailsView?.updateWithAccountInfo(info: info)
            }
        }
    }
    
    func didSave() {
        let accountInfo = self.accountDetailsView?.currentAccountInfo()
        self.user.saveAccountInfo(info: accountInfo!) { (success, error) in
            if success {
                DispatchQueue.main.async {
                    self.accountDetailsView?.statusLabel.flashOnce(text: kSavedText)
                }
            } else {
                DispatchQueue.main.async {
                    self.accountDetailsView?.statusLabel.showError(errorText: kAccountDetailsError)
                }
            }
        }
    }
    
    func didLogOut() {
        UserSession.sharedInstance.invalidate()
        var presentingViewController = self.presentingViewController
        
        // Might be 2 layers deep if we through the signup flow
        // e.g. SplashVC -> SignupVC -> AccountDetailsVC instead of SplashVC -> AccountDetailsVC
        if presentingViewController?.presentingViewController != nil {
            presentingViewController = presentingViewController?.presentingViewController
        }
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
