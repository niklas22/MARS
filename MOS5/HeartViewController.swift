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
                self.hrObject = HealthFactory.createHeartRateSensor()
            }
            else {
                self.appdel.hkAvailable = false
                self.hrObject = HealthFactory.createHeartRateSensor()
            }
           
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func messureHeartRate(sender: AnyObject) {
       
        
        if measuring {
            
            if let bt = sender as? UIButton {
                bt.setTitle("Measuring heartrate", forState: .Normal)
                measuring = false
                hrObject.stopMonitoring()
                
                // send data to server
                ServerConnector.connector.sendMessage(hrObject, functionName: "uploadHeartrates", completion: { (jsonString, error) -> Void in
                    print(jsonString)
                })
            }
        } else {
            
            if let bt = sender as? UIButton {
                bt.setTitle("Stop measuring heartrate", forState: .Normal)
                measuring = true
                hrObject.startMonitoring()
            }
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

extension Array {
    
    func toJsonArray() -> String{
        var ar:String = "["
        
        for ind in 0...self.count-2{
            ar.appendContentsOf("\(JSONSerializer.toJson(self[ind] as! AnyObject)),")
        }
        ar.appendContentsOf("\(JSONSerializer.toJson(self[self.count-1] as! AnyObject))]")
        return ar
    }
}

