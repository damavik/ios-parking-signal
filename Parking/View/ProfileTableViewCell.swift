//
//  ProfileTableViewCell.swift
//  Parking
//
//  Created by Vital Vinahradau on 12/29/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    static let reusableIdentifier = "ProfileTableViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.titleLabel.snp_makeConstraints { make in
            make.height.equalTo(self).multipliedBy(0.5)
            make.left.equalTo(16)
            make.right.equalTo(16)
            make.top.equalTo(self)
        }
        
        self.textField.snp_makeConstraints { make in
            make.height.equalTo(self).multipliedBy(0.5)
            make.left.equalTo(16)
            make.right.equalTo(16)
            make.bottom.equalTo(self)
        }
    }
}
