//
//  HeartRateObject.swift
//  MOS5
//
//  Created by Niklas Mayr on 07.01.16.
//  Copyright © 2016 Niklas Mayr. All rights reserved.
//

import Foundation

class HeartRateObject: ObjectToStringDelegate {
    var heartRate:Int
    var date:Int64
    
    init(heartRate: Int, date: Int64){
        self.heartRate = heartRate
        self.date = date
    }
    
    //uploadHeartrates heartrates
    
    func objectToString() -> String {
        let json = JSONSerializer.toJson(self)
        
        return json

    }
}