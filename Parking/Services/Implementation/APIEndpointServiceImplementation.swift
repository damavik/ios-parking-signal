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
    
    func fetchOffences(_ completion: @escaping ([Offense]?) -> Void) -> Disposable? {
        
        DispatchQueue.main.async {
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
    
    func uploadOffenseReport(_ report: Report, completion: @escaping (NSError?) -> Void) -> Disposable? {
        var finalReport = report
        finalReport.offense.name = nil
        finalReport.offense.text = nil
        
        let reportJston = Mapper().toJSONString(finalReport, prettyPrint: true)
        
        Log("report is \(reportJston)")
        
        let popTime = DispatchTime.now() + Double(Int64(3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: popTime) {
            completion(nil)
        }
        
        return nil
    }
}
