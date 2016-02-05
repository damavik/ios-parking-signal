//
//  ParkingUITests.swift
//  ParkingUITests
//
//  Created by Vital Vinahradau on 1/3/16.
//  Copyright © 2016 Signal. All rights reserved.
//

import KIF
@testable import Parking

class ParkingUITests: KIFTestCase {
    
    override func beforeAll() {
        let accessibilityLabel = "OK"
        
        if let _ = UIApplication.sharedApplication().accessibilityElementWithLabel(accessibilityLabel, accessibilityValue: nil, traits: UIAccessibilityTraitButton) {
            tester().tapViewWithAccessibilityLabel(accessibilityLabel, traits: UIAccessibilityTraitButton)
        }
    }
    
    override func afterEach() {
        if let window = UIApplication.sharedApplication().keyWindow {
            if let navigationController = window.rootViewController as? UINavigationController {
                navigationController.popToRootViewControllerAnimated(false)
            }
        }
    }
    
    func testNoPhotoSelected() {
        self.tapButton(ButtonAccessibilityLabel.GalleryButton)
        self.tapButton(ButtonAccessibilityLabel.ContinueButton)
        tester().waitForViewWithAccessibilityLabel("Не выбрано фото")
    }
    
    func testPhotosSelectionReset() {
        self.tapButton(ButtonAccessibilityLabel.GalleryButton)
        
        self.tapCollectionViewCell(0, collectionIdentifier: CollectionAccessibilityIdentifier.PhotosCollection)
        self.tapCollectionViewCell(1, collectionIdentifier: CollectionAccessibilityIdentifier.PhotosCollection)
        self.tapCollectionViewCell(2, collectionIdentifier: CollectionAccessibilityIdentifier.PhotosCollection)
        
        XCTAssertEqual(ReportViewModel.instance.imageIndexes, [ 0, 1, 2 ])
        
        if let window = UIApplication.sharedApplication().keyWindow {
            if let navigationController = window.rootViewController as? UINavigationController {
                navigationController.popViewControllerAnimated(true)
            }
        }
        
        self.tapButton(ButtonAccessibilityLabel.GalleryButton)
        
        let collectionView = tester().waitForViewWithAccessibilityLabel(CollectionAccessibilityIdentifier.PhotosCollection.rawValue) as!UICollectionView
        
        let selectedItems = collectionView.indexPathsForSelectedItems()
        XCTAssertTrue(selectedItems == nil || selectedItems!.isEmpty)
        
        XCTAssertTrue(ReportViewModel.instance.imageIndexes.isEmpty)
    }
    
    func testEmptyLicensePlate() {
        self.tapButton(ButtonAccessibilityLabel.GalleryButton)
        
        self.tapCollectionViewCell(0, collectionIdentifier: CollectionAccessibilityIdentifier.PhotosCollection)
        self.tapCollectionViewCell(1, collectionIdentifier: CollectionAccessibilityIdentifier.PhotosCollection)
        
        self.tapButton(ButtonAccessibilityLabel.ContinueButton)
        self.tapButton(ButtonAccessibilityLabel.SendButton)
        
        tester().waitForViewWithAccessibilityLabel("Не указан номер")
    }
    
    func testEmptyAddress() {
        self.enterLicensePlate()
        
        self.tapButton(ButtonAccessibilityLabel.SendButton)
        tester().waitForViewWithAccessibilityLabel("Не указан адрес")
    }
    
    func testNotSelectedOffense() {
        self.enterLicensePlate()
        
        let tableView = tester().waitForViewWithAccessibilityLabel(TableAccessibilityIdentifier.ReportTable.rawValue) as! UITableView
        
        let addressCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as! ReportTableViewFirstCell
        addressCell.textField.becomeFirstResponder()
        
        tester().enterTextIntoCurrentFirstResponder("ул. Ангарская, 23")
        
        self.tapButton(ButtonAccessibilityLabel.SendButton)
        tester().waitForViewWithAccessibilityLabel("Не указана статья")
    }
    
    func testFilledForm() {
        self.enterLicensePlate()
        
        let tableView = tester().waitForViewWithAccessibilityLabel(TableAccessibilityIdentifier.ReportTable.rawValue) as! UITableView
        
        let addressCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as! ReportTableViewFirstCell
        addressCell.textField.becomeFirstResponder()
        tester().enterTextIntoCurrentFirstResponder("ул. Ангарская, 23")
        
        self.tapTableViewCell(3, tableIdentifier: TableAccessibilityIdentifier.ReportTable)
        
        tester().waitForViewWithAccessibilityLabel(TableAccessibilityIdentifier.OffensesTable.rawValue)
        
        self.tapTableViewCell(2, tableIdentifier: TableAccessibilityIdentifier.OffensesTable)
        self.tapButton(ButtonAccessibilityLabel.ChooseButton)
        
        self.tapButton(ButtonAccessibilityLabel.SendButton)
        
        tester().waitForAbsenceOfViewWithAccessibilityLabel("Не указан номер")
        tester().waitForAbsenceOfViewWithAccessibilityLabel("Не указан адрес")
        tester().waitForAbsenceOfViewWithAccessibilityLabel("Не указана статья")
        
        tester().waitForViewWithAccessibilityLabel("ОБРАТИТЕ ВНИМАНИЕ", traits: UIAccessibilityTraitStaticText)
        
        self.dismissPopover()
    }
}

// MARK: Accessibility labels & identifiers

private extension ParkingUITests {
    enum ButtonAccessibilityLabel: String {
        case OkButton = "OK"
        case CancelButton = "Cancel"
        case DoNotAllowButton = "Don't allow"
        case FlashButton = "Flash button"
        case ShootButton = "Shoot button"
        case GalleryButton = "Gallery button"
        case ContinueButton = "Continue button"
        case ChooseButton = "Choose button"
        case SendButton = "Send button"
    }
    
    enum CollectionAccessibilityIdentifier: String {
        case PhotosCollection = "Photos collection"
    }
    
    enum TableAccessibilityIdentifier: String {
        case ReportTable = "Report form table"
        case OffensesTable = "Offenses table"
    }
    
    private func dismissPopover() {
        tester().tapScreenAtPoint(CGPointMake(1, 1))
    }
    
    private func tapButton(label: ButtonAccessibilityLabel) {
        tester().tapViewWithAccessibilityLabel(label.rawValue, traits: UIAccessibilityTraitButton)
    }
    
    private func tapCollectionViewCell(index: Int, collectionIdentifier: CollectionAccessibilityIdentifier) {
        tester().tapItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0), inCollectionViewWithAccessibilityIdentifier: collectionIdentifier.rawValue)
    }
    
    private func tapTableViewCell(index: Int, tableIdentifier: TableAccessibilityIdentifier) {
        tester().tapRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0), inTableViewWithAccessibilityIdentifier: tableIdentifier.rawValue)
    }
    
    private func enterLicensePlate() {
        self.tapButton(ButtonAccessibilityLabel.GalleryButton)
        
        self.tapCollectionViewCell(0, collectionIdentifier: CollectionAccessibilityIdentifier.PhotosCollection)
        self.tapCollectionViewCell(1, collectionIdentifier: CollectionAccessibilityIdentifier.PhotosCollection)
        
        self.tapButton(ButtonAccessibilityLabel.ContinueButton)
        
        let tableView = tester().waitForViewWithAccessibilityLabel(TableAccessibilityIdentifier.ReportTable.rawValue) as! UITableView
        
        let licensePlateCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! ReportTableViewFirstCell
        licensePlateCell.textField.becomeFirstResponder()
        
        tester().enterTextIntoCurrentFirstResponder("1111 ОР-7")
    }
}