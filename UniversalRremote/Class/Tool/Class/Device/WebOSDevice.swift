//
//  WebOSDevice.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/8.
//

import Foundation
import WebOSClient

class WebOSDevice: Device {
        
    enum statusType {
        case didConnect
        case didDisconnect
        case didDisplayPin
        case didRegister
        case pinError
        case pinCancel
        case error
    }
    
    enum WebOSEventKey:String {
        
        case Home = "Home"
        case Enter = "Enter"
        case Click = "Click"
        case Left = "Left"
        case Right = "Right"
        case Down = "Down"
        case Up = "Up"
        case Back = "Back"
        case Menu = "Menu"
        case Info = "Info"
        case VolumeUp = "VolumeUp"
        case VolumeDown = "VolumeDown"
        case Mute = "Mute"
        case Exit = "Exit"
        case Rewind = "rewind"
        case FastForward = "FastForward"
        case Play = "Play"
        case Pause = "Pause"
        case ChannelUp = "ChannelUp"
        case ChannelDown = "ChannelDown"
        case Num1 = "Num1"
        case Num2 = "Num2"
        case Num3 = "Num3"
        case Num4 = "Num4"
        case Num5 = "Num5"
        case Num6 = "Num6"
        case Num7 = "Num7"
        case Num8 = "Num8"
        case Num9 = "Num9"
        case Num0 = "Num0"
        case ListApps = "ListApps"
        case LiveTV = "LiveTV"
        case Red = "Red"
        case Green = "Green"
        case Yellow = "Yellow"
        case Blue = "Blue"
        case Search = "Search"
        case Input = "Input"
        case Setting = "Setting"
        case Guide = "Guide"
    }
        // The client responsible for communication with the WebOS service.
    var client: WebOSClientProtocol?
    
    var isShowPin:Bool = false
    
    var callBackStatus:(_ status:statusType,_ content:String) -> () = {status,content in}
    
    var hdmideviceCallBack:(_ array:[WebOSHDMIListModel]) -> () = {array in}
    
    override init(device: Device) {
        
        super.init(device: device)
    }
    
    override class func copy() -> Any {
        
        super.copy()
    }
    
    override init(url: String, ip: String) {
        
        super.init(url: url, ip: ip)
        
        self.type = WebOS
    }
    
    required init(from decoder: any Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    func disconnect() {
        
        client?.disconnect()
    }
    
    func connectDevice() {
        
        guard let url = URL(string: "wss://" + self.ip + ":3001") else {return}
        
        if client == nil {
            
            client = WebOSClient(url: url, delegate: self, shouldLogActivity: true)
        }
        
        isShowPin = false
        
        client?.connect()
                
        // Send a registration request to the TV with the stored or nil registration token.
        // The PairingType option should be set to .pin for PIN-based pairing. The default value is .prompt.
    }
    
    func sendKey(key:String) {
        
        if key == WebOSDevice.WebOSEventKey.Home.rawValue {
            
            client?.sendKey(.home)
        }else if key == WebOSDevice.WebOSEventKey.Enter.rawValue {
            
            client?.sendKey(.enter)
        }else if key == WebOSDevice.WebOSEventKey.Click.rawValue {
            
            client?.sendKey(.click)
        }else if key == WebOSDevice.WebOSEventKey.Up.rawValue {
            
            client?.sendKey(.up)
        }else if key == WebOSDevice.WebOSEventKey.Down.rawValue {
            
            client?.sendKey(.down)
        }else if key == WebOSDevice.WebOSEventKey.Left.rawValue {
            
            client?.sendKey(.left)
        }else if key == WebOSDevice.WebOSEventKey.Right.rawValue {
            
            client?.sendKey(.right)
        }else if key == WebOSDevice.WebOSEventKey.Back.rawValue {
            
            client?.sendKey(.back)
        }else if key == WebOSDevice.WebOSEventKey.Menu.rawValue {
            
            client?.sendKey(.menu)
        }else if key == WebOSDevice.WebOSEventKey.Info.rawValue {
            
            client?.sendKey(.info)
        }else if key == WebOSDevice.WebOSEventKey.VolumeUp.rawValue {
            
            client?.sendKey(.volumeUp)
        }else if key == WebOSDevice.WebOSEventKey.VolumeDown.rawValue {
            
            client?.sendKey(.volumeDown)
        }else if key == WebOSDevice.WebOSEventKey.Mute.rawValue {
            
            client?.sendKey(.mute)
        }else if key == WebOSDevice.WebOSEventKey.Menu.rawValue {
            
            client?.sendKey(.menu)   
        }else if key == WebOSDevice.WebOSEventKey.Exit.rawValue {
            
            client?.sendKey(.exit)
        }else if key == WebOSDevice.WebOSEventKey.Rewind.rawValue {
            
            client?.sendKey(.rewind)
        }else if key == WebOSDevice.WebOSEventKey.FastForward.rawValue {
            
            client?.sendKey(.fastForward)
        }else if key == WebOSDevice.WebOSEventKey.Play.rawValue {
            
            client?.sendKey(.play)
        }else if key == WebOSDevice.WebOSEventKey.Pause.rawValue {
            
            client?.sendKey(.pause)
        }else if key == WebOSDevice.WebOSEventKey.ChannelUp.rawValue {
            
            client?.sendKey(.channelUp)
        }else if key == WebOSDevice.WebOSEventKey.ChannelDown.rawValue {
            
            client?.sendKey(.channelDown)
        }else if key == WebOSDevice.WebOSEventKey.Num1.rawValue {
            
            client?.sendKey(.num1)
        }else if key == WebOSDevice.WebOSEventKey.Num2.rawValue {
            
            client?.sendKey(.num2)
        }else if key == WebOSDevice.WebOSEventKey.Num3.rawValue {
            
            client?.sendKey(.num3)
        }else if key == WebOSDevice.WebOSEventKey.Num4.rawValue {
            
            client?.sendKey(.num4)
        }else if key == WebOSDevice.WebOSEventKey.Num5.rawValue {
            
            client?.sendKey(.num5)
        }else if key == WebOSDevice.WebOSEventKey.Num5.rawValue {
            
            client?.sendKey(.num6)
        }else if key == WebOSDevice.WebOSEventKey.Num6.rawValue {
            
            client?.sendKey(.num6)
        }else if key == WebOSDevice.WebOSEventKey.Num7.rawValue {
            
            client?.sendKey(.num7)
        }else if key == WebOSDevice.WebOSEventKey.Num8.rawValue {
            
            client?.sendKey(.num8)
        }else if key == WebOSDevice.WebOSEventKey.Num9.rawValue {
            
            client?.sendKey(.num9)
        }else if key == WebOSDevice.WebOSEventKey.Num0.rawValue {
            
            client?.sendKey(.num0)
        }else if key == WebOSDevice.WebOSEventKey.ListApps.rawValue {
            
            client?.send(.launchApp(appId: "com.webos.app.livemenu"))
        }else if key == WebOSDevice.WebOSEventKey.LiveTV.rawValue {
            
            client?.send(.launchApp(appId: "com.webos.app.livetv"))
        }else if key == WebOSDevice.WebOSEventKey.Red.rawValue {
            
            client?.sendKey(.red)
        }else if key == WebOSDevice.WebOSEventKey.Green.rawValue {
            
            client?.sendKey(.green)
        }else if key == WebOSDevice.WebOSEventKey.Yellow.rawValue {
            
            client?.sendKey(.yellow)
        }else if key == WebOSDevice.WebOSEventKey.Blue.rawValue {
            
            client?.sendKey(.blue)
        }else if key == WebOSDevice.WebOSEventKey.Search.rawValue {
            
            client?.send(.launchApp(appId: "com.webos.app.voice"))
        }else if key == WebOSDevice.WebOSEventKey.Setting.rawValue {
            
            client?.send(.launchApp(appId: "com.palm.app.settings"))
        }else if key == WebOSDevice.WebOSEventKey.Guide.rawValue {
            
            client?.send(.launchApp(appId: "com.webos.app.tvuserguide"))
        }else if key == WebOSDevice.WebOSEventKey.Input.rawValue {
            
            let count = Int.random(in: 1...3)
            
//            let id:String = "HDMI_\(count)"
//            let appid:String = "com.webos.app.hdmi\(count)"
////            client?.send(.setSource(id))
//            client?.send(.launchApp(appId: appid))
            client?.send(.listSources)
//            client?.send(.launchApp(appId: "com.webos.app.tvlistSources"))
        }
            
    }
    
    func setSource(id:String) {
        
        client?.send(.setSource(id))
    }
    
    func searchWithString(content: String) {
        
        client?.send(.insertText(text: content, replace: true))
    }
    
    func checkPin(pin: String) {
        
        client?.send(.setPin(pin))
    }
    
    var isCancelPin:Bool = false
    
    func canCelPin() {
        
        isCancelPin = true
        self.checkPin(pin: "")
    }
}

extension WebOSDevice:WebOSClientDelegate {
    
    func didPrompt() {
        
    }
    
    func didConnect() {
        
        client?.send(.register(pairingType: .pin, clientKey: self.token))
        
        if isShowPin {
            
            self.callBackStatus(.didDisplayPin, "")
        }
        
        self.callBackStatus(.didConnect, "")
    }
    
    func didDisconnect() {
        
        
    }
    
    func didDisplayPin() {
            // Send the correct PIN displayed on the TV screen to the TV here.
        
        if !isShowPin {
            
            self.callBackStatus(.didDisplayPin, "")
            isShowPin = true
        }
    }
    
    func didRegister(with clientKey: String) {
        
        self.callBackStatus(.didRegister, clientKey)
    }
    
    func didReceiveNetworkError(_ error: (any Error)?) {
        
        if let error = error as NSError? {
            
            self.callBackStatus(.error, error.localizedDescription)
        }
        
    }
    
    func didReceive(_ result: Result<WebOSResponse, Error>) {
        switch result {
        case .success(let response):
            
            if let devices = response.payload?.devices {
                
                if devices.count == 0 {
                    
                    break
                }
                
                var modelArray:[WebOSHDMIListModel] = []
                
                for device in devices {
                    
                    let smodel:WebOSHDMIListModel = WebOSHDMIListModel()
                    smodel.name = device.label
                    smodel.id = device.id
                    
                    modelArray.append(smodel)
                }
                
                if modelArray.count != 0 {
                    
                    self.hdmideviceCallBack(modelArray)
                }
                
            } else {
                print("No devices found.")
            }
        case .failure(let error):
            
            let errorMessage = error.localizedDescription

            if errorMessage.contains("rejected pairing") {
                
                if !isCancelPin {
                    
                    callBackStatus(.pinError, "rejected pairing")
                }else {
                    
                    isCancelPin = false
                }
            // Pairing rejected by the user or invalid pin.
                
            }
            
//            if errorMessage.contains("The operation couldn’t be completed") {
//                
//                callBackStatus(.error,errorMessage)
//            }
            
            if errorMessage.contains("cancelled") {
                
            // Pairing cancelled due to a timeout.
                callBackStatus(.pinCancel, "cancelled")
                isShowPin = false
                isCancelPin = false
            }
        }
//        
//        if case .failure(let error) = result {
//            
//        }
    }
    
}
