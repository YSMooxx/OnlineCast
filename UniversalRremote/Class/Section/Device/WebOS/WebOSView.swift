//
//  WebOSView.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/14.
//

class WebOSView:DeivceBaseView {
    
    lazy var remoteView:WebOSRemoteView = {
        
        let sview:WebOSRemoteView = WebOSRemoteView(frame: bounds)
        
        sview.callBack = {[weak self] text in
            
            if text == "volumup" {
                
                self?.callBack(WebOSDevice.WebOSEventKey.VolumeUp.rawValue)
            }else if text == "volumdown" {
                
                self?.callBack(WebOSDevice.WebOSEventKey.VolumeDown.rawValue)
            }else if text == "channelup" {
                
                self?.callBack(WebOSDevice.WebOSEventKey.ChannelUp.rawValue)
            }else if text == "channeldown" {
                
                self?.callBack(WebOSDevice.WebOSEventKey.ChannelDown.rawValue)
            }else {
                
                self?.callBack(text)
            }
        }
        
        return sview
    }()
    
    override func addViews() {
        
        super.addViews()
        
        choiceView.removeFromSuperview()
        scrollView.removeFromSuperview()
        insertSubview(remoteView, at: 0)
    }
    
}
