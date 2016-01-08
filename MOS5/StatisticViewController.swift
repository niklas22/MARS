//
//  SecondViewController.swift
//  MOS5
//
//  Created by Niklas Mayr on 04.12.15.
//  Copyright © 2015 Niklas Mayr. All rights reserved.
//

import UIKit
import CoreLocation

class StatisticViewController: UIViewController,CLLocationManagerDelegate {
    
    var locationManager : CLLocationManager!
    var lon = 0.0
    var lat = 0.0
    var tmp = 0.0
    var tmp2 = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loc = locations.last!
        let coord = loc.coordinate
        
        tmp = lon
        tmp2 = lat
        
        lon = coord.longitude
        lat = coord.latitude
        
        if (tmp == lon && tmp2 == lat) {
            //New value, request altitude
            print("\(lon) && \(lat)")
        }
        

        print("locations = \(coord.latitude) \(coord.longitude)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

