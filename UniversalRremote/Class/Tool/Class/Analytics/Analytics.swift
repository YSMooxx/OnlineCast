//
//  Analytics.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/6.
//

import FirebaseAnalytics


let open_app:String = "open_app"

func logEvent(eventId:String,param:[String:Any]? = nil) {
    
    Print("Analytics--------\(eventId)")
    
    if param == nil {
        
        Analytics.logEvent(eventId, parameters: param)
    }else {
        
        var new:[String:Any] = param ?? [:]
        
        if let value = new.removeValue(forKey: "user_ip") {
            new["ad_id"] = value
        }
        
        Analytics.logEvent(eventId, parameters: new)
    }
}
