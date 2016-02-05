//
//  PhotoStorageService.swift
//  Parking
//
//  Created by Vital Vinahradau on 7/2/15.
//  Copyright (c) 2015 Vital Vinahradau. All rights reserved.
//

import UIKit

enum PhotoStorageServiceAccessStatus: Int {
    case Forbidden
    case Authorized
}

protocol PhotoResult {
    func fetchImage(targetSize: CGSize, callback: UIImage? -> Void) -> Disposable?
}

protocol PhotoStorageService {
    var fetchResult: [PhotoResult] { get }
    var accessStatus: PhotoStorageServiceAccessStatus { get }
    var accessStatusChangeCallback: (PhotoStorageServiceAccessStatus -> Void)? { get set }
    func grantAccess()
    func fetchLastPhoto(targetSize: CGSize, callback: UIImage? -> Void) -> Disposable?
}