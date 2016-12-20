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
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                self.selectionMark.image = UIImage(named: "selection-mark")
            } else {
                self.selectionMark.image = nil
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.snp.makeConstraints { make in
            make.height.equalTo(self.valueLabel).offset(20)
        }
        
        self.selectionMark.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 20.0, height: 15.0))
            make.top.equalTo(self).offset(10)
            make.left.equalTo(self).offset(20)
        }
        
        self.valueLabel.snp.makeConstraints { make in
            make.left.equalTo(self.selectionMark.snp.right).offset(10)
            make.right.equalTo(self).inset(20)
            make.top.equalTo(self.selectionMark)
            make.bottom.equalTo(self).inset(10)
        }
    }
}
