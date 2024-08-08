//
//  FireDevice.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/8.
//

import Foundation
import Alamofire

class FireDevice: Device {
    
    override init(url: String, ip: String) {
        
        super.init(url: url, ip: ip)
        
        self.type = Fire
    }
    
    required init(from decoder: any Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
}
