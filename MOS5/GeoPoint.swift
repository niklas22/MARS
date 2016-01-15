//
//  GeoPoint.swift
//  MOS5
//
//  Created by Christian Floh on 15.01.16.
//  Copyright © 2016 Niklas Mayr. All rights reserved.
//

import Foundation



class GeoPoint {
    var lon : Double
    var lat : Double
    var alt : Double
    var timestamp : String
    
    init(_lon : Double, _lat : Double, _alt : Double, _time : String) {
        lon = _lon
        lat = _lat
        alt = _alt
        timestamp = _time
    }
    
    
}
