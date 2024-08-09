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
        let sview:RokuView = RokuView(frame: CGRect(x: 0, y: cY, width: view.width, height: view.height - cY))
        
        return sview
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        guard let smodel = self.model.smodel as? RokuDevice else {return}
        
        currentDevice = smodel
        
        connectDevice()
    }
    
    override func addViews() {
        
        super.addViews()
        
        view.addSubview(rokuView)
    }
    
    func connectDevice() {
        
        self.currentDevice?.connectDevice(suc: {[weak self] status in
            guard let self else {return}
            if status == Load_suc {
                
                self.setTitleString(text: self.currentDevice?.reName ?? "", isSelected: true)
            }else {
                
                self.setTitleString()
            }
        })
    }
}
