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
    var date:String
    
    init(heartRate: Int, date: String){
        self.heartRate = heartRate
        self.date = date
        
    }
    
    //uploadHeartrates heartrates
    
    func objectToString() -> String {
        
        let json = JSONSerializer.toJson(self)
        return json

    }
}