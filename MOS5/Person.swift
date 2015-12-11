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
    
    func objectToString() -> String {
        return "name=\(name)&email=\(mail)&pw=\(pw)&age=\(age)&height=\(height)&weight=\(weight)"
    }
    
    init() {
        name = ""
        mail = ""
        pw = ""
        age = 0
        height = 0
        weight = 0
    }
    
}
