//
//  AccountDetailsView.swift
//  MirrorTakeHome
//
//  AccountDetailsView is the settings page for the user. It lets the user change some settings.
//  It looks like:
//
//  ACCOUNT SETTINGS
//  [name textfield]
//  [location textfield]
//  [birthday date picker]
//  SAVE BUTTON
//  LOG OUT BUTTON
//
//  Created by Kelly on 3/12/19.
//  Copyright © 2019 Kelly. All rights reserved.
//

import UIKit

struct AccountInfo {
    var name: String
    var location: String?
    var birthday: Date?
}

// For AccountViewController to handle button press events
protocol AccountDetailsDelegate: class {
    func didSave()
    func didLogOut()
}

class AccountDetailsView: UIView {
    var detailLabel: UILabel!
    var nameLabel: UILabel!
    var nameField: UITextField!
    var locationLabel: UILabel!
    var locationField: UITextField!
    var birthdayLabel: UILabel!
    var birthdayPicker: UIDatePicker!
    var saveButton: UIButton!
    var logoutButton: UIButton!
    
    // For error or "loading..." type messages
    var statusLabel: UILabel!
    
    weak var delegate: AccountDetailsDelegate?
    
    init(frame: CGRect, name: String, location: String?, birthday: Date?, delegate: AccountDetailsDelegate) {
        self.delegate = delegate
        super.init(frame: frame)
        let accountInfo = AccountInfo(name: name, location: location, birthday: birthday)
        
        // Add "ACCOUNT DETAILS" header, editable fields (name, location, birthday) and save and log out buttons
        setupViews(accountInfo: accountInfo)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Used when user presses Save to return the current account settings
    func currentAccountInfo() -> AccountInfo {
        return AccountInfo(
            name: self.nameField.text ?? "",
            location: self.locationField.text,
            birthday: self.birthdayPicker.date
        )
    }
    
    // Called when the request to fetch additional account info comes back
    func updateWithAccountInfo(info:AccountInfo) {
        self.nameField.text = info.name
        self.locationField.text = info.location
        self.birthdayPicker.date = info.birthday ?? Date()
    }
    
    private func setupViews(accountInfo: AccountInfo) {
        setupDetailLabel()
        setupEditableFields(accountInfo: accountInfo)
        setupSaveButton()
        setupLogoutButton()
        setupStatusLabel()
    }
    
    // Label that says ACCOUNT DETAILS
    private func setupDetailLabel() {
        self.detailLabel = UIElementHelper.defaultLabel()
        self.detailLabel.text = kAccountDetailsText
        self.addSubview(self.detailLabel)
        
        self.detailLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: CGFloat(kElementTopPadding)).isActive = true
        self.detailLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: CGFloat(kElementSidePadding)).isActive = true
        self.detailLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: CGFloat(-kElementSidePadding)).isActive = true
    }
    
    private func setupEditableFields(accountInfo: AccountInfo) {
        setupNameField(name: accountInfo.name)
        setupLocationField(location: accountInfo.location)
        setupBirthdayPicker(birthday: accountInfo.birthday)
    }
    
    // Textfield for editing name. Label + Textfield side by side
    private func setupNameField(name: String) {
        self.nameLabel = UIElementHelper.detailLabel()
        self.nameLabel.text = kNameLabelText
        self.addSubview(self.nameLabel)
        
        self.nameField = UIElementHelper.defaultTextfield()
        self.nameField.text = name
        self.addSubview(self.nameField)
        
        self.nameLabel.topAnchor.constraint(equalTo: self.detailLabel.bottomAnchor, constant: CGFloat(kElementVerticalPadding)).isActive = true
        self.nameLabel.leftAnchor.constraint(equalTo: self.detailLabel.leftAnchor).isActive = true
        self.nameLabel.widthAnchor.constraint(equalToConstant: CGFloat(kLabelWidth)).isActive = true
        
        self.nameField.centerYAnchor.constraint(equalTo: self.nameLabel.centerYAnchor).isActive = true
        self.nameField.leftAnchor.constraint(equalTo: self.nameLabel.rightAnchor, constant: CGFloat(kDetailLabelFieldGap)).isActive = true
        self.nameField.rightAnchor.constraint(equalTo: self.detailLabel.rightAnchor).isActive = true
    }
    
    // Textfield for editing location. Label + Textfield side by side
    private func setupLocationField(location: String?) {
        self.locationLabel = UIElementHelper.detailLabel()
        self.locationLabel.text = kLocationLabelText
        self.addSubview(self.locationLabel)
        
        self.locationField = UIElementHelper.defaultTextfield()
        if location != nil || !(location?.isEmpty)! {
            self.locationField.attributedPlaceholder =
                NSAttributedString(string:kLocationFieldPlaceholder,
                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        } else {
            self.locationField.text = location
        }
        self.addSubview(self.locationField)
        
        self.locationLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: CGFloat(kElementVerticalPadding)).isActive = true
        self.locationLabel.leftAnchor.constraint(equalTo: self.nameLabel.leftAnchor).isActive = true
        self.locationLabel.widthAnchor.constraint(equalToConstant: CGFloat(kLabelWidth)).isActive = true
        
        self.locationField.centerYAnchor.constraint(equalTo: self.locationLabel.centerYAnchor).isActive = true
        self.locationField.leftAnchor.constraint(equalTo: self.locationLabel.rightAnchor, constant: CGFloat(kDetailLabelFieldGap)).isActive = true
        self.locationField.rightAnchor.constraint(equalTo: self.nameField.rightAnchor).isActive = true
    }
    
    // Datepicker for editing birthday. Label + Date picker on top of each other
    private func setupBirthdayPicker(birthday: Date?) {
        self.birthdayLabel = UIElementHelper.detailLabel()
        self.birthdayLabel.text = kBirthdayLabelText
        self.addSubview(self.birthdayLabel)
        
        UIElementHelper.setBelow(topView: self.locationLabel, bottomView: self.birthdayLabel)
        
        self.birthdayPicker = UIDatePicker()
        self.birthdayPicker.datePickerMode = UIDatePicker.Mode.date
        self.birthdayPicker.maximumDate = Date()
        self.birthdayPicker.date = birthday ?? Date()
    
        self.birthdayPicker.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.birthdayPicker)
        
        self.birthdayPicker.topAnchor.constraint(equalTo: self.birthdayLabel.bottomAnchor).isActive = true
        self.birthdayPicker.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    // Button for saving the user details to server
    private func setupSaveButton() {
        self.saveButton = UIElementHelper.defaultButton()
        self.saveButton.setTitle(kSaveButtonText, for: UIControl.State.normal)
        self.saveButton.addTarget(self, action:#selector(didPressSave), for: UIControl.Event.touchUpInside)
        self.addSubview(self.saveButton)
        UIElementHelper.setBelow(topView: self.birthdayPicker, bottomView: self.saveButton)
        self.saveButton.heightAnchor.constraint(equalToConstant: CGFloat(kButtonHeight)).isActive = true
    }
    
    // Logs out, returns user to the log in page (SplashViewController)
    private func setupLogoutButton() {
        self.logoutButton = UIElementHelper.defaultButton()
        self.logoutButton.setTitle(kLogoutButtonText, for: UIControl.State.normal)
        self.logoutButton.addTarget(self, action: #selector(didPressLogout), for: UIControl.Event.touchUpInside)
        self.addSubview(self.logoutButton)
        UIElementHelper.setBelow(topView: self.saveButton, bottomView: self.logoutButton)
        self.logoutButton.heightAnchor.constraint(equalToConstant: CGFloat(kButtonHeight)).isActive = true
    }
    
    // Shows "Saving..." or error type messages
    private func setupStatusLabel() {
        self.statusLabel = UIElementHelper.statusLabel()
        self.addSubview(self.statusLabel)
        UIElementHelper.setBelow(topView: self.logoutButton, bottomView: self.statusLabel)
        // Set invisible until we need it
        self.statusLabel.alpha = 0
    }
    
    @objc private func didPressSave() {
        self.statusLabel.flash(text: kSavingText)
        self.delegate!.didSave()
    }
    
    @objc private func didPressLogout() {
        self.delegate!.didLogOut()
    }
}
