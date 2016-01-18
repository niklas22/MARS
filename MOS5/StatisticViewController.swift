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
    
    var gradient : CAGradientLayer!
    var locationManager : CLLocationManager!
    var lon = 0.0
    var lat = 0.0
    var tmp = 0.0
    var tmp2 = 0.0
    
    var connector:ServerConnector!
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        connector = ServerConnector.connector
        
        // setup gradient
        gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor(red: 200/255, green: 37/255, blue: 27/255, alpha: 1).CGColor, (UIColor.whiteColor().CGColor)]
        view.layer.insertSublayer(gradient, atIndex: 0)

        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 2
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            //locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loc = locations.last!
        let coord = loc.coordinate
        
        tmp = lon
        tmp2 = lat
        
        lon = coord.longitude
        lat = coord.latitude
        
        connector.getHeightData("\(lat),\(lon)", key: "AIzaSyBEsjG1o1IHmamjNpXB62qyKJCia7ScdVk") { (jsonString,error) -> Void in
            //print(jsonString)
            print(error)
            
            if let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding) {
                let json = JSON(data: data)
                
                for item in json["results"].arrayValue {
                    print(item["elevation"].stringValue)
                }
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.selectedIndex = 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

