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
    
    @IBAction func btnStartPressed(sender: UIButton) {
        labelStepCount.text = "0"
    }
    
    @IBAction func btnStopPressed(sender: UIButton) {
        let steps = Int(labelStepCount.text!)!
        
        print(steps)
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

