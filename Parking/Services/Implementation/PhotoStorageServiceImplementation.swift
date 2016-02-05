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
    private let asset: PHAsset
    private let imageManager = PHImageManager.defaultManager()
    private var requestId: PHImageRequestID?
    
    init(asset: PHAsset) {
        self.asset = asset
    }
    
    //  MARK: PhotoResult
    
    func fetchImage(targetSize: CGSize, callback: UIImage? -> Void) -> Disposable? {
        Log("Photo libraray image fetch requested for size '%@'", NSStringFromCGSize(targetSize))
        
        let options = PHImageRequestOptions()
        options.synchronous = false
        options.version = .Current
        options.deliveryMode = .Opportunistic
        options.resizeMode = .None
        options.networkAccessAllowed = true
        
        self.requestId = self.imageManager.requestImageForAsset(self.asset, targetSize: targetSize, contentMode: PHImageContentMode.AspectFill, options: options, resultHandler: { result, _ in
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
    private var lastPhotoCallback: (CGSize, UIImage? -> Void)?
    
    private var authorizationStatus = PHPhotoLibrary.authorizationStatus() {
        didSet {
            guard let callbackInfo = self.lastPhotoCallback else {
                return
            }
            
            switch self.authorizationStatus {
            case .Authorized:
                guard let lastAsset = self.photoFetchResult.firstObject as? PHAsset else {
                    callbackInfo.1(nil)
                    return
                }
                
                PhotoResultImplementation(asset: lastAsset).fetchImage(callbackInfo.0, callback: callbackInfo.1)
                
                self.lastPhotoCallback = nil
                
            case .Denied, .Restricted:
                callbackInfo.1(nil)
                
                self.lastPhotoCallback = nil
                
            default:
                break
            }
        }
    }
    
    private var photoFetchResult: PHFetchResult {
        get {
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [ NSSortDescriptor(key: "creationDate", ascending: false) ]
            return PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: fetchOptions)
        }
    }
    
    override init() {
        super.init()
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationDidBecomeActiveNotification, object: nil, queue: NSOperationQueue.mainQueue()) { [weak self] (_) in
            
            if (self == nil) {
                return
            }
            
            self!.authorizationStatus = PHPhotoLibrary.authorizationStatus()
            
            if (self!.accessStatusChangeCallback == nil) {
                return
            }
            
            self!.accessStatusChangeCallback!(self!.accessStatus)
        }
        
        if (self.authorizationStatus == .NotDetermined) {
            Log("Photo libraray authorization status not determined")
            self.requestAccessGranting(nil)
        }
    }
    
    private func requestAccessGranting(completion: (Void -> Void)?) {
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
                let asset = fetchResultValue.objectAtIndex(index) as! PHAsset
                result.append(PhotoResultImplementation(asset: asset))
            }
            
            return result
        }
    }
    
    var accessStatus: PhotoStorageServiceAccessStatus {
        get {
            switch self.authorizationStatus {
            case PHAuthorizationStatus.Authorized:
                return PhotoStorageServiceAccessStatus.Authorized
                
            default:
                return PhotoStorageServiceAccessStatus.Forbidden
            }
        }
    }
    
    var accessStatusChangeCallback: (PhotoStorageServiceAccessStatus -> Void)? {
        didSet {
            if (self.accessStatusChangeCallback == nil) {
                return
            }
            
            self.accessStatusChangeCallback!(self.accessStatus)
        }
    }
    
    func grantAccess() {
        if (self.accessStatus == PhotoStorageServiceAccessStatus.Authorized) {
            return
        }
        
        UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
    }
    
    func fetchLastPhoto(targetSize: CGSize, callback: UIImage? -> Void) -> Disposable? {
        if self.authorizationStatus == .NotDetermined {
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
