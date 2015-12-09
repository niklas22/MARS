//
//  File.swift
//  MOS5
//
//  Created by Niklas Mayr on 09.12.15.
//  Copyright © 2015 Niklas Mayr. All rights reserved.
//

import Foundation

protocol ObjectToStringDelegate {
    
    // convert a object to a POST-readyString
    // template: key=value&key=value&key=value, etc..
    //
    func objectToString()->String
}
