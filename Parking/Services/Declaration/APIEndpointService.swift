//
//  ApiEndpointService.swift
//  Parking
//
//  Created by Vital Vinahradau on 12/27/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import Foundation

protocol APIEndpointService {
    @discardableResult func fetchOffences(_ completion: @escaping ([Offense]?) -> Void) -> Disposable?
    @discardableResult func uploadOffenseReport(_ report: Report, completion: @escaping (NSError?) -> Void) -> Disposable?
}
