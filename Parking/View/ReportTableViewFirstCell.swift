//
//  ReportTableViewFirstCell.swift
//  Parking
//
//  Created by Vital Vinahradau on 12/25/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import UIKit

class ReportTableViewFirstCell: UITableViewCell {
    static let reusableIdentifier = "ReportTableViewFirstCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var seporatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.titleLabel.snp_makeConstraints{ make in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(20)
            make.width.equalTo(self).multipliedBy(0.4)
        }
        
        self.textField.snp_makeConstraints { make in
            make.centerY.equalTo(self)
            make.right.equalTo(self).inset(20)
            make.width.equalTo(self).multipliedBy(0.6)
        }
        
        self.seporatorView.snp_makeConstraints { make in
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).inset(20)
            make.bottom.equalTo(self)
        }
    }
}