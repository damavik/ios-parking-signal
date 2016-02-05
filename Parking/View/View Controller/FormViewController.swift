//
//  PhotosPickerViewController.swift
//  Parking
//
//  Created by Vital Vinahradau on 7/2/15.
//  Copyright (c) 2015 Vital Vinahradau. All rights reserved.
//

import UIKit

class PhotosPickerViewController: SignalViewController {
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var grantAccessButton: UIButton!
    @IBOutlet weak var photosView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    private lazy var photoStorageService: PhotoStorageService = ServiceFactory.photoStorageService()
    
    override func updateViewConstraints() {
        if (!self.didSetupConstraints) {
            self.continueButton.snp_makeConstraints { make in
                make.width.equalTo(self.view)
                make.height.equalTo(62)
                
                make.centerX.equalTo(self.view)
                make.bottom.equalTo(self.view)
            }
            
            self.messageLabel.snp_makeConstraints { make in
                make.height.equalTo(80)
                make.left.equalTo(self.view).offset(27)
                make.right.equalTo(self.view).inset(27)
                
                make.bottom.equalTo(self.continueButton.snp_top).inset(10)
            }
            
            self.grantAccessButton.snp_makeConstraints { make in
                make.height.equalTo(self.continueButton)
                make.width.equalTo(self.view)
                make.center.equalTo(self.photosView)
            }
            
            self.photosView.snp_makeConstraints { make in
                make.width.equalTo(self.view)
                make.height.equalTo(298)
                
                make.centerX.equalTo(self.view)
                make.centerY.equalTo(self.view).offset(-CGRectGetHeight(self.continueButton.frame))
            }
        }
        super.updateViewConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let gradientLayer = CAGradientLayer(firstHex: "#213F64", secondHex: "#144466", direction: .DirectionVertical) {
            gradientLayer.frame = self.view.bounds
            self.view.layer.insertSublayer(gradientLayer, atIndex: 0)
        }
        
        self.grantAccessButton.setTitle("Разрешить доступ к фото", forState: UIControlState.Normal)
        
        self.photoStorageService.accessStatusChangeCallback = { [weak self] (accessStatus: PhotoStorageServiceAccessStatus) -> Void  in
            if (self == nil) {
                return
            }
            
            self!.grantAccessButton.hidden = (accessStatus == PhotoStorageServiceAccessStatus.Authorized)
            self!.photosView.hidden = !(self!.grantAccessButton.hidden)
        }
    }
        
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if (identifier == "ShowReportForm") {
            if (self.viewModel.imageIndexes.isEmpty) {
                
                dispatch_async(dispatch_get_main_queue(), { [weak self] in
                    Log("Attempt to create report without any image selected")
                    self?.showFailureMark("Не выбрано фото")
                })
                
                return false
            }
        }
        
        return true
    }
    
    //  MARK: Actions
    
    @IBAction func onGrantAccess(sender: AnyObject) {
        Log("Gallery access granting initiated")
        self.photoStorageService.grantAccess()
    }
}
