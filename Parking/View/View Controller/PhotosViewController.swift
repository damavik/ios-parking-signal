//
//  PhotosViewController.swift
//  Parking
//
//  Created by Vital Vinahradau on 6/18/15.
//  Copyright (c) 2015 Vital Vinahradau. All rights reserved.
//

import UIKit
import Photos

class PhotosViewController: UICollectionViewController {
    
    private lazy var photoService: PhotoStorageService = ServiceFactory.photoStorageService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.allowsSelection = true
        self.collectionView!.allowsMultipleSelection = true
        
        // Do any additional setup after loading the view.
        self.collectionView!.reloadData()
        
        if (self.photoService.fetchResult.count > 0) {
            self.collectionView!.scrollToItemAtIndexPath(NSIndexPath(forItem: self.photoService.fetchResult.count - 1, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.Right, animated: false)
        }
    }
    
    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photoService.fetchResult.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoCollectionViewCell.reusableIdentifier, forIndexPath: indexPath) as! PhotoCollectionViewCell
        
        self.photoService.fetchResult[indexPath.row].fetchImage(cell.bounds.size) { result in
            cell.imageView?.image = result
        }
        
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        ReportViewModel.instance.imageIndexes.append(indexPath.row)
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        ReportViewModel.instance.imageIndexes = ReportViewModel.instance.imageIndexes.filter() { $0 != indexPath.row }
    }
}
