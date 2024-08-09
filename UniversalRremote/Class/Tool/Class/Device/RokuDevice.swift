//
//  RokuDevice.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/8.
//

import Foundation
import Alamofire

class RokuDevice: Device {
    
    enum RokuEventKey:String {
        case Home = "home"
        case Rev = "rev"
        case Fwd = "fwd"
        case Play = "play"
        case Select = "select"
        case Left = "left"
        case Right = "right"
        case Down = "down"
        case Up = "up"
        case Back = "back"
        case Replay = "instantReplay"
        case Info = "info"
        case Backspace = "backspace"
        case Search = "search"
        case Enter = "Enter"
        case PowerOff = "PowerOff"
        case PowerOn = "PowerOn"
        case volumeUp = "VolumeUp"
        case VolumeDown = "VolumeDown"
        case VolumeMute = "VolumeMute"
    }
    
    enum CodingKeys: String, CodingKey{
        case friendlyName,UDN,url,ip,type,reName
    }
    
    override init(url: String, ip: String) {
        
        super.init(url: url, ip: ip)
        
        self.type = Roku
    }
    
    required init(from decoder: any Decoder) throws {
        try super.init(from: decoder)
    }
    
    let httpHeader:String = "http://"
    
    lazy var sessionManager:Session =  {
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 5
        
        return Session(configuration: configuration)
        
    }()
    
    func connectDevice(suc:@escaping callBack = {text in}) {
        
        guard let url = URL(string: httpHeader + self.ip + ":" + port + "/query/device-info") else { return  }
        
        sessionManager.request(url, method: HTTPMethod.get).responseString { response in
            
            switch response.result {
                case .success(_):
                suc(Load_suc)
                case .failure(_):
                
                suc(Load_fail)
            }
        }
    }
    
    /*
    override func getIcon(suc:@escaping () -> Void = { }) {
        
        guard let url = URL(string: self.iconUrl) else { return }
        
        AF.request(url).responseData(completionHandler: {response in
            
            switch response.result {
            case .success(let data):
                self.icon = UIImage(data: data) ?? UIImage()
                suc()
            case .failure(let error):
                Print(error)
            }
        })
    }
    
    override func sendKeyEvent(key: String) {
        
        if key == DevHome {
            
            sendKey(key: RokuEventKey.Home.rawValue)
        } else if key == DevRev {
            
            sendKey(key: RokuEventKey.Rev.rawValue)
        }else if key == DevFwd {
            
            sendKey(key: RokuEventKey.Fwd.rawValue)
        }else if key == DevPlay {
            
            sendKey(key: RokuEventKey.Play.rawValue)
        }else if key == DevSelect {
            
            sendKey(key: RokuEventKey.Select.rawValue)
        }else if key == DevLeft {
            
            sendKey(key: RokuEventKey.Left.rawValue)
        }else if key == DevRight {
            
            sendKey(key: RokuEventKey.Right.rawValue)
        }else if key == DevDown {
            
            sendKey(key: RokuEventKey.Down.rawValue)
        }else if key == DevUp{
            
            sendKey(key: RokuEventKey.Up.rawValue)
        }else if key == DevBack {
            
            sendKey(key: RokuEventKey.Back.rawValue)
        }else if key == DevReplay {
            
            sendKey(key: RokuEventKey.Replay.rawValue)
        }else if key == DevInfo {
            
            sendKey(key: RokuEventKey.Info.rawValue)
        }else if key == DevBackspace {
            
            sendKey(key: RokuEventKey.Backspace.rawValue)
        }else if key == DevSearch {
            
            sendKey(key: RokuEventKey.Search.rawValue)
        }else if key == DevEnter {
            
            sendKey(key: RokuEventKey.Enter.rawValue)
        }else if key == DevPowerOff {
            
            sendKey(key: RokuEventKey.PowerOff.rawValue)
        }else if key == DevPowerOn {
            
            sendKey(key: RokuEventKey.PowerOn.rawValue)
        }else if key == DevVolumeUp {
            
            sendKey(key: RokuEventKey.volumeUp.rawValue)
        }else if key == DevVolumeMute {
            
            sendKey(key: RokuEventKey.VolumeMute.rawValue)
        }else if key == DevVolumeDown {
            
            sendKey(key: RokuEventKey.VolumeDown.rawValue)
        }
    }
    
    func sendKey(key:String) {
        
        guard let url = URL(string: self.url + "keypress/" + key) else { return }
        
        connectDevice {(text) in
            
            if text == "suc" {
                
                AF.request(url, method: HTTPMethod.post).responseData {response in
                    
                    switch response.result {
                        
                    case .success(_): break
                    case .failure(_): break
                    }
                }
            }
        }
        
    }
    
    override func castImage(ip: String) {
        
        let ipS = urlencode(ip)
        guard let url = URL(string: (url) + "input/15985?t=p&h=a&u=\(ipS)") else { return }
        
        connectDevice {(text) in
            
            if text == "suc" {
                
                AF.request(url, method: HTTPMethod.post).responseString { response in
                    
                    switch response.result {
                    case .success(let suc):
                        Print(suc)
                    case .failure(let error):
                        
                        if let afError = error.asAFError {
                            switch afError {
                            case .responseSerializationFailed(let reason):
                                switch reason {
                                case .inputDataNilOrZeroLength:
                                    logEvent(eventId: roku_ios_start_cast_photo_success,param: ["device_version":getDeviceIdentifier() + "V" + getVersion()])
                                    logEvent(eventId: roku_ios_start_cast_photo,param: ["photo_cast_status":"success"])
                                    
                                    ScoreMananger.shard.castCount += 1
                                    ScoreMananger.shard.type = "cast"
                                    if !ScoreMananger.shard.chcektStatus() {
                                        
                                        if castPhotoShow {
                                            
                                            castPhotoShow = false
                                            ADInterstitialManager.shard.checkStatus(model: castPhotoInterstitialModel)
                                        }
                                        
                                    }
                                    
                                default:
                                    logEvent(eventId: roku_ios_start_cast_photo_failed,param: ["device_version":getDeviceIdentifier() + "V" + getVersion()])
                                    logEvent(eventId: roku_ios_start_cast_photo,param: ["photo_cast_status":"failed"])
                                }
                            default:
                                logEvent(eventId: roku_ios_start_cast_photo_failed,param: ["device_version":getDeviceIdentifier() + "V" + getVersion()])
                                logEvent(eventId: roku_ios_start_cast_photo,param: ["photo_cast_status":"failed"])
                            }
                        } else {
                            logEvent(eventId: roku_ios_start_cast_photo_failed,param: ["device_version":getDeviceIdentifier() + "V" + getVersion()])
                            logEvent(eventId: roku_ios_start_cast_photo,param: ["photo_cast_status":"failed"])
                        }
                        
                    }
                }
            }
        }
        
    }
    
    override func castVideo(ip: String,suc:@escaping callBack = {text in}) {
        
        let ipS = urlencode(ip)
        guard let url = URL(string: (url) + "input/15985?t=v&h=a&u=\(ipS)&k=http%3A%2F%2Fdevelopers%2Egoogle%2Ecom%2Fcast%2Fimages%2Faudio%5Fvideo%5Flp%2Epng&videoFormat=mp4") else { return }
        
        connectDevice {text in
            
            if text == "suc" {
                
                AF.request(url, method: HTTPMethod.post).responseString { response in
                    
                    switch response.result {
                    case .success(let suc):
                        Print(suc)
                    case .failure(let error):
                        
                        if let afError = error.asAFError {
                            switch afError {
                            case .responseSerializationFailed(let reason):
                                switch reason {
                                case .inputDataNilOrZeroLength:
                                    logEvent(eventId: roku_ios_start_cast_video_success,param: ["device_version":getDeviceIdentifier() + "V" + getVersion()])
                                    logEvent(eventId: roku_ios_start_cast_video,param: ["photo_cast_status":"success"])
                                    ScoreMananger.shard.castCount += 1
                                    ScoreMananger.shard.type = "cast"
                                    if !ScoreMananger.shard.chcektStatus() {
                                        
                                        if castVideoShow {
                                         
                                            castVideoShow = false
                                            ADInterstitialManager.shard.checkStatus(model: castVideoInterstitialModel)
                                        }
                                        
                                    }
                                    suc(Load_Suc)
                                default:
                                    logEvent(eventId: roku_ios_start_cast_video_failed,param: ["device_version":getDeviceIdentifier() + "V" + getVersion()])
                                    logEvent(eventId: roku_ios_start_cast_video,param: ["photo_cast_status":"failed"])
                                }
                            default:
                                logEvent(eventId: roku_ios_start_cast_video_failed,param: ["device_version":getDeviceIdentifier() + "V" + getVersion()])
                                logEvent(eventId: roku_ios_start_cast_video,param: ["photo_cast_status":"failed"])
                            }
                        } else {
                            logEvent(eventId: roku_ios_start_cast_video_failed,param: ["device_version":getDeviceIdentifier() + "V" + getVersion()])
                            logEvent(eventId: roku_ios_start_cast_video,param: ["photo_cast_status":"failed"])
                        }
                        
                    }
                }
            }
        }
        
        
    }
    
    lazy var sessionManager:Session =  {
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 2
        
        return Session(configuration: configuration)
        
    }()
    
    override func connectDevice(suc:@escaping callBack = {text in}) {
        
        guard let url = URL(string: self.url + "query/device-info") else { return  }
        
        sessionManager.request(url, method: HTTPMethod.get).responseString { response in
            
            switch response.result {
                case .success(_):
                suc("suc")
                case .failure(_):
                
                if Control.mananger.currentDev != nil {
                    
                    Control.mananger.currentDev = nil
                }
                
                suc("fail")
            }
        }
    }
    
    override func searchWithString(content: String) {
        
        guard let url = URL(string: self.url + "keypress/" + "Lit_" + content) else { return }
        
        AF.request(url, method: HTTPMethod.post).responseString { response in
            
            switch response.result {
                case .success(_):break
                case .failure(_):break
            }
        }
    }
    
    override func changeChannel(id:String) {
        
        guard let url = URL(string: self.url + "launch/\(id)?contentID=xxx&MediaType=movie") else { return }
        
        AF.request(url, method: HTTPMethod.post).responseString { response in
            
            switch response.result {
                case .success(_):break
                case .failure(_):break
            }
        }
    }
    
    override func getALlChannel(suc: @escaping ([[String : Any]]) -> () = { arr in }) {
        
        guard let url = URL(string: self.url + "query/apps") else {suc([]); return }
        
        connectDevice {text in
            
            if text == "suc" {
                
                AF.request(url, method: HTTPMethod.get).responseString { response in
                    
                    switch response.result {
                        case .success(let xmlString):
                        
                        guard let dic =  NSDictionary.init(xmlString: xmlString) as? [String:Any] else {suc([]); return}
                        guard let apps = dic["app"] as? [[String:Any]] else {suc([]); return }
                        
                        
                        var array:[[String : Any]] = []
                        
                        for subString in apps {
                            
                            guard let name = subString["__text"] as? String,let id = subString["_id"] as? String else { break}
                            
                            let otherDic = ["id":id,"name":name,"imageUrl":(Control.mananger.currentDev?.url ?? "") + "query/icon/" + id]
                            
                            array.append(otherDic)
                        }
                        
                        suc(array)
                        
                        case .failure(_):
                        suc([])
                    }
                }
            }else {
                
                suc([])
            }
            
        }
        
    }
    
    func urlencode(_ string: String) -> String {
            let mstring = string.replacingOccurrences(of: " ", with: "+")
            let legalURLCharactersToBeEscaped: CFString = "!*'\"();:@&=+$,/?%#[]% " as CFString
            return CFURLCreateStringByAddingPercentEscapes(nil, mstring as CFString?, nil, legalURLCharactersToBeEscaped, CFStringBuiltInEncodings.UTF8.rawValue) as String
    }
    
    override func getCurrentTime(suc: @escaping (TimeInterval) -> () = { time in}) {
        
        guard let url = URL(string: self.url + "query/media-player") else { return}
        
        AF.request(url, method: HTTPMethod.get).responseString { response in
            
            switch response.result {
            case .success(let xmlString):
                guard let dic =  NSDictionary.init(xmlString: xmlString) as? [String:Any] else {return}
                guard let time = dic["position"] as? String else {return}
                let timeInt = time.replacingOccurrences(of: " ms", with: "")
                suc(TimeInterval(timeInt) ?? 0)
            case .failure(let error):
                Print("Error loading XML: \(error)")
            }
        }
    }
     */
}



