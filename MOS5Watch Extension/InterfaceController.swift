//
//  InterfaceController.swift
//  MOS5Watch Extension
//
//  Created by Christian Floh on 09.12.15.
//  Copyright © 2015 Niklas Mayr. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        let appGroudID = "group.at.fhooe.mc.MARS"
        
        let defaults = NSUserDefaults(suiteName: appGroudID)
        
        let value = "MARSHATSSARS"
        
        defaults!.setObject(value, forKey: "value")
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
