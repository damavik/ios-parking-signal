//
//  ApiEndpointService.swift
//  Parking
//
//  Created by Vital Vinahradau on 12/27/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import Foundation

protocol APIEndpointService {
    func fetchOffences(completion: [Offense]? -> Void) -> Disposable?
    func uploadOffenseReport(report: Report, completion: NSError? -> Void) -> Disposable?
}