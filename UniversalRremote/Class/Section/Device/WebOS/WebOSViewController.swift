//
//  WebOSViewController.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/13.
//

import UIKit

class WebOSViewController:DeviceBaseViewController {
    
    var currentDevice:WebOSDevice? {
        
        didSet {
            
            currentDevice?.connectDevice()
            
            currentDevice?.callBackStatus = {[weak self] status,content in
                
                guard let self else { return }
                switch status {
                    
                case .didConnect:
//                    self.currentDevice?.sendKey(key: "")
                    break
                case .didRegister:
                    self.currentDevice?.sendKey(key: "")
                default:break
                }
            }
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        guard let smodel = self.model.smodel as? WebOSDevice else {return}
        
        currentDevice = smodel
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        
        currentDevice?.sendKey(key: "")
    }
}
     
