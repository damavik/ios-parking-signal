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
        
        if let _ = UIApplication.shared.accessibilityElement(withLabel: accessibilityLabel, accessibilityValue: nil, traits: UIAccessibilityTraitButton) {
            tester().tapView(withAccessibilityLabel: accessibilityLabel, traits: UIAccessibilityTraitButton)
        }
    }
    
    override func afterEach() {
        if let window = UIApplication.shared.keyWindow {
            if let navigationController = window.rootViewController as? UINavigationController {
                navigationController.popToRootViewController(animated: false)
            }
        }
    }
    
    func testNoPhotoSelected() {
        self.tapButton(ButtonAccessibilityLabel.GalleryButton)
        self.tapButton(ButtonAccessibilityLabel.ContinueButton)
        tester().waitForView(withAccessibilityLabel: "Не выбрано фото")
    }
    
    func testPhotosSelectionReset() {
        self.tapButton(ButtonAccessibilityLabel.GalleryButton)
        
        self.tapCollectionViewCell(0, collectionIdentifier: CollectionAccessibilityIdentifier.PhotosCollection)
        self.tapCollectionViewCell(1, collectionIdentifier: CollectionAccessibilityIdentifier.PhotosCollection)
        self.tapCollectionViewCell(2, collectionIdentifier: CollectionAccessibilityIdentifier.PhotosCollection)
        
        XCTAssertEqual(ReportViewModel.instance.imageIndexes, [ 0, 1, 2 ])
        
        if let window = UIApplication.shared.keyWindow {
            if let navigationController = window.rootViewController as? UINavigationController {
                navigationController.popViewController(animated: true)
            }
        }
        
        self.tapButton(ButtonAccessibilityLabel.GalleryButton)
        
        let collectionView = tester().waitForView(withAccessibilityLabel: CollectionAccessibilityIdentifier.PhotosCollection.rawValue) as!UICollectionView
        
        let selectedItems = collectionView.indexPathsForSelectedItems
        XCTAssertTrue(selectedItems == nil || selectedItems!.isEmpty)
        
        XCTAssertTrue(ReportViewModel.instance.imageIndexes.isEmpty)
    }
    
    func testEmptyLicensePlate() {
        self.tapButton(ButtonAccessibilityLabel.GalleryButton)
        
        self.tapCollectionViewCell(0, collectionIdentifier: CollectionAccessibilityIdentifier.PhotosCollection)
        self.tapCollectionViewCell(1, collectionIdentifier: CollectionAccessibilityIdentifier.PhotosCollection)
        
        self.tapButton(ButtonAccessibilityLabel.ContinueButton)
        self.tapButton(ButtonAccessibilityLabel.SendButton)
        
        tester().waitForView(withAccessibilityLabel: "Не указан номер")
    }
    
    func testEmptyAddress() {
        self.enterLicensePlate()
        
        self.tapButton(ButtonAccessibilityLabel.SendButton)
        tester().waitForView(withAccessibilityLabel: "Не указан адрес")
    }
    
    func testNotSelectedOffense() {
        self.enterLicensePlate()
        
        let tableView = tester().waitForView(withAccessibilityLabel: TableAccessibilityIdentifier.ReportTable.rawValue) as! UITableView
        
        let addressCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! ReportTableViewFirstCell
        addressCell.textField.becomeFirstResponder()
        
        tester().enterText(intoCurrentFirstResponder: "ул. Ангарская, 23")
        
        self.tapButton(ButtonAccessibilityLabel.SendButton)
        tester().waitForView(withAccessibilityLabel: "Не указана статья")
    }
    
    func testFilledForm() {
        self.enterLicensePlate()
        
        let tableView = tester().waitForView(withAccessibilityLabel: TableAccessibilityIdentifier.ReportTable.rawValue) as! UITableView
        
        let addressCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! ReportTableViewFirstCell
        addressCell.textField.becomeFirstResponder()
        tester().enterText(intoCurrentFirstResponder: "ул. Ангарская, 23")
        
        self.tapTableViewCell(3, tableIdentifier: TableAccessibilityIdentifier.ReportTable)
        
        tester().waitForView(withAccessibilityLabel: TableAccessibilityIdentifier.OffensesTable.rawValue)
        
        self.tapTableViewCell(2, tableIdentifier: TableAccessibilityIdentifier.OffensesTable)
        self.tapButton(ButtonAccessibilityLabel.ChooseButton)
        
        self.tapButton(ButtonAccessibilityLabel.SendButton)
        
        tester().waitForAbsenceOfView(withAccessibilityLabel: "Не указан номер")
        tester().waitForAbsenceOfView(withAccessibilityLabel: "Не указан адрес")
        tester().waitForAbsenceOfView(withAccessibilityLabel: "Не указана статья")
        
        tester().waitForView(withAccessibilityLabel: "ОБРАТИТЕ ВНИМАНИЕ", traits: UIAccessibilityTraitStaticText)
        
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
    
    func dismissPopover() {
        tester().tapScreen(at: CGPoint(x: 1, y: 1))
    }
    
    func tapButton(_ label: ButtonAccessibilityLabel) {
        tester().tapView(withAccessibilityLabel: label.rawValue, traits: UIAccessibilityTraitButton)
    }
    
    func tapCollectionViewCell(_ index: Int, collectionIdentifier: CollectionAccessibilityIdentifier) {
        tester().tapItem(at: IndexPath(item: index, section: 0), inCollectionViewWithAccessibilityIdentifier: collectionIdentifier.rawValue)
    }
    
    func tapTableViewCell(_ index: Int, tableIdentifier: TableAccessibilityIdentifier) {
        tester().tapRow(at: IndexPath(row: index, section: 0), inTableViewWithAccessibilityIdentifier: tableIdentifier.rawValue)
    }
    
    func enterLicensePlate() {
        self.tapButton(ButtonAccessibilityLabel.GalleryButton)
        
        self.tapCollectionViewCell(0, collectionIdentifier: CollectionAccessibilityIdentifier.PhotosCollection)
        self.tapCollectionViewCell(1, collectionIdentifier: CollectionAccessibilityIdentifier.PhotosCollection)
        
        self.tapButton(ButtonAccessibilityLabel.ContinueButton)
        
        let tableView = tester().waitForView(withAccessibilityLabel: TableAccessibilityIdentifier.ReportTable.rawValue) as! UITableView
        
        let licensePlateCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! ReportTableViewFirstCell
        licensePlateCell.textField.becomeFirstResponder()
        
        tester().enterText(intoCurrentFirstResponder: "1111 ОР-7")
    }
}
