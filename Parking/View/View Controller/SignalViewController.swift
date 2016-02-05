//
//  File.swift
//  Parking
//
//  Created by Vital Vinahradau on 12/11/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import UIKit
import UINavigationBar_Addition
import MRProgress

class SignalViewController: UIViewController {
    lazy var viewModel = ReportViewModel.instance
    var brandedNavigationBar: Bool { get { return true } }
    var didSetupConstraints = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (self.brandedNavigationBar) {
            self.navigationItem.titleView = UIImageView(image: UIImage(named: "logo"))
        } else {
            self.navigationItem.titleView = nil
        }
        
        self.view.setNeedsUpdateConstraints()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if (self.brandedNavigationBar) {
            var navigationBarFrame: CGRect! = self.navigationController?.navigationBar.frame
            navigationBarFrame?.origin.y = 30
            self.navigationController?.navigationBar.frame = navigationBarFrame
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if (self.brandedNavigationBar) {
            
            if let navigationController = self.navigationController {
                navigationController.navigationBar.makeTransparent()
                navigationController.navigationBar.tintColor = UIColor.whiteColor()
            }
            
            UIApplication.sharedApplication().statusBarStyle = .LightContent
        } else {
            
            if let navigationController = self.navigationController {
                navigationController.navigationBar.makeDefault()
                navigationController.navigationBar.translucent = false
                navigationController.navigationBar.tintColor = UIColor.blackColor()
                navigationController.navigationBar.barTintColor = UIColor.whiteColor()
            }
            
            UIApplication.sharedApplication().statusBarStyle = .Default
        }
    }
    
    override func updateViewConstraints() {
        self.didSetupConstraints = true
        super.updateViewConstraints()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if let segueId = segue.identifier {
            Log("Prepare for seque '%@'", segueId)
        }
    }
    
    private func perform(block: Void -> Void, delay: NSTimeInterval) {
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        dispatch_after(popTime, dispatch_get_main_queue(), block)
    }
    
    func showSuccessMark(message: String?) {
        let progressView = MRProgressOverlayView.showOverlayAddedTo(self.view.window, animated: true)
        progressView.mode = .Checkmark
        progressView.titleLabelText = message ?? "Завершено"
        
        if (progressView.accessibilityLabel == nil) {
            progressView.accessibilityLabel = progressView.titleLabelText
        }
        
        self.perform({ progressView.hide(true) }, delay: 1.5)
    }
    
    func showFailureMark(message: String?) {
        let progressView = MRProgressOverlayView.showOverlayAddedTo(self.view.window, animated: true)
        progressView.mode = .Cross
        progressView.titleLabelText = message ?? "Произошла ошибка"
        
        if (progressView.accessibilityLabel == nil) {
            progressView.accessibilityLabel = progressView.titleLabelText
        }
        
        self.perform({ progressView.hide(true) }, delay: 1.5)
    }
}
