//
//  RokuViewController.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/9.
//

import UIKit

class RokuViewController:DeviceBaseViewController {
    
    var currentDevice:RokuDevice?
    
    lazy var rokuView:RokuView = {
        
        let cY:CGFloat = titleView.y + titleView.height
        let sview:RokuView = RokuView(frame: CGRect(x: 0, y: cY, width: view.width, height: view.height - cY), titleArray: ["Remote","Channel","Mirror"], model: self.model.smodel ?? Device(url: "", ip: ""))
        
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
                    
                    AllTipView.shard.showViewWithView(content: "Wi-Fi Network Disconnected")
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
                
                AllTipView.shard.showViewWithView(content: "Wi-Fi Network Disconnected")
            }
        }
        
        return sview
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        guard let smodel = self.model.smodel as? RokuDevice else {return}
        
        currentDevice = smodel
        
        self.connectStatus = .startConnect
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: Notification.Name("collection_channgeArray"), object: nil)
    }
    
    override func addViews() {
        
        super.addViews()
        
        view.addSubview(rokuView)
    }
    
    func connectDevice() {
        
        self.rokuView.connectingView.deviceName = currentDevice?.reName
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
        
        switch connectStatus {
            
        case .startConnect:
            
            self.connectDevice()
        default:
            break
        }
        
        self.rokuView.connectStatus = self.connectStatus
    }
    
    @objc func handleNotification(_ notification: Notification) {
        
        rokuView.channelView.setWithArray()
    }
}
