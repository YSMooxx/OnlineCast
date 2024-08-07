//
//  UserDef.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/7.
//

import Foundation

class UserDef:NSObject {
    
    static let shard:UserDef = UserDef()
    
    var isFirst:Bool = true
    var isFirstLoadingLanding:Bool = true
    var isShock:Bool = true
    var locaNetwork:Bool? = nil
    var tmptime:TimeInterval = 0
    
    override init() {
        
        let defaults:UserDefaults = UserDefaults.standard
        
        self.isFirst = defaults.value(forKey: "isFirst") as? Bool ?? true
        self.isFirstLoadingLanding = defaults.value(forKey: "isFirstLoadingLanding") as? Bool ?? true
        self.isShock = defaults.value(forKey: "isShock") as? Bool ?? true
        self.locaNetwork = defaults.value(forKey: "locaNetwork") as? Bool
        self.tmptime = defaults.value(forKey: "tmptime") as? TimeInterval ?? 0
        
    }
    
    func saveUserDefToSandBox() {
    
        let defaults:UserDefaults = UserDefaults.standard
        
            defaults.setValue(UserDef.shard.isFirst, forKey: "isFirst")
            defaults.setValue(UserDef.shard.isFirstLoadingLanding, forKey: "isFirstLoadingLanding")
            defaults.setValue(UserDef.shard.isShock, forKey: "isShock")
            defaults.setValue(UserDef.shard.locaNetwork, forKey: "locaNetwork")
            defaults.setValue(UserDef.shard.tmptime, forKey: "tmptime")
            defaults.synchronize()
    }
    
    class func saveKeyWithValue(key:String,value:Any) {
    
        UserDefaults.standard.set(value, forKey: key)
    }
}

