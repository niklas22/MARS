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
    let pedo = Pedometer()
    
    @IBAction func btnStartPressed(sender: UIButton) {
        labelStepCount.text = "0"
        
        pedo.calculateSteps()
        
        labelStepCount.text = String(pedo.steps)
    }
    
    @IBAction func btnStopPressed(sender: UIButton) {
        let steps = Int(labelStepCount.text!)!
        
        pedo.stopCalculating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

