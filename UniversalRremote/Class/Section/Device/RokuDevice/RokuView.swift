//
//  RokuView.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/9.
//

import UIKit

class RokuView:DeivceBaseView {
    
    var channelIDCallBacl:callBack = {id in}
    
    lazy var remoteView:RokuRemoteView = {
        
        let sview:RokuRemoteView = RokuRemoteView(frame: scrollView.bounds)
        
        sview.callBack = {[weak self] text in
            
            shock()
            
            if text == "volumup" {
                
                self?.callBack(RokuDevice.RokuEventKey.volumeUp.rawValue)
            }else if text == "volumdown" {
                
                self?.callBack(RokuDevice.RokuEventKey.VolumeDown.rawValue)
            }else {
                
                self?.callBack(text)
            }
        }
        
        return sview
    }()
    
    lazy var channelView:RokuChannelView = {
        
        let sview:RokuChannelView = RokuChannelView(frame: scrollView.bounds, model: self.deviceModel)
        sview.x = 1 * scrollView.width
        
        sview.channelIDCallBacl = {[weak self] (text) in
            
            self?.channelIDCallBacl(text)
        }
        
        return sview
    }()
    
    lazy var mirrorView:RokuMirrorView = {
        
        let sview:RokuMirrorView = RokuMirrorView(frame: scrollView.bounds)
        sview.x = 2 * scrollView.width
        return sview
    }()
    
    override func addViews() {
        
        super.addViews()
        
        scrollView.addSubview(remoteView)
        scrollView.addSubview(channelView)
        scrollView.addSubview(mirrorView)
    }
    
    override func changeConnectStatus() {
        
        super.changeConnectStatus()
        
        switch connectStatus {
        
        case .failConnect:
            self.channelView.resultView.model.changeModelArray = []
            self.channelView.setWithArray()
        case .sucConnect:
            channelView.loadData()
        default:
            break
        }
    }
}
