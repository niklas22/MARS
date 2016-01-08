//
//  PedoViewController.swift
//  MarsApp
//
//  Created by Niklas Mayr on 03.12.15.
//  Copyright © 2015 Niklas Mayr. All rights reserved.
//

import UIKit

class PedoViewController: UIViewController {
    @IBOutlet weak var labelStepCount: UILabel!
    @IBOutlet weak var labelDistance: UILabel!
    @IBOutlet weak var labelSpeed: UILabel!
    
    let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var loop = true
    var pedo:Pedometer!
    var connector:ServerConnector!
    var steps:Steps!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pedo = Pedometer()
        connector = ServerConnector.connector
        steps = Steps()
    }
    
    @IBAction func btnStartPressed(sender: UIButton) {
        labelStepCount.text = "0 steps"
        labelDistance.text = "0 meter"
        labelSpeed.text = "0 km/h"
        
        steps.startTime = Int(NSDate().timeIntervalSince1970)
        
        appDel.person.steps = steps
        
        pedo.calculateSteps { (steps) -> Void in
            let distance : Double = Double(self.appDel.person.stepLength*steps/100)
            let time = (Int(NSDate().timeIntervalSince1970) - self.appDel.person.steps.startTime)
            let speed = Double(Double(distance) / Double(time)) * 3.6
            
            self.labelStepCount.text = "\(String(steps)) steps"
            self.labelDistance.text = "\(String(distance)) meter"
            self.labelSpeed.text = "\(String(speed)) km/h"
            
            self.appDel.person.steps.speed = speed
            self.appDel.person.steps.distance = distance
        }
    }
    
    @IBAction func btnStopPressed(sender: UIButton) {
        if appDel.person.steps.startTime == nil {
            return
        }
        
        appDel.person.steps.endTime = Int(NSDate().timeIntervalSince1970)
        appDel.person.steps.steps = pedo.steps
        
        appDel.person.steps.mail = appDel.person.mail
        appDel.person.steps.pw = appDel.person.pw
        
        connector.sendMessage(appDel.person.steps.objectToString(), functionName: "uploadSteps") { (jsonString,error) -> Void in
            print(jsonString)
            print(error)
        }
        
        pedo.stopCalculating()
        
        appDel.person.steps.startTime = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

