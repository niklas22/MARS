//
//  HealthManager.swift
//  MOS5
//
//  Created by Niklas Mayr on 10.12.15.
//  Copyright © 2015 Niklas Mayr. All rights reserved.
//

import Foundation
import HealthKit

class HealthManager {
    
    var healthStore:HKHealthStore?
    var heartRateSampleType:HKQuantityType!
    
    func authorizeHealthKit(completion: ((success:Bool) -> Void)!){
        
        heartRateSampleType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)!
        
        
        let healthDataRead = Set<HKQuantityType>(arrayLiteral: heartRateSampleType)
        
        
        if !HKHealthStore.isHealthDataAvailable(){
            if( completion != nil )
            {
                completion(success:false)
            }
            return
            
        } else{
            
            // healthdata available
            healthStore = HKHealthStore()
            healthStore!.requestAuthorizationToShareTypes(nil, readTypes: healthDataRead) { (success, error) -> Void in
                
                if( completion != nil )
                {
                    completion(success:success)
                }
            }
            
            healthStore?.enableBackgroundDeliveryForType(heartRateSampleType, frequency: HKUpdateFrequency.Immediate, withCompletion: { (success, error) -> Void in
                if(success){
                    print("success update")
                }
                else{
                    print("no success in update")
                }
            })
        }
    }
    
    func initHeartRateObserver(completion: () -> Void){
        
        if (healthStore != nil){
            
            
            let query = HKObserverQuery(sampleType: heartRateSampleType, predicate: nil) {
                query, completion, error in
                
                if error != nil {
                    
                    // Perform Proper Error Handling Here...
                    print("Error occured")
                    return
                }
                
                // Take whatever steps are necessary to update your app's data and UI
                // This may involve executing other queries
                
                // If you have subscribed for background updates you must call the completion handler here.
                //completionHandler()
                print("found")
                completion()
            }
            
            healthStore!.executeQuery(query)
            
        }
    }
    
    func readMostRecentSample(completion: ((HKSample!, NSError!) -> Void)!)
    {
        
        // 1. Build the Predicate
        let past = NSDate.distantPast()
        let now   = NSDate()
        let mostRecentPredicate = HKQuery.predicateForSamplesWithStartDate(past, endDate:now, options: .None)
        
        // 2. Build the sort descriptor to return the samples in descending order
        let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)
        // 3. we want to limit the number of samples returned by the query to just 1 (the most recent)
        let limit = 1
        
        // 4. Build samples query
        let sampleQuery = HKSampleQuery(sampleType: heartRateSampleType, predicate: mostRecentPredicate, limit: limit, sortDescriptors: [sortDescriptor])
            { (sampleQuery, results, error ) -> Void in
                
                if let queryError = error {
                    completion(nil,queryError)
                    return
                }
                
                // Get the first sample
                let mostRecentSample = results!.first as? HKQuantitySample
                
                // Execute the completion closure
                if completion != nil {
                    completion(mostRecentSample,nil)
                }
        }
        // 5. Execute the Query
        healthStore!.executeQuery(sampleQuery)
    }
}

