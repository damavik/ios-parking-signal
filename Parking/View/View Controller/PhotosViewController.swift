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
    
    fileprivate lazy var photoService: PhotoStorageService = ServiceFactory.photoStorageService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.allowsSelection = true
        self.collectionView!.allowsMultipleSelection = true
        
        // Do any additional setup after loading the view.
        self.collectionView!.reloadData()
        
        if (self.photoService.fetchResult.count > 0) {
            self.collectionView!.scrollToItem(at: IndexPath(item: self.photoService.fetchResult.count - 1, section: 0), at: UICollectionViewScrollPosition.right, animated: false)
        }
    }
    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photoService.fetchResult.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reusableIdentifier, for: indexPath) as! PhotoCollectionViewCell
        
        self.photoService.fetchResult[indexPath.row].fetchImage(cell.bounds.size) { result in
            cell.imageView?.image = result
        }
        
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        ReportViewModel.instance.imageIndexes.append(indexPath.row)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        ReportViewModel.instance.imageIndexes = ReportViewModel.instance.imageIndexes.filter() { $0 != indexPath.row }
    }
}
