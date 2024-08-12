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
                
                dev.changeChannel(id: text)
            }else {
                
                
            }
        }
        
        return sview
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        guard let smodel = self.model.smodel as? RokuDevice else {return}
        
        currentDevice = smodel
        
        connectDevice()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: Notification.Name("collection_channgeArray"), object: nil)
    }
    
    override func addViews() {
        
        super.addViews()
        
        view.addSubview(rokuView)
    }
    
    func connectDevice() {
        
        self.connectStatus = .startConnect
        self.rokuView.connectingView.deviceName = currentDevice?.friendlyName
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
        
        self.rokuView.connectStatus = self.connectStatus
    }
    
    @objc func handleNotification(_ notification: Notification) {
        
        rokuView.channelView.setWithArray()
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
}
