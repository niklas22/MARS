//
//  Pedometer.swift
//  MarsApp
//
//  Created by Christian Floh on 04.12.15.
//  Copyright © 2015 Niklas Mayr. All rights reserved.
//

import Foundation
import CoreMotion

class Pedometer{
    
    let manager = CMMotionManager()
    var serviceAvailable : Bool
    var steps : Int
    var notificationCenter = NSNotificationCenter.defaultCenter()
    
    init() {
        serviceAvailable = manager.accelerometerAvailable
        steps = 0
        
        if serviceAvailable {
            manager.accelerometerUpdateInterval = 0.2
            manager.startAccelerometerUpdates()
           
            
        }
    }
    
    func calculateSteps(completion: (steps: Int) -> Void) {
        
        if serviceAvailable {
            let violence = 1.8
            
            manager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { (data, error) -> Void in
                
                var x = data?.acceleration.x
                var y = data?.acceleration.y
                var z = data?.acceleration.z
                
                x = sqrt(pow(x!, 2))
                y = sqrt(pow(y!, 2))
                z = sqrt(pow(z!, 2))
                
                let sum = x! + y! + z!
                
                if (sum > violence) {
                    self.steps++
                    completion(steps: self.steps)
                }
            })
        }
    }
    
    func stopCalculating() {
        manager.stopAccelerometerUpdates()
        self.steps = 0
    }
    
}
