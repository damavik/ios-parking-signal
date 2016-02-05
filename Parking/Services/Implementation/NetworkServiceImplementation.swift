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
    
    func request(method: Method, url: String, parameters: [String: AnyObject]?, callback: NetworkServiceResult<AnyObject> -> Void) -> Disposable? {
        
        return Alamofire.request(.GET, url, parameters: parameters, encoding: .URLEncodedInURL, headers: nil).responseJSON(completionHandler: { response in
            
            switch (response.result) {
            case let Result.Success(data):
                callback(NetworkServiceResult.Success(data))
                
            case let Result.Failure(error):
                callback(NetworkServiceResult.Failure(error))
            }
        })
    }
}