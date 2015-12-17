//
//  HeartRateNew.swift
//  MOS5
//
//  Created by Niklas Mayr on 11.12.15.
//  Copyright © 2015 Niklas Mayr. All rights reserved.
//

import Foundation
import HealthKit

class HeartRate {
    
    //let heartRateQuantityType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)!
    
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
        
        return HKQuery.predicateForSamplesWithStartDate(timeIntervall,
            endDate: now,
            options: .StrictEndDate)
    }()
    
    lazy var query: HKObserverQuery = {
        return HKObserverQuery(sampleType: self.heartRateQuantityType,
            predicate: self.predicate,
            updateHandler: self.heartRateChangedHandler)
    }()
    
    func fetchRecordedHealthInLastDay(){
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate,
            ascending: true)
        
        let query = HKSampleQuery(sampleType: heartRateQuantityType,
            predicate: predicate,
            limit: Int(HKObjectQueryNoLimit),
            sortDescriptors: [sortDescriptor],
            resultsHandler: {(query: HKSampleQuery,
                results: [HKSample]?,
                error: NSError?) in
                
                guard let results = results where results.count > 0 else {
                    print("Could not read the user's heartRate")
                    print("or no heartRate data was available")
                    return
                }
                
                for sample in results as! [HKQuantitySample]{
                    /* Get the weight in kilograms from the quantity */
                    let heartRateUnit: HKUnit = HKUnit.countUnit().unitDividedByUnit(HKUnit.minuteUnit())
                
                    
                    let heartRate = sample.quantity.doubleValueForUnit(heartRateUnit)
                    
                    /* This is the value of "KG", localized in user's language */
                    dispatch_async(dispatch_get_main_queue(), {
                        print("HeartRate has been changed to " +
                            "\(heartRate)")
                        print("Change date = \(sample.startDate)")
                        
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
        healthStore.executeQuery(query)
        healthStore.enableBackgroundDeliveryForType(heartRateQuantityType,
            frequency: .Immediate,
            withCompletion: {succeeded, error in
                
                if succeeded{
                    print("Enabled background delivery of weight changes")
                } else {
                    if let theError = error{
                        print("Failed to enable background delivery of weight changes. ")
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
                print("Disabled background delivery of weight changes")
            } else {
                if let theError = error{
                    print("Failed to disable background delivery of weight changes. ")
                    print("Error = \(theError)")
                }
            }
            
        }
    }
    
    func startObserving(){
        dispatch_async(dispatch_get_main_queue(),
            self.heartRateChangesStart)
    }
    
    func stopObserving(){
        dispatch_async(dispatch_get_main_queue(),
            self.heartRateChangesStop)
    }
    
    
    
    func checkAvailability(completion: (isAvailable: Bool) -> Void) {
        
        if HKHealthStore.isHealthDataAvailable(){
            
            healthStore.requestAuthorizationToShareTypes(nil,
                readTypes: types,
                completion: {succeeded, error in
                    
                    if succeeded && error == nil{
                       completion(isAvailable: true)
                    } else {
                        if let theError = error{
                            print("Error occurred = \(theError)")
                        }
                        completion(isAvailable: false)
                    }
            })
            
        } else {
            print("Health data is not available")
        }
 
    }
    
}
