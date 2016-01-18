//
//  GeoPoint.swift
//  MOS5
//
//  Created by Christian Floh on 15.01.16.
//  Copyright © 2016 Niklas Mayr. All rights reserved.
//

import Foundation



class GeoPoint {
    var longitude : Double
    var latitude : Double
    var altitude : Double
    var timestamp : String
    
    init(_lon : Double, _lat : Double, _alt : Double, _time : String) {
        longitude = _lon
        latitude = _lat
        altitude = _alt
        timestamp = _time
    }
    
    
}
