//
//  FireViewController.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/12.
//

import UIKit

class FireViewController:DeviceBaseViewController {
    
    var currentDevice:FireDevice?
    
    lazy var fireView:FireView = {
        
        let cY:CGFloat = titleView.y + titleView.height
        let sview:FireView = FireView(frame: CGRect(x: 0, y: cY, width: view.width, height: view.height - cY), titleArray: ["Remote","Channel"], model: self.model.smodel ?? Device(url: "", ip: ""))
        
        
        sview.callBack = {[weak self] text in
            guard let self else {return}
            if text == "gotosearch" {
                
                let vc:SearchViewController = SearchViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }else if text == "touch"{
                
                
            }else if text == "dir" {
                
                
            }else if text == "keyboard" {
                
                guard let dev = currentDevice else {return}
                
                let keyboardView:DeviceKeyboardView = DeviceKeyboardView()
                
                keyboardView.showView()
                keyboardView.resultCallBack = {text in
                    
                    if text == "delete" {
                        
                        dev.sendKey(key: FireDevice.FireEventKey.Backspace.rawValue)
                    }else {
                        
                        dev.searchWithString(content: text)
                    }
                }
                
            }else {
                
                if self.connectStatus == .sucConnect {
                    
                    guard let dev = currentDevice else {return}
                    
                    dev.sendKey(key: text)
                }else {
                    
                    
                }
            }
        }
        
        sview.channelIDCallBacl = {[weak self] (text) in
            guard let self else {return}
            if self.connectStatus == .sucConnect {
                
                guard let dev = currentDevice else {return}
                shock()
                dev.changeChannel(id: text)
            }else {
                
                
            }
        }
        
        return sview
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        guard let smodel = self.model.smodel as? FireDevice else {return}
        
        currentDevice = smodel
        
        connectDevice()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: Notification.Name("collection_Fire_channgeArray"), object: nil)
    }
    
    override func addViews() {
        
        super.addViews()
        
        view.addSubview(fireView)
    }
    
    func connectDevice() {
        
        self.connectStatus = .startConnect
        self.fireView.connectingView.deviceName = currentDevice?.reName
        self.currentDevice?.connectDevice(suc: {[weak self] status in
            guard let self else {return}
            if status == Load_suc {
                
                self.connectStatus = .sucConnect
            }else {
                self.connectStatus = .failConnect
            }
        })
    }
    
    override func changeConnectStatus() {
        
        super.changeConnectStatus()
        
        self.fireView.connectStatus = self.connectStatus
    }
    
    @objc func handleNotification(_ notification: Notification) {
        
        fireView.channelView.setWithArray()
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
}

