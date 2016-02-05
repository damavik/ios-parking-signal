//
//  APIEndpointServiceImplementation.swift
//  Parking
//
//  Created by Vital Vinahradau on 12/27/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import Foundation
import ObjectMapper

class APIEndpointServiceImplementation: APIEndpointService {
    // MARK: APIEndpointService
    
    func fetchOffences(completion: [Offense]? -> Void) -> Disposable? {
        
        dispatch_async(dispatch_get_main_queue()) {
            // FIXME: fill model properly
            var offenses = [Offense]()
            
            offenses.append(Offense(JSON: [ "code" : "143.3", "desc" : "Парковка на пешеходных переходах и ближе 15 метров от них на дороге в обе стороны" ])!)
            
            offenses.append(Offense(JSON: [ "code" : "143.14", "desc" : "Парковка на тротуарах, кроме специально отведенных мест, обозначенных дорожным знаком «Место стоянки» («Место стоянки такси»)" ])!)
            
            offenses.append(Offense(JSON: [ "code" : "143.15", "desc" : "Парковка на газонах и других участках с зелёными насаждениями" ])!)
            
            offenses.append(Offense(JSON: [ "code" : "143.16", "desc" : "Парковка на проездах во дворах со стороны, прилегающей к жилой застройке" ])!)
            
            completion(offenses)
        }
        
        return nil
    }
    
    func uploadOffenseReport(report: Report, completion: NSError? -> Void) -> Disposable? {
        var finalReport = report
        finalReport.offense.name = nil
        finalReport.offense.text = nil
        
        let reportJston = Mapper().toJSONString(finalReport, prettyPrint: true)
        
        Log("report is \(reportJston)")
        
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC)))
        dispatch_after(popTime, dispatch_get_main_queue()) {
            completion(nil)
        }
        
        return nil
    }
}