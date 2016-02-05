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
    case Success(A)
    case Failure(ErrorType)
}

protocol NetworkService {
    func request(method: Method, url: String, parameters: [String: AnyObject]?, callback: NetworkServiceResult<AnyObject> -> Void) -> Disposable?
}
