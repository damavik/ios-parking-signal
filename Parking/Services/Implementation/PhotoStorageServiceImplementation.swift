//
//  PhotoStorageServiceImplementation.swift
//  Parking
//
//  Created by Vital Vinahradau on 12/23/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import UIKit
import Photos

private class PhotoResultImplementation: PhotoResult, Disposable {
    fileprivate let asset: PHAsset
    fileprivate let imageManager = PHImageManager.default()
    fileprivate var requestId: PHImageRequestID?
    
    init(asset: PHAsset) {
        self.asset = asset
    }
    
    //  MARK: PhotoResult
    
    @discardableResult func fetchImage(_ targetSize: CGSize, callback: @escaping (UIImage?) -> Void) -> Disposable? {
        Log("Photo libraray image fetch requested for size '%@'", NSStringFromCGSize(targetSize))
        
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.version = .current
        options.deliveryMode = .opportunistic
        options.resizeMode = .none
        options.isNetworkAccessAllowed = true
        
        self.requestId = self.imageManager.requestImage(for: self.asset, targetSize: targetSize, contentMode: PHImageContentMode.aspectFill, options: options, resultHandler: { result, _ in
            Log("Photo library image request for asset with target size '%@' completed", NSStringFromCGSize(targetSize))
            callback(result)
        })
        
        return self
    }
    
    //  MARK: Disposable
    
    func dispose() {
        if let imageRequestId = self.requestId {
            Log("Photo libraray image request cancellation requested")
            self.imageManager.cancelImageRequest(imageRequestId)
        } else {
            Log("Photo libraray image request cancellation requested for nil id")
        }
    }
}

class PhotoStorageServiceImplementation: NSObject, PhotoStorageService {
    fileprivate var lastPhotoCallback: (CGSize, (UIImage?) -> Void)?
    
    fileprivate var authorizationStatus = PHPhotoLibrary.authorizationStatus() {
        didSet {
            guard let callbackInfo = self.lastPhotoCallback else {
                return
            }
            
            switch self.authorizationStatus {
            case .authorized:
                guard let lastAsset = self.photoFetchResult.firstObject as? PHAsset else {
                    callbackInfo.1(nil)
                    return
                }
                
                PhotoResultImplementation(asset: lastAsset).fetchImage(callbackInfo.0, callback: callbackInfo.1)
                
                self.lastPhotoCallback = nil
                
            case .denied, .restricted:
                callbackInfo.1(nil)
                
                self.lastPhotoCallback = nil
                
            default:
                break
            }
        }
    }
    
    fileprivate var photoFetchResult: PHFetchResult<AnyObject> {
        get {
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [ NSSortDescriptor(key: "creationDate", ascending: false) ]
            return PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions) as! PHFetchResult<AnyObject>
        }
    }
    
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationDidBecomeActive, object: nil, queue: OperationQueue.main) { [weak self] (_) in
            
            if (self == nil) {
                return
            }
            
            self!.authorizationStatus = PHPhotoLibrary.authorizationStatus()
            
            if (self!.accessStatusChangeCallback == nil) {
                return
            }
            
            self!.accessStatusChangeCallback!(self!.accessStatus)
        }
        
        if (self.authorizationStatus == .notDetermined) {
            Log("Photo libraray authorization status not determined")
            self.requestAccessGranting(nil)
        }
    }
    
    fileprivate func requestAccessGranting(_ completion: ((Void) -> Void)?) {
        PHPhotoLibrary.requestAuthorization { status in
            self.authorizationStatus = status
            
            if (completion == nil) {
                return
            }
            
            completion!()
        }
    }
    
    //  MARK: PhotoStorageService
    
    var fetchResult: [PhotoResult] {
        get {
            Log("Photo libraray fetch results array requested")
            
            var result = Array<PhotoResult>()
            
            let fetchResultValue = self.photoFetchResult
            
            for index in 0..<fetchResultValue.count {
                let asset = fetchResultValue.object(at: index) as! PHAsset
                result.append(PhotoResultImplementation(asset: asset))
            }
            
            return result
        }
    }
    
    var accessStatus: PhotoStorageServiceAccessStatus {
        get {
            switch self.authorizationStatus {
            case PHAuthorizationStatus.authorized:
                return PhotoStorageServiceAccessStatus.authorized
                
            default:
                return PhotoStorageServiceAccessStatus.forbidden
            }
        }
    }
    
    var accessStatusChangeCallback: ((PhotoStorageServiceAccessStatus) -> Void)? {
        didSet {
            if (self.accessStatusChangeCallback == nil) {
                return
            }
            
            self.accessStatusChangeCallback!(self.accessStatus)
        }
    }
    
    func grantAccess() {
        if (self.accessStatus == PhotoStorageServiceAccessStatus.authorized) {
            return
        }
        
        UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
    }
    
    func fetchLastPhoto(_ targetSize: CGSize, callback: @escaping (UIImage?) -> Void) -> Disposable? {
        if self.authorizationStatus == .notDetermined {
            Log("Photo libraray last photo requested with not determined authorization status")
            
            self.lastPhotoCallback = (targetSize, callback)
            return nil
        }
        
        Log("Photo libraray last photo requested")
        
        guard let lastAsset = self.photoFetchResult.firstObject as? PHAsset else {
            Log("Photo libraray failed to get last asset")
            callback(nil)
            return nil
        }
        
        return PhotoResultImplementation(asset: lastAsset).fetchImage(targetSize, callback: callback)
    }
}
