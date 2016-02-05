//
//  OffenseViewController.swift
//  Parking
//
//  Created by Vital Vinahradau on 12/27/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import UIKit
import SwiftHEXColors

class OffenseViewController: SignalViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectButton: UIButton!
    
    private var offenses = [Offense]()
    private var selectedOffenseIndex: Int?
    
    override var brandedNavigationBar: Bool { get { return false } }
    
    override func updateViewConstraints() {
        if (!self.didSetupConstraints) {
            self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
            self.tableView.rowHeight = UITableViewAutomaticDimension
            
            self.selectButton.snp_makeConstraints { make in
                make.width.equalTo(self.view)
                make.height.equalTo(62)
                
                make.centerX.equalTo(self.view)
                make.bottom.equalTo(self.view)
            }
            
            self.tableView.snp_makeConstraints { make in
                make.width.equalTo(self.view)
                make.centerX.equalTo(self.view)
                
                make.top.equalTo(self.view)
                make.bottom.equalTo(self.selectButton.snp_top)
            }
        }
        
        super.updateViewConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Выберите тип нарушения"
        
        ServiceFactory.apiEndpointService().fetchOffences { result in
            if let offenses = result {
                self.offenses = offenses
                
                dispatch_async(dispatch_get_main_queue(), {
                    if let offence = self.viewModel.offense {
                        self.selectedOffenseIndex = self.offenses.indexOf(offence)!
                    }
                    
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedOffenseIndex = indexPath.row
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.offenses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(OffenseTableViewCell.reusableIdentifier, forIndexPath: indexPath) as! OffenseTableViewCell
        
        let row = indexPath.row
        
        cell.selected = (row == self.selectedOffenseIndex)
        
        let offense = self.offenses[row]
        
        let result = NSMutableAttributedString(attributedString: NSAttributedString(string: offense.article, attributes: [ NSForegroundColorAttributeName : UIColor(hexString: "#356094")! ]))
        result.appendAttributedString(NSAttributedString(string: "\n"))
        result.appendAttributedString(NSAttributedString(string: offense.text))
        
        cell.valueLabel.attributedText = result
        
        return cell
    }
    
    //  MARK: Actions
    
    @IBAction func onSelect(sender: AnyObject) {
        Log("Offense selection performed")
        
        if let _ = self.selectedOffenseIndex {
            self.viewModel.offense = self.offenses[self.selectedOffenseIndex!]
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}