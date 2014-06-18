//
//  AppDelegate.swift
//  CheerRun
//
//  Created by Andy Chen on 6/4/14.
//  Copyright (c) 2014 Andy chen. All rights reserved.
//

import UIKit
import CoreLocation
//import FacebookSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        FBLoginView.self
        FBProfilePictureView.self
        //locationManager.requestAlwaysAuthorization()
        Parse.setApplicationId("IdH2nGMoBYXz3E6mjMlzIu4bfsRkw3FfV8ls4a6r", clientKey: "mmoCKgDBhoHs9eA9jK63yQtAf8HRHwVLa4oRidqJ")
        application.registerForRemoteNotificationTypes(UIRemoteNotificationType.None |
            UIRemoteNotificationType.Alert |
            UIRemoteNotificationType.Sound)
        return true
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
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication!,
        openURL url: NSURL!,
        sourceApplication asourceApplication: String!,
        annotation aannotation: AnyObject!) -> Bool {
            var wasHandled:ObjCBool = FBAppCall.handleOpenURL(url, sourceApplication: asourceApplication)
            //[FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
            
            // You can add your app-specific url handling code here if needed
            NSLog("123");
            return wasHandled;
    }
    
    func application(application:UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken:NSData)
    {
    // Store the deviceToken in the current installation and save it to Parse.
        var currentInstallation:PFInstallation = PFInstallation.currentInstallation()
        currentInstallation.setDeviceTokenFromData(deviceToken)
        currentInstallation.saveInBackground()
    }
    
    func application(application:UIApplication,
        didReceiveRemoteNotification userInfo:NSDictionary ) {
            PFPush.handlePush(userInfo)
    }
    
    func ios8() -> Bool {
        
        println("iOS " + UIDevice.currentDevice().systemVersion)
        
        if ( UIDevice.currentDevice().systemVersion == "8.0" ) {
            return true
        } else {
            return false
        }
        
    }


}

