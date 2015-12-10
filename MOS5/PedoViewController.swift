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
    
    var loop = true
    var pedo:Pedometer!
    var connector:ServerConnector!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pedo = Pedometer()
        connector = ServerConnector.connector
    }
    
    @IBAction func btnStartPressed(sender: UIButton) {
        labelStepCount.text = "0"
        
        pedo.calculateSteps { (steps) -> Void in
            self.labelStepCount.text = String(steps)
        }
    }
    
    @IBAction func btnStopPressed(sender: UIButton) {
        pedo.stopCalculating()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendData(sender: AnyObject) {
        let person = Person()
        
        connector.sendMessage(person, functionName: "pt") { (jsonString,error) -> Void in
            print(jsonString)
            print(error)
        }
    }
}

