//
//  Logging.swift
//  Parking
//
//  Created by Vital Vinahradau on 1/9/16.
//  Copyright © 2016 Signal. All rights reserved.
//

import Crashlytics

public func Log(_ format: String, _ arguments: CVarArg...) {
    withVaList(arguments) {
#if DEBUG
            CLSNSLogv(format, $0)
#else
            CLSLogv(format, $0)
#endif
    }
}
