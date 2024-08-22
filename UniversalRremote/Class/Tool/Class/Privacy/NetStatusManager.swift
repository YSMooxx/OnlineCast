//
//  NetStatusManager.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/8.
//

import Alamofire
import Network

enum NetStatus{
    
    case NoNet
    case WIFI
    case WWAN
}


class NetStatusManager: NSObject {
    static let manager:NetStatusManager = NetStatusManager()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")
    var currentStatus:NetStatus?
    
    func startNet(netStatus: @escaping(NetStatus)->Void) {
        
        monitor.pathUpdateHandler = { path in
            
            defaultDeviceArray = []
            AmazonFlingMananger.mananger.discoveryModelArray = []
            if path.status == .satisfied {
                Print("网络连接正常")
                if path.isExpensive {
                    
                    AmazonFlingMananger.mananger.stopDiscovered()
                    if self.currentStatus != .WWAN {
                        
                        self.currentStatus = .WWAN
                        netStatus(.WWAN)
                    }
                    
                    Print("连接的是蜂窝网络")
                } else {
                    
                    AmazonFlingMananger.mananger.startDiscovered()
                    
                    if self.currentStatus != .WIFI {
                        
                        self.currentStatus = .WIFI
                        netStatus(.WIFI)
                    }
                    Print("连接的是 Wi-Fi")
                }
            } else {
                
                AmazonFlingMananger.mananger.stopDiscovered()
                if self.currentStatus != .NoNet {
                    
                    self.currentStatus = .NoNet
                    netStatus(.NoNet)
                }
                
            }
        }
                
        monitor.start(queue: queue)
    }
    
    func stop() {
        
        monitor.cancel()
    }
    
}
