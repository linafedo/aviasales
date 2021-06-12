//
//  AppDelegate.swift
//  aviasales
//
//  Created by Galina Fedorova on 09.06.2021.
//  Copyright © 2021 Galina Fedorova. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window: UIWindow = {
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.backgroundColor = .white
            window.rootViewController = AirportsFactory.build() 
            window.makeKeyAndVisible()
            return window
        }()
        
        self.window = window
        return true
    }
}

