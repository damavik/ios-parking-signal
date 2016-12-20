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
    
    fileprivate var offenses = [Offense]()
    fileprivate var selectedOffenseIndex: Int?
    
    override var brandedNavigationBar: Bool { get { return false } }
    
    override func updateViewConstraints() {
        if (!self.didSetupConstraints) {
            self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
            self.tableView.rowHeight = UITableViewAutomaticDimension
            
            self.selectButton.snp.makeConstraints { make in
                make.width.equalTo(self.view)
                make.height.equalTo(62)
                
                make.centerX.equalTo(self.view)
                make.bottom.equalTo(self.view)
            }
            
            self.tableView.snp.makeConstraints { make in
                make.width.equalTo(self.view)
                make.centerX.equalTo(self.view)
                
                make.top.equalTo(self.view)
                make.bottom.equalTo(self.selectButton.snp.top)
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
                
                DispatchQueue.main.async(execute: {
                    if let offence = self.viewModel.offense {
                        self.selectedOffenseIndex = self.offenses.index(of: offence)!
                    }
                    
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedOffenseIndex = indexPath.row
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.offenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OffenseTableViewCell.reusableIdentifier, for: indexPath) as! OffenseTableViewCell
        
        let row = indexPath.row
        
        cell.isSelected = (row == self.selectedOffenseIndex)
        
        let offense = self.offenses[row]
        
        let result = NSMutableAttributedString(attributedString: NSAttributedString(string: offense.article, attributes: [ NSForegroundColorAttributeName : UIColor(hexString: "#356094")! ]))
        result.append(NSAttributedString(string: "\n"))
        result.append(NSAttributedString(string: offense.text))
        
        cell.valueLabel.attributedText = result
        
        return cell
    }
    
    //  MARK: Actions
    
    @IBAction func onSelect(_ sender: AnyObject) {
        Log("Offense selection performed")
        
        if let _ = self.selectedOffenseIndex {
            self.viewModel.offense = self.offenses[self.selectedOffenseIndex!]
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
