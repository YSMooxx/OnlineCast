//
//  RemoteDMananger.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/7.
//

let defatulRemoteDArrayKey:String = "defatulRemoteDArray"

class RemoteDMananger {
    
    static let mananger:RemoteDMananger = RemoteDMananger()
    
    lazy var deviceArray:[Device] = getDefaulDeviceArray() {
        
        didSet {
            
            saveAllDeive()
            NotificationCenter.default.post(name:  Notification.Name("Control_currentDev_Change"), object: nil, userInfo:nil)
        }
    }
    
    func getDefaulDeviceArray() -> [Device]{
        
        let defaults = UserDefaults.standard
        var modelArray:[Device] = []
        
        if defaults.data(forKey: defatulRemoteDArrayKey) == nil {
            
            return modelArray
            
        }else {
            
            do {
                
                let allowedClasses: [AnyClass] = [NSArray.self, NSData.self]
                    // 从存储的数据中解码数组
                if let myArray = try NSKeyedUnarchiver.unarchivedObject(ofClasses: allowedClasses, from: defaults.data(forKey: defatulRemoteDArrayKey) ?? Data()) as? [Any] {
                            // 在这里使用 myArray
                        // 在这里使用 myArray
                        
                    for data1 in myArray {
                    
                        do {
                            
                            let decoder = JSONDecoder()
                            
                            guard let data = data1 as? Data else { break }
                            
                            let user = try decoder.decode(Device.self, from: data )
                            var deivce:Device?
                            
                            if user.type == Roku {
                                
                                deivce = RokuDevice(url: user.url, ip: user.ip)

                            }else if user.type == Fire {
                                
                                deivce = FireDevice(url: user.url, ip: user.ip)

                            }else if user.type == WebOS {
                                
                                deivce = WebOSDevice(url: user.url, ip: user.ip)
                            }
                            
                            deivce?.reName = user.reName
                            deivce?.friendlyName = user.friendlyName
                            deivce?.url = user.url
                            deivce?.ip = user.ip
                            deivce?.type = user.type
                            deivce?.port = user.port
                            deivce?.UDN = user.UDN
                            deivce?.token = user.token
                            
                            guard let cDevice = deivce else {break}
                            
                            modelArray.append(cDevice)
                            
                        }catch {
                            
                            break
                        }
                    }
                    
                    return modelArray
                    
                } else {
                    return []
                }
            } catch {
                // 处理错误
                return []
            }
        }
        
    }
    
    func addDeviceArray(device:Device) {
        
        device.reName = device.friendlyName
        self.deviceArray.insert(device, at: 0)
        self.deviceArray = self.deviceArray
    }
    
    func tokenChannge(device:Device?) {
        
        self.deviceArray = self.deviceArray
    }
    
    func removeDeivce(devices:[Device]) {
        
        self.deviceArray = devices
    }
    
    func renameDevice(name:String,index:Int) {

        if index < self.deviceArray.count {
            
            let smodel = self.deviceArray[index]
            
            smodel.reName = name
        }
        
        self.deviceArray = self.deviceArray
    }
    
    func changeDeviceIndex(index:Int) {
        
        if index < self.deviceArray.count {
            
            let device = self.deviceArray.remove(at: index)
            
            self.deviceArray.insert(device, at: 0)
            
            self.deviceArray = self.deviceArray
        }
    }
    
    func saveAllDeive() {
        
        var DeviceArray:[Any] = []
        
        for smodel in self.deviceArray {
            
            let data0 = try? JSONEncoder().encode(smodel)
            DeviceArray.append(data0 ?? Data())
        }
        
        do {
            
            let data = try NSKeyedArchiver.archivedData(withRootObject: DeviceArray, requiringSecureCoding: false)
            UserDef.saveKeyWithValue(key: defatulRemoteDArrayKey, value: data)
        }catch {
            
            
        }
        
    }
    
}
