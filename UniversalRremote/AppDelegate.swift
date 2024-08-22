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
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let vc = ViewController()
        
        window?.rootViewController = LDBaseNavViewController(rootViewController: vc)
        
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        if UserDef.shard.locaNetwork ?? false {
            
            LMLocalNetworkAuthorization.mananger.requestAuthorization { text in
                
                LMLocalNetworkAuthorization.mananger.currentStatus = text
            }
        }
    }
    
    func setConfig() {
        
//        AmazonFlingMananger.mananger.startDiscovered()
        ConnectSDKManager.manager.startDiscovery()
        startNetStatus()
//        
//        FirebaseApp.configure()
//        
//        getDefaulHeight()
//        
//        if !UserDef.shard.FirstOpen {
//            
//            logEvent(eventId: first_open)
//            UserDef.shard.FirstOpen = true
//            UserDef.shard.saveUserDefToSandBox()
//        }
//        
//        if UserDef.shard.lastOpenAppTime == 0 {
//            
//            logEvent(eventId: open_app,param: ["last_days_logon":0])
//        }else {
//            
//            let time:String =  String(format: "%.2f",  (getNowTimeInterval() - UserDef.shard.lastOpenAppTime) / Double(oneDay))
//            
//            logEvent(eventId: open_app,param: ["last_days_logon":time])
//        }
//        
//        UserDef.shard.lastOpenAppTime = getNowTimeInterval()
//        UserDef.shard.saveUserDefToSandBox()
    }
    
    func startNetStatus() {
        
        NetStatusManager.manager.startNet { status in
            
            NotificationCenter.default.post(name:  Notification.Name("NetWork_Change"), object: nil, userInfo: ["status":status])
        }
            
    }
    
    func getDefaulHeight() {
        
        if #available(iOS 13.0, *) {
            
            let window = UIApplication.shared.windows.first
            let topPadding = window?.safeAreaInsets.top ?? 0
            statusBarHeight = topPadding > 0 ? topPadding:20
            navHeight = navDefaultHeight + statusBarHeight
            navCenterY = 22 + statusBarHeight
        }else {
            
            statusBarHeight = UIApplication.shared.statusBarFrame.size.height
            navHeight = navDefaultHeight + statusBarHeight
            navCenterY = 22 + statusBarHeight
        }
        
        if #available(iOS 11.0, *) {
            
            safeHeight = UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0
        
        }else {
            
            safeHeight = 0
        }
    }

}

