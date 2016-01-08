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
    
    func objectToString() -> String {
        return "email=\(mail)&pw=\(pw)&steps=\(steps)&start=\(startTime)&end=\(endTime)&distance=\(distance)&speed=\(speed)"
    }
}