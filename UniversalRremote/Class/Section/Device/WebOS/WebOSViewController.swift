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
                keyboardView.allresultCallBack = {text in
                    
                    dev.searchWithString(content: text)
                }
                
                keyboardView.allDelete = {text in
                    
                    dev.searchWithString(content: "")
                }
                
            }else if text == WebOSDevice.WebOSEventKey.Input.rawValue {
                
                let vc:WebOSHDMIViewController = WebOSHDMIViewController()
                let nav:LDBaseNavViewController = LDBaseNavViewController(isAnimation: .overBottomToTop,rootViewController: vc)
                vc.model.modelArray = self.hdmiArray
                vc.idCallBack = {[weak self] id in
                    guard let self,let dev = currentDevice else {return}
                    
                    dev.setSource(id: id)
                }
                nav.modalPresentationStyle = .overFullScreen
                self.navigationController?.present(nav, animated: true)
                
            }else {
                
                if self.connectStatus == .sucConnect {
                    
                    guard let dev = currentDevice else {return}
                    
                    shock()
                    dev.sendKey(key: text)
                    
                }else {
                    
                    AllTipView.shard.showViewWithView(content: "Device Disconnected")
                }
                
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
    
    var iscanConnect:Bool = false
    
    var timer: Timer?
    
    var startTime:TimeInterval?
    
    var hdmiArray:[WebOSHDMIListModel] = []
    
    var currentDevice:WebOSDevice? {
        
        didSet {
            
            currentDevice?.callBackStatus = {[weak self] status,content in
                
                DispatchQueue.main.async {[weak self] in
                    
                    guard let self else { return }
                    switch status {
                        
                    case .didConnect:
                        iscanConnect = true
                        stopTimer()
                    case .didRegister:
                        self.connectStatus = .sucConnect
                        self.pinWriteView.pinTextView.text = ""
                        self.pinWriteView.dissMiss()
                        self.currentDevice?.token = content
                        RemoteDMananger.mananger.tokenChannge(device: self.currentDevice)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {[weak self] in
                            guard let self else {return}
                            self.currentDevice?.sendKey(key: WebOSDevice.WebOSEventKey.Input.rawValue)
                            
                        })
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
            
            currentDevice?.hdmideviceCallBack = {[weak self] arry in
                
                guard let self else {return}
                
                self.hdmiArray = []
                
                for smodel in arry {
                    
                    self.hdmiArray.append(smodel)
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
    
    func startTimer() {
        
        DispatchQueue.main.async {[weak self] in
            
            guard let self else {return}
            
            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {[weak self] timer in
                
                guard let self else {return}
                
                if iscanConnect {
                    
                    return
                }
                
                if (self.startTime ?? 0) + 10 < getNowTimeInterval() {
                    
                    currentDevice?.disconnect()
                    self.connectStatus = .failConnect
                    self.stopTimer()
                }
            }
        }
    }
    
    func stopTimer() {
        
        timer?.invalidate()
        timer = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        
        currentDevice?.sendKey(key: "")
    }
    
    override func changeConnectStatus() {
        
        super.changeConnectStatus()
        
        switch connectStatus {
            
        case .startConnect:
            
            startTime = getNowTimeInterval()
            startTimer()
            self.connectDevice()
        default:
            break
        }
        
        self.webOSView.connectStatus = self.connectStatus
    }
    
    deinit {
        Print("xiaohui")
        currentDevice?.disconnect()
        NotificationCenter.default.removeObserver(self)
    }
}
     
