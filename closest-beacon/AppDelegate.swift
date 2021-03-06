//
//  AppDelegate.swift
//  closest-beacon
//
//  Created by Eric Mertz on 11/19/17.
//  Copyright © 2017 Eric Mertz. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{ //}, ESTBeaconManagerDelegate {

    var window: UIWindow?


    //create instance of beaconmanager
    //let beaconManager = ESTBeaconManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //set the beacon manager's delegate
        //self.beaconManager.delegate = self
        
        //we can do always bc we want to run it in the bkgrnd
//        self.beaconManager.requestAlwaysAuthorization()
//
//        self.beaconManager.startMonitoring(for: CLBeaconRegion(
//            proximityUUID: UUID(uuidString:  "A28AA73B-4711-3CBE-E1DE-45A14E175B0C")!,
//            major: 123, minor: 123, identifier: "monitored region"))
//
//        UIApplication.shared.registerUserNotificationSettings(
//            UIUserNotificationSettings(types: .alert, categories: nil))
//
        return true
    }
    
//    func beaconManager(_ manager: Any, didEnter region: CLBeaconRegion) {
//        let notification = UILocalNotification()
//        notification.alertBody =
//            "Your gate closes in 47 minutes. " +
//            "Current security wait time is 15 minutes, " +
//            "and it's a 5 minute walk from security to the gate. " +
//        "Looks like you've got plenty of time!"
//        UIApplication.shared.presentLocalNotificationNow(notification)
//    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

