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
    
    
    init() {
        if manager.accelerometerAvailable {
            
        } else {
            
        }
    }
}