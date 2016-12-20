//
//  NetworkService.swift
//  Parking
//
//  Created by Vital Vinahradau on 12/13/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import Foundation

enum Method: String {
    case GET
    case POST
    case PUT
}

enum NetworkServiceResult<A> {
    case success(A)
    case failure(Error)
}

protocol NetworkService {
    func request(_ method: Method, url: String, parameters: [String: Any]?, callback: @escaping (NetworkServiceResult<Any>) -> Void) -> Disposable?
}
