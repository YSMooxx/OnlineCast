import Foundation
import Socket

// MARK: Protocols


let RokuTag:String = "roku:ecp"
let AllTag:String = "urn:dial-multiscreen-org:service:dial:1"
let OtherTag:String = "urn:schemas-upnp-org:service:AVTransport:1"

/// Delegate for service discovery
public protocol SSDPDiscoveryDelegate {
    /// Tells the delegate a requested service has been discovered.
    func ssdpDiscovery(_ discovery: SSDPDiscovery, didDiscoverService service: SSDPService)

    /// Tells the delegate that the discovery ended due to an error.
    func ssdpDiscovery(_ discovery: SSDPDiscovery, didFinishWithError error: Error)

    /// Tells the delegate that the discovery has started.
    func ssdpDiscoveryDidStart(_ discovery: SSDPDiscovery)

    /// Tells the delegate that the discovery has finished.
    func ssdpDiscoveryDidFinish(_ discovery: SSDPDiscovery)
}

public extension SSDPDiscoveryDelegate {
    func ssdpDiscovery(_ discovery: SSDPDiscovery, didDiscoverService service: SSDPService) {}

    func ssdpDiscovery(_ discovery: SSDPDiscovery, didFinishWithError error: Error) {}

    func ssdpDiscoveryDidStart(_ discovery: SSDPDiscovery) {}

    func ssdpDiscoveryDidFinish(_ discovery: SSDPDiscovery) {}
}

/// SSDP discovery for UPnP devices on the LAN
public class SSDPDiscovery {

    static let shared:SSDPDiscovery = SSDPDiscovery()
    
    /// The UDP socket
    private var socket: Socket?

    /// Delegate for service discovery
    public var delegate: SSDPDiscoveryDelegate?
    
    var discoveryDeviceArray:[SSDPService] = []
    
    var isLoading:Bool = false
    
    var timer: Timer?

    /// The client is discovering
    public var isDiscovering: Bool {
        get {
            return self.socket != nil
        }
    }

    // MARK: Initialisation

    public init() {
        
    }

    deinit {
        self.stop()
    }

    // MARK: Private functions

    /// Read responses.
    private func readResponses() {
        do {
            var data = Data()
            
            guard let scokect = self.socket else {self.stop(); return}
            let (bytesRead, address) = try scokect.readDatagram(into: &data)

            if bytesRead > 0 {
                let response = String(data: data, encoding: .utf8)
                let (remoteHost, _) = Socket.hostnameAndPort(from: address!)!
                let dev:SSDPService = SSDPService(host: remoteHost, response: response!)
                
                if !self.discoveryDeviceArray.contains(where: { $0.uniqueServiceName == dev.uniqueServiceName }) {

                    self.discoveryDeviceArray.append(dev)
                    self.delegate?.ssdpDiscovery(self, didDiscoverService: dev)
                }
            }

        } catch _ {
            
            self.stop()
//            self.delegate?.ssdpDiscovery(self, didFinishWithError: error)
        }
    }

    /// Read responses with timeout.
    private func readResponses(forDuration duration: TimeInterval) {
        
            
        let queue = DispatchQueue.global()

        
        queue.async() {
            while self.isDiscovering {
                self.readResponses()
            }
        }
        
//        queue.asyncAfter(deadline: .now() + duration) { [weak self] in
//            self?.stop()
//        }
    }
    
    @objc func requestTimedOut() {
            // 处理请求超时的逻辑
        Print("Request timed out")
        
        // 取消请求
        
        stop()
        // 提示用户或重试请求
    }
    

    /// Force stop discovery closing the socket.
//    private func forceStop() {
//        if self.isDiscovering {
//
//            self.socket?.close()
//            self.isLoading = false
//        }
//        self.socket = nil
//    }

    // MARK: Public functions

    /**
        Discover SSDP services for a duration.
        - Parameters:
            - duration: The amount of time to wait.
            - searchTarget: The type of the searched service.
    */
    
    var startTime:TimeInterval?
    
    open func discoverService(forDuration duration: TimeInterval = 10, searchTarget: String = "ssdp:all", port: Int32 = 1900) {
        
        AmazonFlingMananger.mananger.startDiscovered()
        
//        self.delegate?.ssdpDiscoveryDidStart(self)

//        logEvent(eventId: roku_ios_search_device)
        
        let message = "M-SEARCH * HTTP/1.1\r\n" +
            "MAN: \"ssdp:discover\"\r\n" +
            "HOST: 239.255.255.250:\(port)\r\n" +
            "ST: \(searchTarget)\r\n" +
            "MX: \(Int(duration))\r\n\r\n"
        
        if timer == nil && isLoading == false {
            
            self.isLoading = true
            self.startTime = getNowTimeInterval()
            
            DispatchQueue.main.async {[weak self] in
                
                guard let self else {return}
                
                self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {[weak self] timer in
                    
                    guard let self else {return}
                    
                    if (self.startTime ?? 0) + duration < getNowTimeInterval() {
                        
                        self.stop()
                    }
                }
            }
        }

        do {
            
            self.socket = try Socket.create(type: .datagram, proto: .udp)
            try self.socket!.listen(on: 0)

            self.readResponses(forDuration: duration)

            try self.socket?.write(from: message, to: Socket.createAddress(for: "239.255.255.250", on: port)!)

        } catch _ {
            
            self.stop()
        }
    }

    /// Stop the discovery before the timeout.
    open func stop() {
        
        AmazonFlingMananger.mananger.stopDiscovered()
        self.discoveryDeviceArray = []
        timer?.invalidate()
        timer = nil
        
        if isLoading == true {
            
            guard let cscoket = socket else { return }
            
            cscoket.close()
            
            socket = nil
            
            self.delegate?.ssdpDiscoveryDidFinish(self)
            
            self.startTime = nil
            
        }
        
        self.isLoading = false
    
    }
}

