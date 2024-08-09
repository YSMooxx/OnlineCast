//
//  Device.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/7.
//

import UIKit
import Alamofire

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
        case friendlyName,UDN,url,ip,type,reName,port
    }
    
    init(url:String,ip:String) {
        
        self.url = url
        self.ip = ip
    }
    
    class func getTypeDeviceWith(servece:SSDPService,suc:@escaping (Device) -> Void = {dev in }) {
        
        let url:String = servece.location ?? ""
        let ip:String = servece.host
        let softInfo:String = servece.server ?? ""
        var newUrl:String = url
        
        if !newUrl.containsSubstring(substring: "xml") {
            
            if softInfo.containsSubstring(substring: "roku") || softInfo.containsSubstring(substring: "linux") {
                
                newUrl = url + ".xml"
            }
        }
        
        guard let URl = URL(string: newUrl) else { return }
        
        AF.request(URl).responseData {response in
            
            switch response.result {
            case .success(let xmlData):
                
                guard let xmlString = String(data: xmlData, encoding: .utf8) else {
                        return
                }
                
                var device:Device?
                
                if softInfo.containsSubstring(substring: "roku") {
                    
                    device = Device.checkRoku(url:newUrl , ip: ip, xmlStr: xmlString)
                }else if softInfo.containsSubstring(substring: "WebOS") {
                    
                    device = Device.checkWebOS(url:newUrl , ip: ip, xmlStr: xmlString)
                }else {
                    
                    device = Device.checkFire(url:newUrl , ip: ip, servece: servece, xmlStr: xmlString)
                }
                
                guard let typeDevice = device else  {
                    
                    return
                }
                
                suc(typeDevice)
                
            case  .failure(_):
                break
            }
        }
        
    }
    
    class func checkFire(url:String,ip:String,servece:SSDPService,xmlStr:String) -> Device?{
        
        guard let dic =  NSDictionary.init(xmlString: xmlStr) as? [String:Any] else {return nil}
        guard let deviceStr = dic["device"] as? [String:Any] else {return nil}
        guard let UDN = deviceStr["UDN"] as? String,let friendlyName = deviceStr["friendlyName"] as? String,
        let deviceType = deviceStr["deviceType"] as? String else {return nil}
        
        var device:Device?
        
        for smodel in AmazonFlingMananger.mananger.discoveryModelArray {
            
            if friendlyName == smodel.name {
                
                device = FireDevice(url: url,ip: ip)
                device?.friendlyName = friendlyName
                device?.reName = friendlyName
                device?.UDN = UDN
            }
        }
        
        return device
    }
    
    class func checkWebOS(url:String,ip:String,xmlStr:String) -> Device?{
        
        guard let dic =  NSDictionary.init(xmlString: xmlStr) as? [String:Any] else {return nil}
        guard let deviceStr = dic["device"] as? [String:Any] else {return nil}
        guard let friendlyName = deviceStr["friendlyName"] as? String else {return nil}
        guard let UDN = deviceStr["UDN"] as? String,let manufacturer = deviceStr["manufacturer"] as? String else {return nil}
        
        var device:Device?
        
        if manufacturer.containsSubstring(substring: "LG") {
            
            device = WebOSDevice(url: url, ip: ip)
            device?.friendlyName = friendlyName
            device?.reName = friendlyName
            device?.UDN = UDN
        }
        
        return device
    }
    
    class func checkRoku(url:String,ip:String,xmlStr:String) -> Device?{
        
        guard let dic =  NSDictionary.init(xmlString: xmlStr) as? [String:Any] else {return nil}
        guard let deviceStr = dic["device"] as? [String:Any] else {return nil}
        guard let friendlyName = deviceStr["friendlyName"] as? String else {return nil}
        guard let UDN = deviceStr["UDN"] as? String,let manufacturer = deviceStr["manufacturer"] as? String else {return nil}
        
        var device:Device?
        
        if let serviceList = deviceStr["serviceList"] as? [String:Any] {
            
            var isHaveOrku:Bool = false
            
            for service in serviceList.values {
                
                guard let array = service as? [[String:Any]]  else {continue}
                
                for list in array {
                    
                    guard let dic = list["serviceType"] as? String else {continue}
                    
                    if dic.containsSubstring(substring: "Roku") {
                        
                        isHaveOrku = true
                    }
                }
                
            }
            
            if isHaveOrku {
                
                device = RokuDevice(url: url, ip: ip)
                device?.port = Device.getUUIDWithUrl(urlString: url)
                device?.friendlyName = friendlyName
                device?.reName = friendlyName
                device?.UDN = UDN
            }else {
                
                if manufacturer.containsSubstring(substring: "Roku") || friendlyName.containsSubstring(substring: "Roku") {
                    
                    
                    device = RokuDevice(url: url, ip: ip)
                    device?.port = Device.getUUIDWithUrl(urlString: url)
                    device?.friendlyName = friendlyName
                    device?.reName = friendlyName
                    device?.UDN = UDN
                }
            }
            
        }else {
            
            if manufacturer.containsSubstring(substring: "Roku") || friendlyName.containsSubstring(substring: "Roku") {
                
                device = RokuDevice(url: url, ip: ip)
                device?.port = Device.getUUIDWithUrl(urlString: url)
                device?.friendlyName = friendlyName
                device?.reName = friendlyName
                device?.UDN = UDN
            }
        }
        
        return device
    }
    
    func getPortWithUrl(url:String) {
        
        
    }
    
    class func getUUIDWithUrl(urlString:String) -> String {
        
        if let url = URL(string: urlString), let components = URLComponents(url: url, resolvingAgainstBaseURL: true) {
            // 获取端口号
            if let port = components.port {
                print("端口号是：\(port)")
                return String(port)
            } else {
                return "8060"
            }
        } else {
            return "8060"
        }
    }
    
}
