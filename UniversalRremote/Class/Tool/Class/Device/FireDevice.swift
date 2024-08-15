//
//  FireDevice.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/8.
//

import Foundation
import Alamofire

class FireDevice: Device {
    
    let headType:String = "https://"
    let headType2:String = "http://"
    
    override init(device: Device) {
        
        super.init(device: device)
    }
    
    enum FireEventKey:String {
        case Home = "home"
        case Select = "select"
        case Left = "dpad_left"
        case Right = "dpad_right"
        case Down = "dpad_down"
        case Up = "dpad_up"
        case Back = "back"
        case Replay = "instantReplay"
        case Info = "menu"
        case Backspace = "backspace"
//        case Search = "search"
//        case Enter = "Enter"
        case PowerOff = "sleep"
        case volumeUp = "volume_up"
        case VolumeDown = "volume_down"
        case VolumeMute = "mute"
    }
    
    lazy var session = {
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20 // 请求超时时间为30秒
        configuration.timeoutIntervalForResource = 60 // 资源超时时间为60秒
        
        let s = Session(configuration:configuration,serverTrustManager: CustomServerTrustManager(ip: self.ip))
        
        return s
    }()
    
    lazy var session2 = {
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10 // 请求超时时间为30秒
        configuration.timeoutIntervalForResource = 10 // 资源超时时间为60秒

        // 创建一个 Alamofire 的 Session
        let s = Session(configuration:configuration,serverTrustManager: CustomServerTrustManager(ip: self.ip))
        
        return s
    }()
    
    lazy var session3 = {
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30 // 请求超时时间为30秒
        configuration.timeoutIntervalForResource = 60 // 资源超时时间为60秒

        // 创建一个 Alamofire 的 Session
        let s = Session(configuration:configuration,serverTrustManager: CustomServerTrustManager(ip: self.ip))
        
        return session
    }()
    
    override init(url: String, ip: String) {
        
        super.init(url: url, ip: ip)
        
        self.type = Fire
    }
    
    required init(from decoder: any Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    func sendKey(key:String,suc:@escaping callBack = {text in}) {
            
        let port:String = "8080"
        let path:String = "/v1/FireTV?action=\(key)"
        
        guard let url = URL(string: headType + ip + ":" + port + path) else { return }
        
        let request = getRequest(isToken: true, url: url)
        
        session3.request(request)
            .validate()
            .response { response in
                switch response.result {
                case .success(let data):
                    if let data = data {
                        
                        do {
                            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                
                                guard let _ = jsonResponse["description"] as? String else {suc(Load_fail); return }
                                
                                suc(Load_suc)
                                
                            }else {
                                
                                suc(Load_fail)
                            }
                        }catch {
                            
                            suc(Load_fail)
                        }
                        
                    }
                case .failure(_):

                    suc(Load_fail)
                }
                
            }
    
    }
    
    func searchWithString(content: String) {
        
        let port:String = "8080"
        let path:String = "/v1/FireTV/text"
        
        let parameters:Parameters = ["text":content]
        
        guard let requestData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        
        guard let url = URL(string: headType + ip + ":" + port + path) else { return }
        
        let request = getRequest(isToken:true, url: url ,requestData: requestData)
        
        session.request(request)
            .validate()
            .response { response in
                switch response.result {
                case .success(_): break
                case .failure(_): break
                
                }
            }
    }
    
    func checkStatus(method:String = "POST",suc:@escaping callBack = {text in}) {
        
        let port:String = "8009"
        let path:String = "/apps/FireTVRemote"
        
        guard let url = URL(string: headType2 + ip + ":" + port + path) else { return }
        
        let request = getRequestHttp(httpMethod: method, url: url)
        
        session2.request(request)
            .validate()
            .response {[weak self] response in
                guard let self else { return }
                
                switch response.result {
                case .success(_):
                    suc(Load_suc)
                case .failure(_):
                    
                    if method == "POST" {
                        
                        self.checkStatus(method: "GET") { text in
                            suc(text)
                        }
                    }else {
                        
                        suc(Load_fail)
                    }
                }
            }
    }
         
    
    func showPin(suc:@escaping callBack = {text in}) {
        
        let port:String = "8080"
        let path:String = "/v1/FireTV/pin/display"
        
        guard let url = URL(string: self.headType + self.ip + ":" + port + path) else { return }

        let parameters:Parameters = ["friendlyName": self.friendlyName]
        
        guard let requestData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        
        let request = self.getRequest(url: url, requestData: requestData)
        
        self.session.request(request)
            .validate()
            .response { response in
                switch response.result {
                case .success(let data):
                    
                    if let data = data {
                        
                        do {
                            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                
                                guard let result = jsonResponse["description"] as? String else {suc("fail"); return }
                                
                                if result.containsSubstring(substring: "OK") {
                                    
                                    suc(Load_suc)
                                }else {
                                    
                                    self.tryAgin { text in
                                        
                                        suc(text)
                                    }
                                }
                                
                            }else {
                                
                                self.tryAgin { text in
                                    
                                    suc(text)
                                }
                            }
                        }catch {
                            
                            self.tryAgin { text in
                                
                                suc(text)
                            }
                        }
                    }
                    
                case .failure(_):
                    
                    self.tryAgin { text in
                        
                        suc(text)
                    }
                }
            }
    }
    
    func connectDevice(suc:@escaping callBack = {text in}) {
        
        let port:String = "8080"
        let path:String = "/v1/FireTV"
        
        guard let url = URL(string: headType + ip + ":" + port + path) else { return }
        
        let request = getRequest(httpMethod: "GET", isToken: true, url: url)
        
        self.session2.request(request)
            .validate()
            .response { response in
                
                switch response.result {
                case .success(let data):
                    if let data = data {
                        
                        do {
                            if let _ = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                
                                DispatchQueue.main.async {
                                    
                                    suc(Load_suc)
                                }
                                
                            }else {
                                
                                suc(Load_fail)
                                
                            }
                        }catch {
                            
                            suc(Load_fail)
                        }
                    }
                case .failure(_):
                    
                    suc(Load_fail)
                }
            }
        
    }
    
    func checkPin(pin: String, suc: @escaping callBack = {text in}) {
        
        let port:String = "8080"
        let path:String = "/v1/FireTV/pin/verify"
        
        let parameters:Parameters = ["pin":pin]
        
        guard let requestData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        
        guard let url = URL(string: headType + ip + ":" + port + path) else { return }
        
        let request = getRequest(url: url, requestData: requestData)
        
        session2.request(request)
            .validate()
            .response {[weak self] response in
                switch response.result {
                case .success(let data):
                    if let data = data {
                        
                        do {
                            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                
                                guard let result = jsonResponse["description"] as? String else { return }
                                
                                if result.count == 0 {
                                    
                                    suc(Load_error)
                                }else {
                                    
                                    suc(result)
                                }

                            }else {
                                
                                suc(Load_fail)
                            }
                        }catch {
                            
                            suc(Load_fail)
                        }
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    suc(Load_fail)
                }
            }
        
    }
    
    func getVoice(suc:@escaping (_ isVoice:Bool?) -> () = {isVoice in}) {
        
        let port:String = "8080"
        let path:String = "/v1/FireTV"
        
        guard let url = URL(string: headType + ip + ":" + port + path) else { return }
        
        let request = getRequest(httpMethod: "GET", isToken: true, url: url)
        
        session.request(request)
            .validate()
            .response { response in
                switch response.result {
                case .success(let data):
                    if let data = data {
                        
                        do {
                            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                
                                guard let isVolumeControlsSupported = jsonResponse["isVolumeControlsSupported"] as? Bool else {suc(false);return }
                                
                                suc(isVolumeControlsSupported)
                                
                            }else {
                                
                                suc(false)
                            }
                        }catch {
                            
                            suc(false)
                        }
                    }
                case .failure(let error):
                    
                    suc(nil)
                }
            }
    }
    
    var showpinFirst:Bool = true
    
    func tryAgin(suc:@escaping callBack = {text in}) {
        
        if self.showpinFirst {
            
            self.showpinFirst = false
            
            self.showPin(suc: {text in
                
                suc(text)
            })
        }else {
            
            self.showpinFirst = false
            suc(Load_fail)
        }
    }
    
    func getALlChannel(suc: @escaping ([[String : Any]]) -> () = { arr in }) {
        
        let port:String = "8080"
        let path:String = "/v1/FireTV/apps"
        
        guard let url = URL(string: headType + ip + ":" + port + path) else { return }
        
        let request = getRequest(httpMethod: "GET", isToken:true, url: url)
        
        session.request(request)
            .validate()
            .response { response in
                switch response.result {
                case .success(let data):
                    if let data = data {
                        
                        do {
                            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                                
                                suc(jsonResponse)
                                
                            }else {
                                
                                suc([])
                            }
                        }catch {
                            
                            suc([])
                        }
                    }
                case .failure(_):
                    suc([])
                }
            }
    }
    
    func changeChannel(id: String, suc: @escaping callBack = {text in}) {
        
        let port:String = "8080"
        let path:String = "/v1/FireTV/app/\(id)"
        
        guard let url = URL(string: headType + ip + ":" + port + path) else { return }
        
        let request = getRequest(httpMethod: "POST", isToken:true, url: url)
        
        session3.request(request)
            .validate()
            .response { response in
                switch response.result {
                case .success(let data):
                    if let data = data {
                        
                        do {
                            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                
                                guard let result = jsonResponse["description"] as? String else { return }
                                
                                if result.containsSubstring(substring: "ok") {
                                    
                                    suc(Load_suc)
                                }else {
                                    
                                    suc(Load_fail)
                                }
                                
                            }else {
                                suc(Load_fail)
                            }
                        }catch {
                            
                            suc(Load_fail)
                        }
                    }
                case .failure(_):
                    
                    suc(Load_fail)
                }
            }
        
    }
    
    func getRequestHttp(httpMethod:String = "POST",requestData:Data? = nil,isToken:Bool = false,url:URL) -> URLRequest {
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        
        if requestData != nil {
            request.httpBody = requestData
        }
        
        if isToken == true {
            request.setValue(self.token, forHTTPHeaderField: "token-device")
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
        
        return request
    }
    
    func getRequest(httpMethod:String = "POST",isToken:Bool = false,url:URL,requestData:Data? = nil) -> URLRequest {
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        
        if requestData != nil {
            request.httpBody = requestData
        }
        
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("0987654321", forHTTPHeaderField: "x-api-key")
        
        if isToken {
            
            request.setValue(self.token, forHTTPHeaderField: "x-client-token")
        }
        
        return request
    }
    
}


class CustomServerTrustManager: ServerTrustManager {
    init(ip:String) {
        let evaluators: [String: ServerTrustEvaluating] = [
            ip: DisabledTrustEvaluator()
        ]
        super.init(allHostsMustBeEvaluated: false, evaluators: evaluators)
    }

    override func serverTrustEvaluator(forHost host: String) throws -> ServerTrustEvaluating? {
        return evaluators[host] ?? DisabledTrustEvaluator()
    }
}
