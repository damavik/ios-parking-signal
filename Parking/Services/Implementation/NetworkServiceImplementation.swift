//
//  NetworkServiceImplementation.swift
//  Parking
//
//  Created by Vital Vinahradau on 12/13/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import Alamofire

extension Request : Disposable {
    public func dispose() {
        self.cancel()
    }
}

final class NetworkServiceImplementation : NetworkService {
    internal func request(_ method: Method, url: String, parameters: [String : Any]?, callback: @escaping (NetworkServiceResult<Any>) -> Void) -> Disposable? {
        
        return Alamofire.request(url, method: .get, parameters: parameters).validate().responseJSON(completionHandler: { (response) in
            switch (response.result) {
            case .success(let data):
                callback(NetworkServiceResult.success(data))
                
            case .failure(let error):
                callback(NetworkServiceResult.failure(error))
            }
        })
    }
}
