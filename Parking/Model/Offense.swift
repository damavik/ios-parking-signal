//
//  Offense.swift
//  Parking
//
//  Created by Vital Vinahradau on 11/20/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import ObjectMapper

struct Offense : Mappable, Equatable {
    var article: String!
    var name: String!
    var text: String!
        
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        self.article <- map["code"]
        self.name <- map["name"]
        self.text <- map["desc"]
    }
}

func ==(first: Offense, second: Offense) -> Bool {
    return first.article == second.article
}
