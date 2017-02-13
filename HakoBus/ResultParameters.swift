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
