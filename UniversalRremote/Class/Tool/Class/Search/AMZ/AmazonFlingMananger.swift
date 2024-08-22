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
    var fireDevArray:[RemoteMediaPlayer] = []
    var disvoceDeviceCallBack:(_ device:AmazonFlingDevice) -> () = {device in}
    
    var mController:DiscoveryController?
    
    func startDiscovered() {
        
        stopDiscovered()
        
        guard let vc = mController else {
            mController = DiscoveryController()
            mController?.searchPlayer(withId: AmazonFlingMananger.searchID, andListener: self);
            mController?.resume()
        return }
        
        vc.resume()
    }
    
    func stopDiscovered() {
        
        guard let vc = mController else { return }
        
        vc.close()
    }
    
    func castIndex(Index:Int,url:String) {
        
        if Index < fireDevArray.count {
            
            let sdevice:RemoteMediaPlayer = fireDevArray[Index]
            
            sdevice.setMediaSourceToURL(url, metaData: url, autoPlay: true, andPlayInBackground: false)
        }
    }
    
    func getName(Index:Int) -> String {
        
        if Index < fireDevArray.count {
            
            let sdevice:RemoteMediaPlayer = fireDevArray[Index]
            
            return String(describing: sdevice.name()!)
        }else {
            
            return "no Device"
        }
    }
}

extension AmazonFlingMananger:DiscoveryListener {
    
    func deviceDiscovered(_ device: (any RemoteMediaPlayer)!) {
        Print("AmazonFlingMananger-----------name\(String(describing: device.name()))")
        Print("AmazonFlingMananger-----------uniqueIdentifier\(String(describing: device.uniqueIdentifier()))")
        
        let uuid:String = device.uniqueIdentifier() as String
        
        var isHaveFire:Bool = false
        for sdevice in fireDevArray {
            
            let suuid:String = sdevice.uniqueIdentifier() as String
            if uuid == suuid {
                
                isHaveFire = true
            }
        }
        
        if !isHaveFire {
            
            fireDevArray.append(device)
        }
        
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

