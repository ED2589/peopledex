//
//  AppDelegate.swift
//  peopledex
//
//  Created by Owner on 2018-08-25.
//  Copyright © 2018 hackthe6ix team. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
            FirebaseApp.configure()
            return true
    }


}
