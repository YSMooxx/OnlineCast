//
//  AmazonFlingMananger.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/6.
//

class AmazonFlingMananger:NSObject {
    
    static let mananger:AmazonFlingMananger = AmazonFlingMananger()
    static let searchID:String = "amzn.thin.pl"
    var device:[AmazonFlingDevice] = []
    var discoveryModelArray:[AmazonFlingDevice] = []
    var disvoceDeviceCallBack:(_ device:AmazonFlingDevice) -> () = {device in}
    
    var mController:DiscoveryController?
    
    func startDiscovered() {
        
//        stopDiscovered()
//        
//        guard let vc = mController else {
//            mController = DiscoveryController()
//            mController?.searchPlayer(withId: AmazonFlingMananger.searchID, andListener: self);
//            mController?.resume()
//        return }
//        
//        vc.resume()
    }
    
    func stopDiscovered() {
        
        guard let vc = mController else { return }
        
        vc.close()
    }
}

extension AmazonFlingMananger:DiscoveryListener {
    
    func deviceDiscovered(_ device: (any RemoteMediaPlayer)!) {
        Print("AmazonFlingMananger-----------name\(String(describing: device.name()))")
        Print("AmazonFlingMananger-----------uniqueIdentifier\(String(describing: device.uniqueIdentifier()))")
        
        let model:AmazonFlingDevice = AmazonFlingDevice()
        model.name = device.name() as String
        model.uuid = device.uniqueIdentifier() as String
        
        var isHave:Bool = false
        
        for device in self.discoveryModelArray {
            
            if device.uuid == model.uuid {
                
                isHave = true
            }
        }
        
        if !isHave {
            
            self.discoveryModelArray.append(model)
            disvoceDeviceCallBack(model)
        }
    }
    
    func deviceLost(_ device: (any RemoteMediaPlayer)!) {
//        Print("AmazonFlingMananger-----------Device\(device)")
    }
    
    func discoveryFailure() {
        
    }
    
    
}

class AmazonFlingDevice {
    
    var name:String?
    var uuid:String?
}

