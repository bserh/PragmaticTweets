//
//  AppDelegate.swift
//  PragmaticTweets
//
//  Created by Sergey Bavykin on 3/14/16.
//  Copyright © 2016 Sergey Bavykin. All rights reserved.
//

import UIKit
import PragmaticTweetsFramework

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        var showedUserDetail = false
        
        guard let query = url.query where url.path == "/user" else {
            return false
        }
        let components = query.componentsSeparatedByString("=")
        if components.count > 1 && components[0] == "screenname" {
            if let sizeClassVC = self.window?.rootViewController as? SizeClassOverrideViewController {
                sizeClassVC.screenNameForOpenURL = components[1]
                sizeClassVC.performSegueWithIdentifier("ShowUserFromURLSegue", sender: self)
                showedUserDetail = true
            }
        }
        
        return showedUserDetail
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        guard let url = NSURL(string: "https://api.twitter.com/1.1/users/suggestions.json") else {
            return
        }
        sendTwitterRequest(url,
            params: [:],
            completion: {
                data, urlResponse, error in
                do {
                    let jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions([]))
                    NSLog("suggestions JSON: \(jsonObject)")
                } catch let error as NSError {
                    NSLog("JSON error: \(error)")
                }
        })
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

