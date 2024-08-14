//
//  WebOSViewController.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/13.
//

import UIKit

class WebOSViewController:DeviceBaseViewController {
    
    lazy var webOSView:WebOSView = {
        
        let cY:CGFloat = titleView.y + titleView.height
        let sview:WebOSView = WebOSView(frame: CGRect(x: 0, y: cY, width: view.width, height: view.height - cY), titleArray: ["Remote"], model: self.model.smodel ?? Device(url: "", ip: ""))
        
        sview.callBack = {[weak self] text in
            guard let self else {return}
            if text == "gotosearch" {
                
                let vc:SearchViewController = SearchViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }else if text == "touch"{
                
                shock()
            }else if text == "dir" {
                
                shock()
            }else if text == "keyboard" {
                
                guard let dev = currentDevice else {return}
                
                let keyboardView:DeviceKeyboardView = DeviceKeyboardView()
                
                keyboardView.showView()
                keyboardView.resultCallBack = {text in
                    
                    if text == "delete" {
                        
//                        dev.sendKey(key: FireDevice.FireEventKey.Backspace.rawValue)
                    }else {
                        
                        
                    }
                }
                
            }else {
                
                guard let dev = currentDevice else {return}
                
                shock()
                dev.sendKey(key: text)
            }
        }
        
        return sview
    }()
    
    lazy var pinWriteView:WebOSPINWriteView = {
       
        let sview:WebOSPINWriteView = WebOSPINWriteView()
        
        sview.resultCallBack = {[weak self] (text) in
            guard let self else {return}
            self.currentDevice?.checkPin(pin: text)
        }
        
        sview.callBack = {[weak self] (text) in
            
            guard let self else {return}
            

        }
        
        return sview
    }()
    
    var currentDevice:WebOSDevice? {
        
        didSet {
            
            currentDevice?.callBackStatus = {[weak self] status,content in
                
                DispatchQueue.main.async {[weak self] in
                    
                    guard let self else { return }
                    switch status {
                        
                    case .didConnect:
                        break
                    case .didRegister:
                        self.connectStatus = .sucConnect
                        self.pinWriteView.pinTextView.text = ""
                        self.pinWriteView.dissMiss()
                        self.currentDevice?.token = content
                        RemoteDMananger.mananger.tokenChannge(device: self.currentDevice)
                    case .didDisplayPin:
                        self.connectStatus = .failConnect
                        self.pinWriteView.showView()
                    case .pinError:
                        self.currentDevice?.connectDevice()
                        self.pinWriteView.seterror()
                    case .didDisconnect:
                        self.connectStatus = .failConnect
                    default:break
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        guard let smodel = self.model.smodel as? WebOSDevice else {return}
        
        currentDevice = smodel
        
        self.connectStatus = .startConnect
    }
    
    override func addViews() {
        
        super.addViews()
        
        view.addSubview(webOSView)
    }
    
    func connectDevice() {
        
        self.webOSView.connectingView.deviceName = currentDevice?.reName
        
        currentDevice?.connectDevice()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        
        currentDevice?.sendKey(key: "")
    }
    
    override func changeConnectStatus() {
        
        super.changeConnectStatus()
        
        switch connectStatus {
            
        case .startConnect:
            
            self.connectDevice()
        default:
            break
        }
        
        self.webOSView.connectStatus = self.connectStatus
    }
    
    deinit {
        
        currentDevice?.disconnect()
        NotificationCenter.default.removeObserver(self)
    }
}
     
