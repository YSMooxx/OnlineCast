//
//  CommonFunc.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/7.
//

import UIKit
import AudioToolbox

let cWindow:UIWindow? = {
    
    if #available(iOS 13, *) {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first(where: { $0.isKeyWindow })
    } else {
        return UIApplication.shared.keyWindow ?? UIWindow()
    }
    
}()

public func Print(_ items: Any...) {
    
    #if DEBUG
    print(items)
    #else
//    print(items)
    #endif
}

let set_wifi:String = "App-Prefs:root=WIFI"

func gotoSettings(url:String) {
    
    if let url = URL(string: UIApplication.openSettingsURLString) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

func shock() {
    
    if UserDef.shard.isShock {
     
        DispatchQueue.main.async {
            
            AudioServicesPlayAlertSound(1520)
        }
        
    }

}


