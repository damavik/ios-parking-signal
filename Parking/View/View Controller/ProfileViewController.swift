//
//  ProfileViewController.swift
//  Parking
//
//  Created by Vital Vinahradau on 12/29/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import UIKit

class ProfileViewController: SignalViewController, UITableViewDelegate, UITableViewDataSource {
    fileprivate lazy var identityService = ServiceFactory.identityService()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    
    override var brandedNavigationBar: Bool { get { return false } }
    
    override func updateViewConstraints() {
        if (!self.didSetupConstraints) {
            self.tableView.rowHeight = 64
            
            self.saveButton.snp.makeConstraints { make in
                make.width.equalTo(self.view)
                make.height.equalTo(62)
                
                make.centerX.equalTo(self.view)
                make.bottom.equalTo(self.view)
            }
            
            self.tableView.snp.makeConstraints { make in
                make.width.equalTo(self.view)
                make.centerX.equalTo(self.view)
                
                make.top.equalTo(self.view)
                
                make.bottom.equalTo(self.saveButton.snp.top)
            }
        }
        
        super.updateViewConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = "Контактные данные".uppercased()
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.reusableIdentifier, for: indexPath) as! ProfileTableViewCell
        
        let row = indexPath.row
        switch row {
        case 0:
            cell.titleLabel.text = "ФИО"
            cell.textField.text = self.identityService.name
            cell.textField.placeholder = "Фамилия, имя, отчество"
            cell.textField.keyboardType = .default
            cell.textField.autocapitalizationType = .words
            
        case 1:
            cell.titleLabel.text = "Адрес прописки"
            cell.textField.text = self.identityService.address
            cell.textField.placeholder = "Адрес прописки/регистрации"
            cell.textField.keyboardType = .default
            cell.textField.autocapitalizationType = .none
            
        case 2:
            cell.titleLabel.text = "E-mail"
            cell.textField.text = self.identityService.email
            cell.textField.placeholder = "Электронный ящик"
            cell.textField.keyboardType = .emailAddress
            cell.textField.autocapitalizationType = .none
            
        default:
            cell.titleLabel.text = nil
            cell.textField.text = nil
        }
        
        return cell
    }
    
    //  MARK: Actions
    
    @IBAction func onSave(_ sender: AnyObject) {
        Log("Profile save initiated")
        
        if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ProfileTableViewCell {
            self.viewModel.reporterName = cell.textField.text
            self.identityService.name = self.viewModel.reporterName
        }
        
        if let cell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? ProfileTableViewCell {
            self.viewModel.reporterResidenceAddress = cell.textField.text
            self.identityService.address = self.viewModel.reporterResidenceAddress
        }
        
        if let cell = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? ProfileTableViewCell {
            self.viewModel.reporterEmail = cell.textField.text
            self.identityService.email = self.viewModel.reporterEmail
        }
        
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: Notification.Name(rawValue: SendReportRequestNotification), object: nil)
        }
    }
}
