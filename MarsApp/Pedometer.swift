//
//  Pedometer.swift
//  MarsApp
//
//  Created by Christian Floh on 04.12.15.
//  Copyright © 2015 Niklas Mayr. All rights reserved.
//

import Foundation
import CoreMotion

class Pedometer {
    
    let manager = CMMotionManager()
    var serviceAvailable : Bool
    var steps : Int
    
    init() {
        serviceAvailable = manager.accelerometerAvailable
        steps = 0
        
        if serviceAvailable {
            manager.accelerometerUpdateInterval = 0.2
            manager.startAccelerometerUpdates()
        }
    }
    
    func getSteps() -> Int{
        if serviceAvailable {
            let violence = 1.2
            
            let data = manager.accelerometerData
            var x = data?.acceleration.x
            var y = data?.acceleration.y
            var z = data?.acceleration.z
            
            x = sqrt(pow(x!, 2))
            y = sqrt(pow(y!, 2))
            z = sqrt(pow(z!, 2))
            
            if (x > violence || y > violence || z > violence) {
                steps++
            }
            
        }
        
        return steps
    }
    
}