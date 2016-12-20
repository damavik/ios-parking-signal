//
//  ReportViewController.swift
//  Parking
//
//  Created by Vital Vinahradau on 12/25/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import MZFormSheetPresentationController
import MRProgress

class ReportViewController: SignalViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    
    fileprivate func updateViewModel() {
        if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ReportTableViewFirstCell {
            self.viewModel.licensePlate = cell.textField.text
        } else {
            Log("Failed to get license plate text field")
        }
        
        if let cell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? ReportTableViewFirstCell {
            self.viewModel.addressString = cell.textField.text
        } else {
            Log("Failed to get address text field")
        }
        
        // Prefer manually entered address string over automatically fetched value
        if let addressString = self.viewModel.addressString {
            if let address = self.viewModel.address {
                if (address.stringifiedValue != addressString) {
                    self.viewModel.address = nil
                }
            }
        }
    }

    override func updateViewConstraints() {
        if (!self.didSetupConstraints) {
            self.sendButton.snp.makeConstraints { make in
                make.width.equalTo(self.view)
                make.height.equalTo(62)
                
                make.centerX.equalTo(self.view)
                make.bottom.equalTo(self.view)
            }
            
            self.tableView.snp.makeConstraints { make in
                make.width.equalTo(self.view)
                
                make.top.equalTo(self.view).offset(self.navigationController!.navigationBar.frame.height)
                make.bottom.equalTo(self.sendButton.snp.top)
                make.centerX.equalTo(self.view)
            }
        }
        
        super.updateViewConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MZFormSheetPresentationController.appearance().contentViewSize = CGSize(width: 300, height: 400)
        MZFormSheetPresentationController.appearance().shouldCenterVertically = true
        MZFormSheetPresentationController.appearance().shouldDismissOnBackgroundViewTap = true
        
        self.viewModel.date = Date()
        
        AddressManager().fetchCurrentAddress{ result in
            switch result {
            case AddressManagerResult.success(let address):
                self.viewModel.address = address
                
            case AddressManagerResult.failure:
                // TODO: review
                Log("Failed to get fetch address")
            }
            
            DispatchQueue.main.async(execute: {
                self.tableView.reloadRows(at: [ IndexPath(row: 1, section: 0) ], with: .automatic)
            })
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: SendReportRequestNotification), object: nil, queue: OperationQueue.main) { [weak self] (_) in
            if let reportToSend = self?.viewModel.formReport() {
                
                let progressView = MRProgressOverlayView()
                progressView.titleLabelText = "Отправка..."
                self?.view.window?.addSubview(progressView)
                progressView.show(true)
                
                ServiceFactory.apiEndpointService().uploadOffenseReport(reportToSend) { error in
                    DispatchQueue.main.async(execute: {
                        progressView.hide(true)
                        
                        if let _ = error {
                            Log("Failed to upload report with error '%@'", error!)
                            self?.showFailureMark(nil)
                        } else {
                            Log("Succeed to upload report")
                            self?.showSuccessMark(nil)
                            _ = self?.navigationController?.popToRootViewController(animated: true)
                        }
                    })
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let tintColor = UIColor.black
        
        self.navigationController?.navigationBar.tintColor = tintColor
        
        if let navigationImageView = self.navigationItem.titleView as? UIImageView {
            navigationImageView.image = UIImage(named: "logo")?.tint(tintColor)
        }
        
        UIApplication.shared.statusBarStyle = .default
        
        if let _ = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: (self.tableView.indexPathForSelectedRow)!, animated: false)
        }
        
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.updateViewModel()
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (identifier == "ShowOffenseDisclaimer") {
            self.updateViewModel()
            
            guard let licensePlate = self.viewModel.licensePlate, !licensePlate.isEmpty else {
                DispatchQueue.main.async(execute: { [weak self] in
                    Log("Attempt to create report without license plate specified")
                    self?.showFailureMark("Не указан номер")
                })
                
                return false
            }
            
            guard let address = self.viewModel.addressString, !address.isEmpty else {
                DispatchQueue.main.async(execute: { [weak self] in
                    Log("Attempt to create report without address specified")
                    self?.showFailureMark("Не указан адрес")
                })
                
                return false
            }
            
            guard let _ = self.viewModel.offense else {
                DispatchQueue.main.async(execute: { [weak self] in
                    Log("Attempt to create report without offense specified")
                    self?.showFailureMark("Не указана статья")
                })
                
                return false
            }
        }
        
        return true
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 3) {
            self.performSegue(withIdentifier: "ShowOffensePicker", sender: self)
        }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var result: UITableViewCell? = nil
        
        // FIXME: add proper localization for strings
        switch indexPath.row {
        case 0...1:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReportTableViewFirstCell.reusableIdentifier, for: indexPath) as! ReportTableViewFirstCell
            
            cell.textField.text = ""
            if (indexPath.row == 0) {
                cell.titleLabel.text = "Номер"
                cell.textField.placeholder = "Номер автомобиля"
                cell.textField.text = self.viewModel.licensePlate
            } else {
                cell.titleLabel.text = "Адрес"
                cell.textField.placeholder = "Адрес правонарушения"
                
                if let address = self.viewModel.address {
                    if (!address.stringifiedValue.isEmpty) {
                        cell.textField.text = address.stringifiedValue
                    }
                } else if let addressString = self.viewModel.addressString {
                    cell.textField.text = addressString
                }
            }
            
            result = cell
            
        case 2...3:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReportTableViewSecondCell.reusableIdentifier, for: indexPath) as! ReportTableViewSecondCell
            
            if (indexPath.row == 2) {
                cell.titleLabel.text = "Дата"
                cell.valueLabel.text = self.viewModel.dateFormatter.string(from: self.viewModel.date)
                
                cell.selectionStyle = .none
            } else {
                cell.titleLabel.text = "Нарушение"
                
                if let offense = self.viewModel.offense {
                    cell.valueLabel.text = "п. " + offense.article
                } else {
                    cell.valueLabel.text = "Выбрать"
                }
            }
            
            result = cell
            
        default:
            break
        }
        
        return result!
    }
}
