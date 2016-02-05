//
//  PhotoCollectionViewCell.swift
//  Parking
//
//  Created by Vital Vinahradau on 6/18/15.
//  Copyright (c) 2015 Vital Vinahradau. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    static let reusableIdentifier = "PhotoCollectionViewCell"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectionMark: UIImageView!
    
    override var selected: Bool {
        didSet {
            if self.selected {
                self.selectionMark.image = UIImage(named: "checked-mark")
            } else {
                self.selectionMark.image = UIImage(named: "unchecked-mark")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clearColor()
        
        let imageViewInset: CGFloat = 4.0
        
        self.imageView.snp_makeConstraints { make in
            make.edges.equalTo(self).inset(imageViewInset)
        }
        
        self.imageView.layer.cornerRadius = imageViewInset
        self.imageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.imageView.clipsToBounds = true
        
        self.selectionMark.snp_makeConstraints { make in
            make.size.equalTo(40)
            make.right.equalTo(self).inset(15)
            make.bottom.equalTo(self).inset(15)
        }
        
        contentView.layer.shadowColor = UIColor.blackColor().CGColor
        contentView.layer.shadowOffset = CGSizeMake(0, 1)
        contentView.layer.shadowOpacity = 1
        contentView.layer.shadowRadius = imageViewInset
        contentView.layer.shouldRasterize = true
        contentView.clipsToBounds = false
    }
}