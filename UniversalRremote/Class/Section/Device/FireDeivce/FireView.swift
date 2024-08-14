//
//  FireView.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/13.
//

import UIKit

class FireView:DeivceBaseView {

    var channelIDCallBacl:callBack = {id in}
    
    lazy var remoteView:FireRemoteView = {
        
        let sview:FireRemoteView = FireRemoteView(frame: scrollView.bounds)
        
        sview.callBack = {[weak self] text in
            
            if text == "volumup" {
                
                self?.callBack(FireDevice.FireEventKey.volumeUp.rawValue)
            }else if text == "volumdown" {
                
                self?.callBack(FireDevice.FireEventKey.VolumeDown.rawValue)
            }else {
                
                self?.callBack(text)
            }
        }
        
        return sview
    }()
    
    lazy var channelView:FireChannelView = {
        
        let sview:FireChannelView = FireChannelView(frame: scrollView.bounds, model: self.deviceModel)
        sview.x = 1 * scrollView.width
        
        sview.channelIDCallBacl = {[weak self] (text) in
            
            self?.channelIDCallBacl(text)
        }
        
        return sview
    }()
    
    override func addViews() {
        
        super.addViews()
        
        scrollView.addSubview(remoteView)
        scrollView.addSubview(channelView)
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
