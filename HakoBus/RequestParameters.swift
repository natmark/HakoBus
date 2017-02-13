//
//  GETParameters.swift
//  HakoBus
//
//  Created by AtsuyaSato on 2017/02/12.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import Foundation
import ObjectMapper

struct RouteSearchRequestParameters: Mappable {
    var origin:Int = 0
    var destination:Int = 0
    
    init?(map: Map){}
    mutating func mapping(map: Map) {
        origin <- map["origin"]
        destination <- map["destination"]
    }
    var APIParams: [String: Any] {
        return ["in":origin,"out":destination]
    }
}

struct BusStopSearchRequestParameters: Mappable {
    var name:String = ""
    
    init?(map: Map){}
    mutating func mapping(map: Map) {
        name <- map["name"]
    }
    var APIParams: [String: Any] {
        return ["stopname_f":name,"stopname_t":""]
    }
}
