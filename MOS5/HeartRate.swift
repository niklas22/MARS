//
//  HeartRate.swift
//  MOS5
//
//  Created by Niklas Mayr on 10.12.15.
//  Copyright © 2015 Niklas Mayr. All rights reserved.
//

import Foundation
import HealthKit

class HeartRate {
    
    let healthManager:HealthManager
    
    init(){
        healthManager = HealthManager()
        
        healthManager.authorizeHealthKit { (success) -> Void in
            if(success){
                print("success")
            } else{
                print("no success")
            }
        }
    }
    
}