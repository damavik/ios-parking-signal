//
//  StartViewController.swift
//  Parking
//
//  Created by Vital Vinahradau on 6/17/15.
//  Copyright (c) 2015 Vital Vinahradau. All rights reserved.
//

import UIKit
import AVFoundation
import SnapKit

class StartViewController: SignalViewController {

    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var shootButton: UIButton!
    @IBOutlet weak var lastPhotoButton: UIButton!
    
    fileprivate lazy var photoStorageService: PhotoStorageService = ServiceFactory.photoStorageService()
    fileprivate lazy var photoCaptureService: PhotoCaptureService = ServiceFactory.photoCaptureService()

    fileprivate var previewLayer : AVCaptureVideoPreviewLayer!
    
    override func updateViewConstraints() {
        if (!self.didSetupConstraints) {
            self.bottomView.snp.makeConstraints { make in
                make.height.equalTo(90)
                make.width.equalTo(self.view)
                make.centerX.equalTo(self.view)
                make.bottom.equalTo(self.view)
            }
            
            self.flashButton.snp.makeConstraints { make in
                make.size.equalTo(60)
                make.centerY.equalTo(self.bottomView)
                make.left.equalTo(self.bottomView).offset(30)
            }
            
            self.shootButton.snp.makeConstraints { make in
                make.size.equalTo(80)
                make.center.equalTo(self.bottomView)
            }
            
            self.lastPhotoButton.snp.makeConstraints { make in
                make.size.equalTo(60)
                make.centerY.equalTo(self.bottomView)
                make.right.equalTo(self.bottomView).inset(30)
            }
        }
        
        super.updateViewConstraints()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.flashButton.backgroundColor = UIColor.clear
        self.updateCameraFlashButton()
        
        self.lastPhotoButton.backgroundColor = UIColor.clear
        
        self.photoStorageService.accessStatusChangeCallback = { [weak self] (accessStatus: PhotoStorageServiceAccessStatus) -> Void  in
            if (self == nil) {
                return
            }
            
            self!.updateLastPhotoButton()
        }
        
        guard let captureSession = self.photoCaptureService.session else {
            Log("Failed to initialize photo capture session")
            return
        }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)!
        
        let bounds = self.view.layer.bounds
        
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.previewLayer.bounds = bounds
        self.previewLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        
        self.view.layer.insertSublayer(self.previewLayer, at: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ReportViewModel.instance.reset()
    }

    override func viewDidLayoutSubviews() {
        self.lastPhotoButton.imageView!.clipsToBounds = true
        self.lastPhotoButton.imageView!.layer.borderWidth = 0
    }
    
    fileprivate func updateCameraFlashButton() {
        self.flashButton.isHidden = !self.photoCaptureService.flashAvailable
        
        if (!self.flashButton.isHidden) {
            if (self.photoCaptureService.flashEnabled) {
                let image = UIImage(named: "camera-flash")
                self.flashButton.setImage(image, for: UIControlState())
            } else {
                let image = UIImage(named: "camera-flash")?.tint(UIColor.gray)
                self.flashButton.setImage(image, for: UIControlState())
            }
        }
    }
    
    fileprivate func updateLastPhotoButton() {
        self.photoStorageService.fetchLastPhoto(CGSize(width: 100, height: 100), callback: { [unowned self] image in
            DispatchQueue.main.async(execute: {
                self.lastPhotoButton.setImage(image, for: UIControlState())
                self.lastPhotoButton.imageView!.layer.cornerRadius = self.lastPhotoButton.imageView!.frame.height / 2
                
                if (image == nil) {
                    self.lastPhotoButton.setTitle("Продолжить", for: UIControlState())
                }
            })
        })
    }
    
    //  MARK: Actions
    
    @IBAction func onShoot(_ sender: AnyObject) {
        Log("Photo capture initiated")
        
        self.photoCaptureService.capturePhoto { error -> Void in
            if let errorValue = error {
                Log("Photo capture failed with error %@", errorValue)
            } else {
                self.updateLastPhotoButton()
            }
        }
    }
    
    @IBAction func onToggleFlash(_ sender: AnyObject) {
        Log("Flash toggle initiated with original value %d", self.photoCaptureService.flashEnabled as CVarArg)
        
        self.photoCaptureService.flashEnabled = !self.photoCaptureService.flashEnabled
        self.updateCameraFlashButton()
        
        Log("Flash toggle completed with final value %d", self.photoCaptureService.flashEnabled as CVarArg)
    }
}

