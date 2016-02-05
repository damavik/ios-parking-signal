//
//  BaseTests.swift
//  Parking
//
//  Created by Vital Vinahradau on 11/20/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import XCTest

class MockAppDelegate: NSObject, UIApplicationDelegate {
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }
}

class BaseTests: XCTestCase {
    override func setUp() {
        super.setUp()
        UIApplication.sharedApplication().delegate = MockAppDelegate()
    }
}

