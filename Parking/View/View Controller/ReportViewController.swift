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
    
    private func updateViewModel() {
        if let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? ReportTableViewFirstCell {
            self.viewModel.licensePlate = cell.textField.text
        } else {
            Log("Failed to get license plate text field")
        }
        
        if let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as? ReportTableViewFirstCell {
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
            self.sendButton.snp_makeConstraints { make in
                make.width.equalTo(self.view)
                make.height.equalTo(62)
                
                make.centerX.equalTo(self.view)
                make.bottom.equalTo(self.view)
            }
            
            self.tableView.snp_makeConstraints { make in
                make.width.equalTo(self.view)
                
                make.top.equalTo(self.view).offset(CGRectGetHeight(self.navigationController!.navigationBar.frame))
                make.bottom.equalTo(self.sendButton.snp_top)
                make.centerX.equalTo(self.view)
            }
        }
        
        super.updateViewConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MZFormSheetPresentationController.appearance().contentViewSize = CGSizeMake(300, 400)
        MZFormSheetPresentationController.appearance().shouldCenterVertically = true
        MZFormSheetPresentationController.appearance().shouldDismissOnBackgroundViewTap = true
        
        self.viewModel.date = NSDate()
        
        AddressManager().fetchCurrentAddress{ result in
            switch result {
            case AddressManagerResult.Success(let address):
                self.viewModel.address = address
                
            case AddressManagerResult.Failure:
                // TODO: review
                Log("Failed to get fetch address")
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadRowsAtIndexPaths([ NSIndexPath(forRow: 1, inSection: 0) ], withRowAnimation: .Automatic)
            })
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName(SendReportRequestNotification, object: nil, queue: NSOperationQueue.mainQueue()) { [weak self] (_) in
            if let reportToSend = self?.viewModel.formReport() {
                
                let progressView = MRProgressOverlayView()
                progressView.titleLabelText = "Отправка..."
                self?.view.window?.addSubview(progressView)
                progressView.show(true)
                
                ServiceFactory.apiEndpointService().uploadOffenseReport(reportToSend) { error in
                    dispatch_async(dispatch_get_main_queue(), {
                        progressView.hide(true)
                        
                        if let _ = error {
                            Log("Failed to upload report with error '%@'", error!)
                            self?.showFailureMark(nil)
                        } else {
                            Log("Succeed to upload report")
                            self?.showSuccessMark(nil)
                            self?.navigationController?.popToRootViewControllerAnimated(true)
                        }
                    })
                }
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let tintColor = UIColor.blackColor()
        
        self.navigationController?.navigationBar.tintColor = tintColor
        
        if let navigationImageView = self.navigationItem.titleView as? UIImageView {
            navigationImageView.image = UIImage(named: "logo")?.tint(tintColor)
        }
        
        UIApplication.sharedApplication().statusBarStyle = .Default
        
        if let _ = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRowAtIndexPath((self.tableView.indexPathForSelectedRow)!, animated: false)
        }
        
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.updateViewModel()
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if (identifier == "ShowOffenseDisclaimer") {
            self.updateViewModel()
            
            guard let licensePlate = self.viewModel.licensePlate where !licensePlate.isEmpty else {
                dispatch_async(dispatch_get_main_queue(), { [weak self] in
                    Log("Attempt to create report without license plate specified")
                    self?.showFailureMark("Не указан номер")
                })
                
                return false
            }
            
            guard let address = self.viewModel.addressString where !address.isEmpty else {
                dispatch_async(dispatch_get_main_queue(), { [weak self] in
                    Log("Attempt to create report without address specified")
                    self?.showFailureMark("Не указан адрес")
                })
                
                return false
            }
            
            guard let _ = self.viewModel.offense else {
                dispatch_async(dispatch_get_main_queue(), { [weak self] in
                    Log("Attempt to create report without offense specified")
                    self?.showFailureMark("Не указана статья")
                })
                
                return false
            }
        }
        
        return true
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == 3) {
            self.performSegueWithIdentifier("ShowOffensePicker", sender: self)
        }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var result: UITableViewCell? = nil
        
        // FIXME: add proper localization for strings
        switch indexPath.row {
        case 0...1:
            let cell = tableView.dequeueReusableCellWithIdentifier(ReportTableViewFirstCell.reusableIdentifier, forIndexPath: indexPath) as! ReportTableViewFirstCell
            
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
            let cell = tableView.dequeueReusableCellWithIdentifier(ReportTableViewSecondCell.reusableIdentifier, forIndexPath: indexPath) as! ReportTableViewSecondCell
            
            if (indexPath.row == 2) {
                cell.titleLabel.text = "Дата"
                cell.valueLabel.text = self.viewModel.dateFormatter.stringFromDate(self.viewModel.date)
                
                cell.selectionStyle = .None
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