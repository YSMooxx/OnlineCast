//
//  ConnectSDKManager.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/21.
//

import Foundation
import ConnectSDK

class ConnectSDKManager:NSObject {
    
    static let manager:ConnectSDKManager = ConnectSDKManager()
    
    var deviceArray:[ConnectableDevice] = []
    
    var selectedDevice:ConnectableDevice?
    
    var cUrl:String?
    
    var castType:String?
    
    lazy var discoverMananger:DiscoveryManager = {
        
        let discover : DiscoveryManager = DiscoveryManager()
        
        discover.delegate = self
        
        return discover
    }()
    
    func startDiscovery() {
        
        discoverMananger.startDiscovery()
    }
    
    func stopDiscovery() {
        
        discoverMananger.stopDiscovery()
    }
    
    func LGCastImage(url:String) -> String{
        
        var sdevice = getDevice(name: "webOS")
        
        guard let lgDevice = sdevice else {return "no LG"}
        
        
        if lgDevice.connected {
            
            BeamMedia.castImage(withDievce: lgDevice, andURl: url)
        }else {
            
            cUrl = url
            
            castType = "image"
            
            lgDevice.connect()
            
            lgDevice.delegate = self
            
            Print(lgDevice.connected)
        }
        
        return lgDevice.friendlyName
    }
    
    func LGCastVideo(url:String) -> String{
        
        var sdevice = getDevice(name: "webOS")
        
        guard let lgDevice = sdevice else {return "no LG"}
        
        lgDevice.connect()
        
        Print(lgDevice.connected)
        
        if lgDevice.connected {
            
            BeamMedia.castVideo(withDievce: lgDevice, andURl: url)
        }else {
            
            cUrl = url
            
            castType = "video"
            
            lgDevice.connect()
            
            lgDevice.delegate = self
            
            Print(lgDevice.connected)
        }

        return lgDevice.friendlyName
    }
    
    func RokuCastImage(url:String) -> String{
        
        var sdevice = getDevice(name: "Roku")
        
        guard let lgDevice = sdevice else {return "No Roku"}
        
        lgDevice.connect()
        
        Print(lgDevice.connected)
        
        if lgDevice.connected {
            
            BeamMedia.castImage(withDievce: lgDevice, andURl: url)
        }else {
            
            cUrl = url
            
            castType = "image"
            
            lgDevice.connect()
            
            lgDevice.delegate = self
            
            Print(lgDevice.connected)
        }
        
        return lgDevice.friendlyName
    }
    
    func RokuCastVideo(url:String) -> String {
        
        var sdevice = getDevice(name: "Roku")
        
        guard let lgDevice = sdevice else {return "no Roku"}
        
        lgDevice.connect()
        
        if lgDevice.connected {
            
            BeamMedia.castVideo(withDievce: lgDevice, andURl: url)
        }else {
            
            cUrl = url
            
            castType = "video"
            
            lgDevice.connect()
            
            lgDevice.delegate = self
            
            Print(lgDevice.connected)
        }
        
        return lgDevice.friendlyName
    }
    
    func getDevice(name:String) -> ConnectableDevice? {
        
        var sdevice:ConnectableDevice?
        
        for device in deviceArray {
            
            if device.friendlyName.containsSubstring(substring: name) {
                
                sdevice = device
            }
        }
        
        return sdevice
    }
    
}

extension ConnectSDKManager:DiscoveryManagerDelegate {
    
    func discoveryManager(_ manager: DiscoveryManager!, didFind device: ConnectableDevice!) {
        
//        Print("friendlyName-----------\(device.friendlyName)")
//        Print("address-----------\(device.address)")
        
        deviceArray.append(device)
    }
    
    func discoveryManager(_ manager: DiscoveryManager!, didUpdate device: ConnectableDevice!) {
        
        
    }
}


extension ConnectSDKManager:ConnectableDeviceDelegate {
    
    func connectableDeviceReady(_ device: ConnectableDevice!) {
        
        if castType == "image" {
            
            BeamMedia.castImage(withDievce: device, andURl: cUrl ?? "")
        }else if castType == "viodeo" {
            
            BeamMedia.castVideo(withDievce: device, andURl: cUrl ?? "")
        }
        
        castType = nil
    }
    
    func connectableDeviceDisconnected(_ device: ConnectableDevice!, withError error: (any Error)!) {
        
        
    }
    
    
    
}

