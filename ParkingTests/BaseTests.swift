//
//  BaseTests.swift
//  Parking
//
//  Created by Vital Vinahradau on 11/20/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import XCTest

class MockAppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }
}

class BaseTests: XCTestCase {
    override func setUp() {
        super.setUp()
        UIApplication.shared.delegate = MockAppDelegate()
    }
}

