//
//  AppDelegate.swift
//  TodoSimple
//
//  Created by Sergey on 3/13/17.
//  Copyright © 2017 SergeyK. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        RealmManager.initialize()
        self.loadMainInterface()
        return true
    }
    
    private func loadMainInterface() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let rootController = mainStoryboard.instantiateInitialViewController()
        assert(rootController != nil, "No user interface")
        self.window?.rootViewController = rootController
        self.window?.makeKeyAndVisible()
    }
}

