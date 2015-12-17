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
    
    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
    let date:NSDate
    init(){
        date = NSDate().dateByAddingTimeInterval(5)
        
        index = 0;
        
        if let csv = CSV(contentsOfFile: fileLoc!, error: error){
            
            bpms = csv.columns["HEART RATE (bpm)"]
            
        }
    }
    
    func startMonitoring() {
        
        timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("runCode"), userInfo: nil, repeats: true)
        
    }
    
    func stopMonitoring() {
        timer.invalidate()
    }
    
    dynamic func runCode() -> Double{
        
        if bpms != nil {
            index = index % bpms!.count
            let curValue = Double(bpms![index])!
            index = index + 1
            print(curValue)
            
            return curValue
        }
        
        return 0
    }
    
    
}
