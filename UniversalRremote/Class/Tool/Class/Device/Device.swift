//
//  Device.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/7.
//

import UIKit

let Roku:String = "Roku"
let Fire:String = "Fire"
let WebOS:String = "WebOS"

class Device:Codable {
    
    var type:String = ""
    var friendlyName:String = ""
    var UDN:String = ""
    var port:String = ""
    var url:String = ""
    var ip:String = ""
    var reName:String = ""
    
    enum CodingKeys: String, CodingKey{
        case friendlyName,UDN,url,ip,type,reName
    }
    
    init(url:String,ip:String) {
        
        self.url = url
        self.ip = ip
    }
    
}
