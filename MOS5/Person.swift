//
//  Person.swift
//  MOS5
//
//  Created by Niklas Mayr on 09.12.15.
//  Copyright © 2015 Niklas Mayr. All rights reserved.
//

import Foundation

class Person: ObjectToStringDelegate {
    var name:String!
    var mail:String!
    var pw:String!
    var age:Int!
    var height:Int!
    var weight:Int!
    var gender:Bool!
    var par:Int!
    var stepLength:Int!
    var heartrate:Double!
    
    func objectToString() -> String {
        return "name=\(name)&email=\(mail)&pw=\(pw)&age=\(age)&height=\(height)&weight=\(weight)&gender=\(gender)&par=\(par)&steplength=\(stepLength)"
    }
    
    func jsonToObject(jsonString: String) -> Person{
        if let dataFromString = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            let json = JSON(data: dataFromString)
            
            var p = Person()
            
            p.name = json["name"].stringValue
            p.age = json["age"].intValue
            p.height = json["height"].intValue
            p.weight = json["weight"].intValue
            p.gender = json["gender"].boolValue
            p.par = json["par"].intValue
            p.stepLength = json["steplength"].intValue
            
            return p
        }
        
        return Person()
    }
    
    init() {
        name = ""
        mail = ""
        pw = ""
        age = 0
        height = 0
        weight = 0
        par=0
        stepLength=0
        heartrate=0
    }
    
    func calcVO() -> Double{
        //Predicted VO2max [ml / min / kg] = (0.133 age) – (0.005 age2) + (11.403
        //gender) + (1.463 PA-R) + (9.17 height) – (0.254 body_mass) + 34.143
        
        //Gender: 1=male, 0=female | height=meters | mass=kilograms
        
        var res = 0.0
        
        let age2 = Double(age)
        let gender2 : Double
        let par2 = Double(par)
        let height2 = Double(height)
        let mass = Double(weight)
        
        if gender == true { gender2 = 1 }
            else { gender2 = 0 }
        
        res = (0.133*age2) - (0.005 * pow(age2, 2)) + (11.403 * gender2) + (1.463 * par2) + (9.17 * height2) - (0.254 * mass) + 34.143
        
        
        return res
    }
    
    func calcEE() -> Double {
        //EE = -59.3954 + gender x (-36.3781 + 0.271 x age + 0.394 x weight + 0.404 V[O.sub.2max] + 0.634x heart rate) + (1 - gender) x (0.274 x age + 0.103x weight + 0.380x V[O.sub.2max] + 0.450 x heart rate)
        
        if heartrate == 0 {
            return 0
        }
        
        var res = 0.0
        
        let age2 = Double(age)
        let gender2 : Double
        let mass = Double(weight)
        
        if gender == true { gender2 = 1 }
            else { gender2 = 0 }
        
        res = -59.3954 + gender2 * (-36.3781 + 0.271 * age2 + 0.394 * mass + 0.404 * calcVO() + 0.634 * heartrate) + (1 - gender2) * (0.274 * age2 + 0.103 * mass + 0.380 * calcVO() + 0.450 * heartrate)
        
        return res
    }
    
}
