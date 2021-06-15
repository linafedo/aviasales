//
//  AppDelegate.swift
//  aviasales
//
//  Created by Galina Fedorova on 09.06.2021.
//  Copyright © 2021 Galina Fedorova. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GMSServices.provideAPIKey("AIzaSyA3apyruVMqFU2HB3HIkqcw1eQo3HUN650")
        GMSPlacesClient.provideAPIKey("AIzaSyA3apyruVMqFU2HB3HIkqcw1eQo3HUN650")

        let navigationController = UINavigationController(rootViewController: AirportsFactory().build())
        let window: UIWindow = {
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.backgroundColor = .white
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
            return window
        }()
        
        self.window = window
        
        
        return true
    }
}

