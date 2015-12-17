//
//  HealthManager.swift
//  MOS5
//
//  Created by Niklas Mayr on 10.12.15.
//  Copyright © 2015 Niklas Mayr. All rights reserved.
//

import Foundation
import HealthKit
import UIKit

class HealthFactory {
    
    static var appdel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    class func createHeartRateSensor() -> HeartRateDelegate {
        if appdel.hkAvailable {
            return HeartRate()
        }
        else {
            return HeartRateSimulation()
        }
    }
    
    
    
}

