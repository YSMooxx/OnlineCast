//
//  FireViewController.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/12.
//

import UIKit

class FireViewController:DeviceBaseViewController {
    
    var currentDevice:FireDevice?
    
    var failCount:Int = 0
    
    lazy var fireView:FireView = {
        
        let cY:CGFloat = titleView.y + titleView.height
        let sview:FireView = FireView(frame: CGRect(x: 0, y: cY, width: view.width, height: view.height - cY), titleArray: ["Remote","Channel"], model: self.model.smodel ?? Device(url: "", ip: ""),isRconnect: isRConnet)
        
        
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
                
                if self.connectStatus == .sucConnect {
                    
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
                    
                    AllTipView.shard.showViewWithView(content: "Device Disconnected")
                }
                
            }else {
                
                
                if text == FireDevice.FireEventKey.volumeUp.rawValue || text == FireDevice.FireEventKey.VolumeDown.rawValue || text == FireDevice.FireEventKey.VolumeMute.rawValue {
                    
                    guard let dev = currentDevice else {return}
                    
                    if !dev.isVolum {
                        
                        AllTipView.shard.showViewWithView(content: "Volume cannot be adjusted")
                        return
                    }
                }
                
                if self.connectStatus == .sucConnect {
                    
                    guard let dev = currentDevice else {return}
                    
                    throttler.throttle {
                        
                        shock()
                        
                        dev.sendKey(key: text) { status in
                            
                            if status == Load_fail {
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {[weak self]  in
                                    guard let self else {return}
                                    self.currentDevice?.connectDevice(suc: { status in
                                        
                                        if status == Load_fail {
                                            
                                            self.failCount += 1
                                            
                                            if self.failCount > 5 {
                                                
                                                self.connectStatus = .startConnect
                                            }
                                        }
                                        
                                    })
                                })
                            }
                        }
                    }
                    
                    
                }else {
                    
                    AllTipView.shard.showViewWithView(content: "Device Disconnected")
                }
            }
        }
        
        sview.channelIDCallBacl = {[weak self] (text) in
            guard let self else {return}
            if self.connectStatus == .sucConnect {
                
                guard let dev = currentDevice else {return}
                
                throttler.throttle {
                    shock()
                    dev.changeChannel(id: text) { status in
                        
                        if status == Load_fail {
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {[weak self]  in
                                guard let self else {return}
                                self.currentDevice?.connectDevice(suc: { status in
                                    
                                    self.failCount += 1
                                    
                                    if self.failCount > 5 {
                                        
                                        self.connectStatus = .failConnect
                                    }
                                    
                                })
                            })
                        }
                    }
                }
                
            }else {
                
                AllTipView.shard.showViewWithView(content: "Device Disconnected")
            }
        }
        
        return sview
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        guard let smodel = self.model.smodel as? FireDevice else {return}
        
        currentDevice = smodel
        
        self.fireView.connectingView.deviceName = currentDevice?.reName
        
        if isRConnet {
            
            if NetStatusManager.manager.currentStatus == .WIFI {
                
                self.connectStatus = .startConnect
            }else {
                
                self.connectStatus = .failConnect
            }
        }else {
            
            self.connectStatus = .sucConnect
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: Notification.Name("collection_Fire_channgeArray"), object: nil)
    }
    
    override func addViews() {
        
        super.addViews()
        
        view.addSubview(fireView)
    }
    
    func connectDevice() {
        
        self.currentDevice?.connectDevice(suc: {[weak self] status in
            guard let self else {return}
            if status == Load_suc {
                
                self.connectStatus = .sucConnect
            }else {
                
                guard let smodel = currentDevice else {self.connectStatus = .failConnect; return}
                self.fireClick(fireModel: smodel) { status in
                    
                    AllTipLoadingView.loadingShared.dissMiss()
                    if status == Load_suc {
                        
                        self.connectStatus = .sucConnect
                    }else {
                        
                        self.connectStatus = .failConnect
                    }
                }
            }
        })
    }
    
    func fireClick(fireModel:FireDevice,sucstatus:@escaping callBack = {status in}) {
        
        self.checkFireStatus(subModel: fireModel) {[weak self] status in
            
            guard let self else {return}
            
            self.checkStatusTime = nil
            
            if status == Load_suc {
                
                AllTipLoadingView.loadingShared.showView()
                
                fireModel.showPin { text in
                    
                    if text == Load_suc {
                        
                        let writePin:FirePINWriteView = FirePINWriteView()
                        writePin.fireModel = fireModel
                        writePin.showView()
                        writePin.callBack = {text in
                            
                            if text == Load_error {
                                
                                fireModel.showPin { text in
                                    
                                    if text == Load_fail {
                                        
                                        sucstatus(text)
                                    }
                                }
                                
                            }else if text == Load_error{
                                
                                fireModel.showPin { text in
                                    
                                    if text == Load_fail {
                                        
                                        sucstatus(text)
                                    }
                                }
                                
                            }else {
                                
                                sucstatus(text)
                            }
                            
                        }
                        
                        writePin.resultCallBack = {text in
                            
                            AllTipLoadingView.loadingShared.showView()
                            
                            fireModel.token = text
                            RemoteDMananger.mananger.tokenChannge(device: fireModel)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                
                                sucstatus(Load_suc)
                                AllTipLoadingView.loadingShared.dissMiss()
                                
                            })
                        }
                        
                    }else {
                        
                        sucstatus(text)
                    }
                }
                
            }else {
                     
                sucstatus(status)

            }
        }
        
    }
    
    var checkStatusTime:Int64?
    
    func checkFireStatus(subModel:FireDevice,suc:@escaping callBack = {text in}) {
        
        if checkStatusTime != nil {
            
            if (checkStatusTime ?? 0) + 5 < Int64(Date().timeIntervalSince1970) {
                
                checkStatusTime = nil
                Print("status--------超时")
                suc(Load_fail)
                return
            }
            
        }else {
            
            checkStatusTime = Int64(Date().timeIntervalSince1970)
        }
        
        subModel.checkStatus(suc: {[weak self] text in
            
            guard let self else{ return}
            
            if text == Load_suc {
                
                self.checkStatusTime = nil
                Print("status--------成功")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    
                    suc(text)
                })
                
            }else {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {[weak self] in
                    
                    guard let self else {return}
                    
                    self.checkFireStatus(subModel: subModel, suc: {text in
                        suc(text)
                    })
                })
                
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
        
        self.fireView.connectStatus = self.connectStatus
    }
    
    @objc func handleNotification(_ notification: Notification) {
        
        fireView.channelView.setWithArray()
    }
}

