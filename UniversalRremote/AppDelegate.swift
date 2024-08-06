//
//  AppDelegate.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/6.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setConfig()
        
//        Thread.sleep(forTimeInterval: 2)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let vc = LaunchVC()
        
        let nav:LDBaseNavViewController = LDBaseNavViewController(rootViewController: vc)
        
        window?.rootViewController = ViewController()
        
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func setConfig() {
        
        FirebaseApp.configure()
        
        logEvent(eventId: open_app)
    }

}

