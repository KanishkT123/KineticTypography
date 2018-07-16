//
//  AppDelegate.swift
//  Reading Kitty
//
//  Created by cssummer18 on 6/4/18.
//  Copyright © 2018 cssummer18. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate { 

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Set initial view controller.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // If this is the first time the app has been launched, the initial view controller will be the login scene.
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore {
            print("App already launched")
            
            // Set the initial view controller.
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "Welcome") as? ViewController
            self.window?.rootViewController = initialViewController
        } else {
            print("App launched for first time")
            
            // Set up UserDefaults.
            setUpDefaults()
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            
            // Set the initial view controller.
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "Login") as? LoginViewController
            self.window?.rootViewController = initialViewController
            initialViewController?.firstLaunch = true
        }
        
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func setUpDefaults() {
        
    }

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

