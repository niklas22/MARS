//
//  Steps.swift
//  MOS5
//
//  Created by Christian Floh on 10.12.15.
//  Copyright © 2015 Niklas Mayr. All rights reserved.
//

import Foundation

class Steps: ObjectToStringDelegate {
    var startTime : Int!
    var endTime : Int!
    var steps : Int!
    var mail : String!
    var pw : String!
    var distance : Double!
    var speed : Double!
    
    init () {
        startTime = 0
        endTime = 0
        steps = 0
        mail = ""
        pw = ""
        distance = 0
        speed = 0
    }
    
    func objectToString() -> String {
        return "email=\(mail)&pw=\(pw)&steps=\(steps)&start=\(startTime)&end=\(endTime)&distance=\(distance)&speed=\(speed)"
    }
    
    func startDateToString() {
        print(NSDate(timeIntervalSince1970: NSTimeInterval(startTime)))
    }
    
    func endDateToString() {
        
    }
}