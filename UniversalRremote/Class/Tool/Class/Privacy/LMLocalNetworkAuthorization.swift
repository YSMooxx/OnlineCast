//
//  LMLocalNetworkAuthorization.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/8.
//

import Network

@available(iOS 14.0, *)
@objcMembers open class LMLocalNetworkAuthorization: NSObject{
    
    static let mananger:LMLocalNetworkAuthorization = LMLocalNetworkAuthorization()
    
    private var browser: NWBrowser?
    private var netService: NetService?
    private var completion: ((Bool) -> Void) = {x in}
    var getTime:TimeInterval?
    var currentStatus:Bool? {
        
        didSet {

            NotificationCenter.default.post(name:  Notification.Name("LocalNetwork_Change"), object: nil, userInfo: ["status":currentStatus ?? false])
        }
    }
    
    open func requestAuthorization(completion: @escaping (Bool) -> Void) {
        self.completion = completion
        
        // Create parameters, and allow browsing over peer-to-peer link.
        let parameters = NWParameters()
        parameters.includePeerToPeer = true
        
      if(nil == self.browser){
        let browser = NWBrowser(for: .bonjour(type: "_what._tcp", domain: nil), using: parameters)
        self.browser = browser
      }
        // Browse for a custom service type.
      self.browser?.stateUpdateHandler = { newState in
            switch newState {
            case .failed(let error):
                Print(error.localizedDescription)
            case .ready, .cancelled:
                break
            case let .waiting(error):
                Print("Local network permission has been denied: \(error)")
                self.reset()
                
                if self.currentStatus != false {
                    
                    self.completion(false)
                }
            default:
                break
            }
        }
      if(nil == self.netService){
        self.netService = NetService(domain: "local.", type:"_lnp._tcp.", name: "LocalNetworkPrivacy", port: 1100)
      }
        self.netService?.delegate = self
        self.netService?.schedule(in: .current, forMode: .common)
        self.netService?.publish()
        self.browser?.start(queue: .main)
        getTime = getNowTimeInterval()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {[weak self] in
            
            if (self?.getTime ?? 0) + 5 < getNowTimeInterval() {
                
                if self?.getTime != nil {
                    
                    if self?.currentStatus != false {
                        
                        self?.completion(false)
                    }
                    self?.getTime = nil
                }
            }
        })
    }
    
    private func reset() {
        self.browser?.cancel()
        self.browser = nil
        self.netService?.stop()
        self.netService?.delegate = nil
        self.netService = nil
    }
}

@available(iOS 14.0, *)
extension LMLocalNetworkAuthorization : NetServiceDelegate {
    public func netServiceDidPublish(_ sender: NetService) {
        self.reset()
        Print("Local network permission has been granted")
        self.getTime = nil
        
        if self.currentStatus != true {
            
            self.completion(true)
        }

    }
}

