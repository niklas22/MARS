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
    
    let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var loop = true
    var pedo:Pedometer!
    var connector:ServerConnector!
    var steps:Steps!
    var person:Person!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pedo = Pedometer()
        connector = ServerConnector.connector
        steps = Steps()
    }
    
    @IBAction func btnStartPressed(sender: UIButton) {
        labelStepCount.text = "0 steps"
        labelDistance.text = "0 meter"
        
        steps.startTime = Int(NSDate().timeIntervalSince1970)
        
        pedo.calculateSteps { (steps) -> Void in
            self.labelStepCount.text = "\(String(steps)) steps"
            self.labelDistance.text = "\(String(self.appDel.person.stepLength*steps/100)) meter"
        }
    }
    
    @IBAction func btnStopPressed(sender: UIButton) {
        steps.endTime = Int(NSDate().timeIntervalSince1970)
        steps.steps = pedo.steps
        
        steps.mail = appDel.person.mail
        steps.pw = appDel.person.pw
        
        connector.sendMessage(steps, functionName: "uploadSteps") { (jsonString,error) -> Void in
            print(jsonString)
            print(error)
        }
        
        pedo.stopCalculating()
        
        print(steps.startTime)
        print(steps.endTime)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

