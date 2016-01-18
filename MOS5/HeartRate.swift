//
//  HeartRateNew.swift
//  MOS5
//
//  Created by Niklas Mayr on 11.12.15.
//  Copyright © 2015 Niklas Mayr. All rights reserved.
//

import Foundation
import UIKit
import HealthKit

class HeartRate: HeartRateDelegate{
    
    var hrObjects:[HeartRateObject] = []
    
    
    let heartRateQuantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)!
    
    lazy var types: Set<HKObjectType> = {
        return [self.heartRateQuantityType]
    }()
    
    lazy var healthStore = HKHealthStore()
    
    lazy var predicate: NSPredicate = {
        let now = NSDate()
        
        let yesterday = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: -1, toDate: now, options: .WrapComponents)
        
        let timeIntervall = now.dateByAddingTimeInterval(-20*60)
        print(timeIntervall)
        
        return HKQuery.predicateForSamplesWithStartDate(yesterday,
            endDate: now,
            options: .StrictEndDate)
    }()
    
    lazy var query: HKObserverQuery = {
        return HKObserverQuery(sampleType: self.heartRateQuantityType,
            predicate: self.predicate,
            updateHandler: self.heartRateChangedHandler)
    }()
    
    func fetchRecordedHealthInLastDay(){
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate,
            ascending: true)
        
        let query = HKSampleQuery(sampleType: heartRateQuantityType,
            predicate: predicate,
            limit: Int(HKObjectQueryNoLimit),
            sortDescriptors: [sortDescriptor],
            resultsHandler: {(query: HKSampleQuery,
                results: [HKSample]?,
                error: NSError?) in
                
                if results?.count == 0{
                    print("no permission")
                }
                
                guard let results = results where results.count > 0 else {
                    let appdel = UIApplication.sharedApplication().delegate as! AppDelegate
                    appdel.hkAvailable = false
                    print("Could not read the user's heartRate")
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("changeHeartRateSource", object: nil)
                   // NSNotificationCenter.defaultCenter().postNotificationName("newHeartRate", object: nil, userInfo:["bpm":"0"])
                    return
                }
                
                
                var nowDouble:Int!
                
                for sample in results as! [HKQuantitySample]{
                    
                    let heartRateUnit: HKUnit = HKUnit.countUnit().unitDividedByUnit(HKUnit.minuteUnit())
                    
                    
                    
                    let heartRate = sample.quantity.doubleValueForUnit(heartRateUnit)
                    
                    nowDouble = Int(sample.startDate.timeIntervalSince1970*1000)
                    
                    
                    
                    let obj = HeartRateObject(heartRate: heartRate, date: String(nowDouble))
                    self.hrObjects.append(obj)
                    
                    // prints heartrate
                    dispatch_async(dispatch_get_main_queue(), {
                        NSNotificationCenter.defaultCenter().postNotificationName("newHeartRate", object: nil, userInfo:["bpm":String(heartRate),"date":String(nowDouble)])
                        
                    })
                }
                
                
        })
        
        healthStore.executeQuery(query)
        
    }
    
    func heartRateChangedHandler(query: HKObserverQuery,
        completionHandler: HKObserverQueryCompletionHandler,
        error: NSError?){
            
            /* Be careful, we are not on the UI thread */
            fetchRecordedHealthInLastDay()
            
            completionHandler()
            
    }
    
    func heartRateChangesStart(){
        
        initQuery()
        
        healthStore.executeQuery(query)
        healthStore.enableBackgroundDeliveryForType(heartRateQuantityType,
            frequency: .Immediate,
            withCompletion: {succeeded, error in
                
                if succeeded{
                   // print("Enabled background delivery of weight changes")
                } else {
                    if let theError = error{
                        print("Failed to enable background delivery of heartrate changes. ")
                        print("Error = \(theError)")
                    }
                }
                
        })
    }
    
    func heartRateChangesStop(){
        
        healthStore.stopQuery(query)
        healthStore.disableAllBackgroundDeliveryWithCompletion{
            succeeded, error in
            
            if succeeded{
                print("Disabled background delivery of heartrate changes")
                 NSNotificationCenter.defaultCenter().postNotificationName("newHeartRate", object: nil, userInfo:["bpm":"0","date":"0"])
            } else {
                if let theError = error{
                    print("Failed to disable background delivery of heartrate changes. ")
                    print("Error = \(theError)")
                }
            }
            
        }
    }
    
    func startMonitoring() {
        dispatch_async(dispatch_get_main_queue(),
            self.heartRateChangesStart)
    }
    
    func stopMonitoring() {
       
       dispatch_async(dispatch_get_main_queue(),
         self.heartRateChangesStop)
    }
    
    class func checkAvailability(completion: (isAvailable: Bool) -> Void){
        
        let heartRateQuantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)!
        let healthStore = HKHealthStore()
        
        let query = HKSampleQuery(sampleType: heartRateQuantityType,
            predicate: nil,
            limit: Int(HKObjectQueryNoLimit),
            sortDescriptors: nil,
            resultsHandler: {(query: HKSampleQuery,
                results: [HKSample]?,
                error: NSError?) in
                
                if results?.count == 0{
                    completion(isAvailable: false)
                } else {
                    completion(isAvailable: true)
                }
                
        })
        
        healthStore.executeQuery(query)
    }
    
    private func initQuery(){
        query = HKObserverQuery(sampleType: self.heartRateQuantityType,
            predicate: predicate,
            updateHandler: self.heartRateChangedHandler)
    }
    
}