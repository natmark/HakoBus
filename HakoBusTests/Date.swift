//
//  Date.swift
//  HakoBus
//
//  Created by AtsuyaSato on 2017/02/18.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import Foundation

extension Date{
    static func inRange(from:(hour:Int,minute:Int),to:(hour:Int,minute:Int),date:NSDate = NSDate()) -> Bool{
        let cal = NSCalendar.current
        let now = cal.dateComponents([.hour, .minute], from: date as Date)
        let from_min = from.hour * 60 + from.minute
        let to_min = to.hour * 60 + to.minute
        let now_min = now.hour! * 60 + now.minute!
        
        if (from_min...to_min).contains(now_min) {
            return true
        }
        return false
    }
}
