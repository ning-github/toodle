//
//  AppDelegate.swift
//  Toodle
//
//  Created by NingX on 12/8/18.
//  Copyright © 2018 ningco. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Realm initialization
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        do {
            _ = try Realm()
        } catch {
            print("Error initializing new realm: \(error)")
        }
        
        return true
    }

}

