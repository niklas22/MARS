//
//  HeartViewController.swift
//  MOS5
//
//  Created by Niklas Mayr on 04.12.15.
//  Copyright © 2015 Niklas Mayr. All rights reserved.
//

import UIKit

class HeartViewController: UIViewController {

    var appdel:AppDelegate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appdel = UIApplication.sharedApplication().delegate as! AppDelegate
        
        HeartRate.checkAvailability { (isAvailable) -> Void in
            if isAvailable == true {
                self.appdel.hkAvailable = false
            }
            else {
                self.appdel.hkAvailable = false
            }
           
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func messureHeartRate(sender: AnyObject) {
        print(self.appdel.hkAvailable)
        var hrObject = HealthFactory.createHeartRateSensor()
        
        hrObject.startMonitoring()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
