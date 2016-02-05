//
//  ReportTableViewCellFirst.swift
//  Parking
//
//  Created by Vital Vinahradau on 12/25/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import UIKit

class ReportTableViewSecondCell: UITableViewCell {
    static let reusableIdentifier = "ReportTableViewSecondCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var seporatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.titleLabel.snp_makeConstraints{ make in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(20)
            make.width.equalTo(self).multipliedBy(0.4)
        }
        
        self.valueLabel.snp_makeConstraints { make in
            make.centerY.equalTo(self)
            make.right.equalTo(self).inset(20)
            make.width.equalTo(self).multipliedBy(0.6)
        }
        
        self.seporatorView.snp_makeConstraints { make in
            make.bottom.equalTo(self)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).inset(20)
        }
    }
}