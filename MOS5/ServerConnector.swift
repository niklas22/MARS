//
//  ServerConnector.swift
//  MOS5
//
//  Created by Niklas Mayr on 09.12.15.
//  Copyright © 2015 Niklas Mayr. All rights reserved.
//

import Foundation

final class ServerConnector{
    
    let name:String!
    var url:NSURL!
    
    private init(name: String){
        self.name = name
    }
    
    func sendMessage(senddata: ObjectToStringDelegate,functionName: String!,completion: (jsonString: String,error: String) -> Void ) {
        
        self.url = NSURL(string: "http://193.170.133.31:33333/MarsServer/server/\(functionName)")!
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        
        // get encoded objectdatatoString
        request.HTTPBody = senddata.objectToString().dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPMethod = "POST"
        
        //set timeout from serverconnection in seconds
        request.timeoutInterval = 5
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error in
            
            if error != nil{
                completion(jsonString: "", error: error!.localizedDescription)
                return
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            completion(jsonString: String(responseString!),error: "")
            
        }
        
        task.resume()
    }
    
    
    // singletoninstance
    class var connector:ServerConnector{
        struct ServerConnectorWrapper{
            static let singleton = ServerConnector(name: "Connector")
        }
        
        return ServerConnectorWrapper.singleton
    }
    
    

    
}
