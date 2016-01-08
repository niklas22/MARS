//
//  HeartRateSimulation.swift
//  MOS5
//
//  Created by Niklas Mayr on 17.12.15.
//  Copyright © 2015 Niklas Mayr. All rights reserved.
//

import Foundation

class HeartRateSimulation: HeartRateDelegate {
    
    var error: NSErrorPointer = nil
    
    var fileLoc = NSBundle.mainBundle().pathForResource("simulationdata", ofType: "txt")
    
    var bpms:[String]?
    
    var timer:NSTimer!
    
    var index:Int!
    
    var hrObjects:[HeartRateObject] = []
    
    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
    let date:NSDate
    
    init(){
        date = NSDate().dateByAddingTimeInterval(2)
        
        index = 0;
        
        if let csv = CSV(contentsOfFile: fileLoc!, error: error){
            
            bpms = csv.columns["HEART RATE (bpm)"]
            
        }
    }
    
    func startMonitoring() {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("runCode"), userInfo: nil, repeats: true)
    }
    
    func stopMonitoring() {
        self.timer.invalidate()
        index = 0
        NSNotificationCenter.defaultCenter().postNotificationName("newHeartRate", object: nil, userInfo:["bpm":"0","date":"0"])
        
    }
    
    dynamic func runCode(){
        
        if bpms != nil {
            index = index % bpms!.count
            index = index + 1
            hrObjects.append(HeartRateObject(heartRate: Int(bpms![index])!, date: "0"))
            NSNotificationCenter.defaultCenter().postNotificationName("newHeartRate", object: nil, userInfo:["bpm":bpms![index], "date":"0"])
            
        }
        else {
            NSNotificationCenter.defaultCenter().postNotificationName("newHeartRate", object: nil, userInfo:["bpm":"0","date":"0"])
        }
    
    }
    
}
