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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (self.brandedNavigationBar) {
            
            if let navigationController = self.navigationController {
                navigationController.navigationBar.makeTransparent()
                navigationController.navigationBar.tintColor = UIColor.white
            }
            
            UIApplication.shared.statusBarStyle = .lightContent
        } else {
            
            if let navigationController = self.navigationController {
                navigationController.navigationBar.makeDefault()
                navigationController.navigationBar.isTranslucent = false
                navigationController.navigationBar.tintColor = UIColor.black
                navigationController.navigationBar.barTintColor = UIColor.white
            }
            
            UIApplication.shared.statusBarStyle = .default
        }
    }
    
    override func updateViewConstraints() {
        self.didSetupConstraints = true
        super.updateViewConstraints()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let segueId = segue.identifier {
            Log("Prepare for seque '%@'", segueId)
        }
    }
    
    fileprivate func perform(_ block: @escaping (Void) -> Void, delay: TimeInterval) {
        let popTime = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: popTime, execute: block)
    }
    
    func showSuccessMark(_ message: String?) {
        let progressView = MRProgressOverlayView.showOverlayAdded(to: self.view.window, animated: true)
        progressView?.mode = .checkmark
        progressView?.titleLabelText = message ?? "Завершено"
        
        if (progressView?.accessibilityLabel == nil) {
            progressView?.accessibilityLabel = progressView?.titleLabelText
        }
        
        self.perform({ progressView?.hide(true) }, delay: 1.5)
    }
    
    func showFailureMark(_ message: String?) {
        let progressView = MRProgressOverlayView.showOverlayAdded(to: self.view.window, animated: true)
        progressView?.mode = .cross
        progressView?.titleLabelText = message ?? "Произошла ошибка"
        
        if (progressView?.accessibilityLabel == nil) {
            progressView?.accessibilityLabel = progressView?.titleLabelText
        }
        
        self.perform({ progressView?.hide(true) }, delay: 1.5)
    }
}
