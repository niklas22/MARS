//
//  HeartViewController.swift
//  MOS5
//
//  Created by Niklas Mayr on 04.12.15.
//  Copyright © 2015 Niklas Mayr. All rights reserved.
//

import UIKit

class HeartViewController: UIViewController {
    
    let appDel = UIApplication.sharedApplication().delegate as! AppDelegate

    var appdel:AppDelegate!
    
    var userinfo:Dictionary<String,String!>!
    
    var measuring:Bool = false
    
    @IBOutlet weak var heartRateLabel: UILabel!
    
    @IBOutlet weak var eeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateHeartRate:", name: "newHeartRate", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "messureHeartRate:", name: "changeHeartRateSource", object: nil)
        
        appdel = UIApplication.sharedApplication().delegate as! AppDelegate
        
        HeartRate.checkAvailability { (isAvailable) -> Void in
            if isAvailable == true {
                self.appdel.hkAvailable = true
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
        let hrObject = HealthFactory.createHeartRateSensor()
        
        if measuring {
            hrObject.stopMonitoring()
            measuring = false
        } else {
            hrObject.startMonitoring()
            measuring = true
        }
        
        
    }
    
    func updateHeartRate(notification: NSNotification){
        
        userinfo = notification.userInfo as! Dictionary<String,String!>
        
        dispatch_async(dispatch_get_main_queue()) {
            self.heartRateLabel.text = self.userinfo["bpm"]!
            self.eeLabel.text = "\(self.appDel.person.calcEE())"
        }
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
