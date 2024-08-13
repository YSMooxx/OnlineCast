//
//  FireChannelMananger.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/13.
//



class FireChannelResultListDataModel:BaseModel,Codable {
    
    var appId:String?
    var name:String?
    var iconArtSmallUri:String?
    var isCollect:Bool?
    
    enum CodingKeys: String, CodingKey{
        case appId,name,iconArtSmallUri,isCollect
    }
}

class FireChannelMananger {
    
    static let mananger:FireChannelMananger = FireChannelMananger()
    
    static let CollectFireChannelArrayKey:String = "CollectFireChannelArray"
    
    lazy var collectionArray:[FireChannelResultListDataModel] = getCollectionArray() {
        
        didSet {
            
            NotificationCenter.default.post(name:  Notification.Name("collection_Fire_channgeArray"), object: nil, userInfo:nil)
        }
    }
    
    func getCollectionArray() -> [FireChannelResultListDataModel] {
        
        let defaults = UserDefaults.standard
        var modelArray:[FireChannelResultListDataModel] = []
        
        if defaults.data(forKey: FireChannelMananger.CollectFireChannelArrayKey) == nil {
            
            return []
        }else {
            
            do {
                
                let allowedClasses: [AnyClass] = [NSArray.self, NSData.self]
                // 从存储的数据中解码数组
                if let myArray = try NSKeyedUnarchiver.unarchivedObject(ofClasses: allowedClasses, from: defaults.data(forKey: FireChannelMananger.CollectFireChannelArrayKey) ?? Data()) as? [Any] {
                    // 在这里使用 myArray
                    // 在这里使用 myArray
                    
                    for data1 in myArray {
                        
                        do {
                            
                            let decoder = JSONDecoder()
                            
                            guard let data = data1 as? Data else { break }
                            
                            let user = try decoder.decode(FireChannelResultListDataModel.self, from: data )
                            
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
    
    func addChannelArray(channel:FireChannelResultListDataModel) {
        
        
        self.collectionArray.insert(channel, at: 0)
        self.collectionArray = self.collectionArray
        var channleArray:[Any] = []
        
        for smodel in self.collectionArray {
            
            let data0 = try? JSONEncoder().encode(smodel)
            channleArray.append(data0 ?? Data())
        }
        
        do {
            
            let data = try NSKeyedArchiver.archivedData(withRootObject: channleArray, requiringSecureCoding: false)
            UserDef.saveKeyWithValue(key: FireChannelMananger.CollectFireChannelArrayKey, value: data)
        }catch {
            
            
        }
    }
    
    func removeDeivce(channels:[FireChannelResultListDataModel]) {
        
        self.collectionArray = channels
        var channleArray:[Any] = []
        
        for smodel in channels {
            
            let data0 = try? JSONEncoder().encode(smodel)
            channleArray.append(data0 ?? Data())
        }
        
        do {
            
            let data = try NSKeyedArchiver.archivedData(withRootObject: channleArray, requiringSecureCoding: false)
            UserDef.saveKeyWithValue(key: FireChannelMananger.CollectFireChannelArrayKey, value: data)
        }catch {
            
            
        }
        
    }
}
