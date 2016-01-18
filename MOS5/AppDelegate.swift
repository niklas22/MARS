//
//  AppDelegate.swift
//  MOS5
//
//  Created by Niklas Mayr on 04.12.15.
//  Copyright © 2015 Niklas Mayr. All rights reserved.
//

import UIKit
import HealthKit



enum DGShortcutItemType: String {
    case Search
    case Activity
    
    init?(shortcutItem: UIApplicationShortcutItem) {
        guard let last = shortcutItem.type.componentsSeparatedByString(".").last else { return nil }
        self.init(rawValue: last)
    }
    
    var type: String {
        return NSBundle.mainBundle().bundleIdentifier! + ".\(self.rawValue)"
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var person : Person!
    var hkAvailable:Bool = false
    var personMail: String!
    var personPW: String!
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        

        
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        UINavigationBar.appearance().barTintColor = UIColor(red: 200/255, green: 37/255, blue: 27/255, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        UITabBar.appearance().barTintColor = UIColor.clearColor()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = UIImage()
        
        loadUserDefaults()
        
        return true
    }
    
    private func handleShortcutItem(shortcutItem: UIApplicationShortcutItem) {
        if let rootViewController = window?.rootViewController, let shortcutItemType = DGShortcutItemType(shortcutItem: shortcutItem) {
            rootViewController.dismissViewControllerAnimated(false, completion: nil)
            let alertController = UIAlertController(title: "", message: "", preferredStyle: .Alert)
            
            switch shortcutItemType {
            case .Search:
                alertController.message = "It's time to search"
                break
            case .Activity:
                alertController.message = "Activity start"
                if let vc = rootViewController as? UINavigationController {
                    
                    if self.person != nil {
                        let eventVC = vc.topViewController as! SignInTableViewController
                        eventVC.performSegueWithIdentifier("showMenu", sender: self)
                    }
                }
                break
            }
            
            //rootViewController.presentViewController(alertController, animated: true, completion: nil)

            
        }
    }
    
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        handleShortcutItem(shortcutItem)
    }

    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        saveUserDefaults()
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        loadUserDefaults()
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func saveUserDefaults(){
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(personMail, forKey: "personMail")
        userDefaults.setValue(personPW, forKey: "personPW")
        userDefaults.synchronize()
    }
    
    func loadUserDefaults(){
        if let usermail = NSUserDefaults.standardUserDefaults().valueForKey("personMail") {
            personMail = usermail as? String
        }
        
        if let userpw = NSUserDefaults.standardUserDefaults().valueForKey("personPW"){
            personPW = userpw as? String
        }
    }
    
    
}

