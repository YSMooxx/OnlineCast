//
//  Analytics.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/6.
//

import FirebaseAnalytics

let first_open:String = "first_open";
let open_app:String = "open_app";
let search_device:String = "search_device";
let no_device:String = "no_device";
let search_device_result:String = "search_device_result";
let device_click_connect:String = "device_click_connect";
let device_connect_success:String = "device_connect_success";
let search_support_device:String = "search_support_device";

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
