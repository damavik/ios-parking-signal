//
//  OffenseTableViewCell.swift
//  Parking
//
//  Created by Vital Vinahradau on 12/27/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import UIKit

class OffenseTableViewCell: UITableViewCell {
    static let reusableIdentifier = "OffenseTableViewCell"
    
    @IBOutlet weak var selectionMark: UIImageView!
    @IBOutlet weak var valueLabel: UILabel!
    
    override var selected: Bool {
        didSet {
            if self.selected {
                self.selectionMark.image = UIImage(named: "selection-mark")
            } else {
                self.selectionMark.image = nil
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.snp_makeConstraints { make in
            make.height.equalTo(self.valueLabel).offset(20)
        }
        
        self.selectionMark.snp_makeConstraints { make in
            make.size.equalTo(CGSizeMake(20, 15))
            make.top.equalTo(self).offset(10)
            make.left.equalTo(self).offset(20)
        }
        
        self.valueLabel.snp_makeConstraints { make in
            make.left.equalTo(self.selectionMark.snp_right).offset(10)
            make.right.equalTo(self).inset(20)
            make.top.equalTo(self.selectionMark)
            make.bottom.equalTo(self).inset(10)
        }
    }
}