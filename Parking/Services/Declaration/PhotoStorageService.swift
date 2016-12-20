//
//  PhotoStorageService.swift
//  Parking
//
//  Created by Vital Vinahradau on 7/2/15.
//  Copyright (c) 2015 Vital Vinahradau. All rights reserved.
//

import UIKit

enum PhotoStorageServiceAccessStatus: Int {
    case forbidden
    case authorized
}

protocol PhotoResult {
    @discardableResult func fetchImage(_ targetSize: CGSize, callback: @escaping (UIImage?) -> Void) -> Disposable?
}

protocol PhotoStorageService {
    var fetchResult: [PhotoResult] { get }
    var accessStatus: PhotoStorageServiceAccessStatus { get }
    var accessStatusChangeCallback: ((PhotoStorageServiceAccessStatus) -> Void)? { get set }
    func grantAccess()
    @discardableResult func fetchLastPhoto(_ targetSize: CGSize, callback: @escaping (UIImage?) -> Void) -> Disposable?
}
