//
//  WebOSDevice.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/8.
//

import Foundation

class WebOSDevice: Device {
    
    override init(url: String, ip: String) {
        
        super.init(url: url, ip: ip)
        
        self.type = WebOS
    }
    
    required init(from decoder: any Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
}
