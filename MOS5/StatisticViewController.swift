//
//  SecondViewController.swift
//  MOS5
//
//  Created by Niklas Mayr on 04.12.15.
//  Copyright © 2015 Niklas Mayr. All rights reserved.
//

import UIKit

class StatisticViewController: UIViewController {
    
    var gradient : CAGradientLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // setup gradient
        gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor(red: 200/255, green: 37/255, blue: 27/255, alpha: 1).CGColor, (UIColor.whiteColor().CGColor)]
        view.layer.insertSublayer(gradient, atIndex: 0)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

