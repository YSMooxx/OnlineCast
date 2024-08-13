//
//  RokuChannelMananger.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/12.
//

class RokuChannelResultListDataModel:BaseModel,Codable {
    
    var id:String?
    var name:String?
    var imageUrl:String?
    var imageName:String?
    var isCollect:Bool?
    var time:TimeInterval?
    
    enum CodingKeys: String, CodingKey{
        case id,name,imageUrl,imageName,isCollect,time
    }
}

class RokuChannelMananger {

    static let mananger:RokuChannelMananger = RokuChannelMananger()
    
    static let CollectRokuChannelArrayKey:String = "CollectRokuChannelArray"
    
    lazy var collectionArray:[RokuChannelResultListDataModel] = getCollectionArray() {
        
        didSet {
            
            NotificationCenter.default.post(name:  Notification.Name("collection_channgeArray"), object: nil, userInfo:nil)
        }
    }
    
    func getCollectionArray() -> [RokuChannelResultListDataModel] {
        
        let defaults = UserDefaults.standard
        var modelArray:[RokuChannelResultListDataModel] = []
        
        if defaults.data(forKey: RokuChannelMananger.CollectRokuChannelArrayKey) == nil {
            
            return []
        }else {
            
            do {
                
                let allowedClasses: [AnyClass] = [NSArray.self, NSData.self]
                // 从存储的数据中解码数组
                if let myArray = try NSKeyedUnarchiver.unarchivedObject(ofClasses: allowedClasses, from: defaults.data(forKey: RokuChannelMananger.CollectRokuChannelArrayKey) ?? Data()) as? [Any] {
                    // 在这里使用 myArray
                    // 在这里使用 myArray
                    
                    for data1 in myArray {
                        
                        do {
                            
                            let decoder = JSONDecoder()
                            
                            guard let data = data1 as? Data else { break }
                            
                            let user = try decoder.decode(RokuChannelResultListDataModel.self, from: data )
                            
                            modelArray.append(user)
                            
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
    
    func addChannelArray(channel:RokuChannelResultListDataModel) {
        
        
        self.collectionArray.insert(channel, at: 0)
        self.collectionArray = self.collectionArray
        var channleArray:[Any] = []
        
        for smodel in self.collectionArray {
            
            let data0 = try? JSONEncoder().encode(smodel)
            channleArray.append(data0 ?? Data())
        }
        
        do {
            
            let data = try NSKeyedArchiver.archivedData(withRootObject: channleArray, requiringSecureCoding: false)
            UserDef.saveKeyWithValue(key: RokuChannelMananger.CollectRokuChannelArrayKey, value: data)
        }catch {
            
            
        }
    }
    
    func removeDeivce(channels:[RokuChannelResultListDataModel]) {
        
        self.collectionArray = channels
        var channleArray:[Any] = []
        
        for smodel in channels {
            
            let data0 = try? JSONEncoder().encode(smodel)
            channleArray.append(data0 ?? Data())
        }
        
        do {
            
            let data = try NSKeyedArchiver.archivedData(withRootObject: channleArray, requiringSecureCoding: false)
            UserDef.saveKeyWithValue(key: RokuChannelMananger.CollectRokuChannelArrayKey, value: data)
        }catch {
            
            
        }
        
    }
}
