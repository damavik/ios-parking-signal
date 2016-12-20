//
//  DisclaimerViewController.swift
//  Parking
//
//  Created by Vital Vinahradau on 12/27/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import UIKit

class DisclaimerViewController: SignalViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var continueButton: UIButton!
    
    override var brandedNavigationBar: Bool { get { return false } }
    
    override func updateViewConstraints() {
        if (!self.didSetupConstraints) {
            self.continueButton.snp.makeConstraints { make in
                make.width.equalTo(self.view)
                make.height.equalTo(62)
                
                make.centerX.equalTo(self.view)
                make.bottom.equalTo(self.view)
            }
            
            self.textView.snp.makeConstraints { make in
                make.left.equalTo(self.view).offset(15)
                make.right.equalTo(self.view).inset(15)
                
                make.top.equalTo(self.view)
                make.bottom.equalTo(self.continueButton.snp.top)
            }
        }
        
        super.updateViewConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Обратите внимание".uppercased()
    }
    
    //  MARK: Actions
    
    @IBAction func onContinue(_ sender: AnyObject) {
        Log("Continue after disclaimer")
        
        // TODO
    }
}
