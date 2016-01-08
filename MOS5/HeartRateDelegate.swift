//
//  HeartRateDelegate.swift
//  MOS5
//
//  Created by Niklas Mayr on 17.12.15.
//  Copyright © 2015 Niklas Mayr. All rights reserved.
//

import Foundation

protocol HeartRateDelegate: class, ObjectToStringDelegate {
    
    func startMonitoring()
    
    func stopMonitoring()
    
    var hrObjects: [HeartRateObject]{get set}
}


