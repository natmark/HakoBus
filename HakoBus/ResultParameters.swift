//
//  ResultParameters.swift
//  HakoBus
//
//  Created by AtsuyaSato on 2017/02/13.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import Foundation
import ObjectMapper

struct BusStopSearchResultParameters: Mappable {
    var name:String = ""
    var id:Int = 0

    init?(map: Map){}
    mutating func mapping(map: Map) {
        name <- map["name"]
        id <- map["id"]
    }
}
struct RouteSearchResultParameters: Mappable {
    var destination:String = ""
    var departure:String = ""
    var schedule_url:String = ""
    var map_url:String = ""
    var boarding_place:String = ""
    var operation_status:String = ""
    
    init?(map: Map){}
    mutating func mapping(map: Map) {
        destination <- map["destination"]
        departure <- map["departure"]
        schedule_url <- map["schedule_url"]
        map_url <- map["map_url"]
        boarding_place <- map["boarding_place"]
        operation_status <- map["operation_status"]
    }
}
struct ArrivedScheduleResultParameters: Mappable {
    var name:String = ""
    var time:String = ""
    
    init?(map: Map){}
    mutating func mapping(map: Map) {
        name <- map["name"]
        time <- map["time"]
    }
}
