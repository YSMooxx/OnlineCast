//
//  RemoteViewController.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/6.
//

import UIKit

class RemoteViewController:LDBaseViewController {
    
    lazy var remoteView:RemoteView = {
        
        let sview:RemoteView = RemoteView(frame: view.bounds)
        
        sview.callBack = {[weak self] text in
            
            if text == "setting" {
                let vc:SettingViewController = SettingViewController()
                let nav:LDBaseNavViewController = LDBaseNavViewController(isAnimation:.overRightToLeft,rootViewController: vc)
                nav.modalPresentationStyle = .overFullScreen
                self?.navigationController?.present(nav, animated: true)
            }else if text == "add" {
                
                let vc:SearchViewController = SearchViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        sview.clickCallBack = {[weak self] device in
            
            DispatchQueue.main.async {[weak self] in
                guard let self else {return}
                
                if device.type == Roku {
                    
                    let vc:RokuViewController = RokuViewController(model: device)
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
        }
        
        return sview
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        remoteView.model.deviceModelArray = RemoteDMananger.mananger.deviceArray
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: Notification.Name("Control_currentDev_Change"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.barHidden = false
        
        self.barStatyl = .lightContent
    }
    
    override func addViews() {
        
        view.addSubview(remoteView)
    }
    
    @objc func handleNotification(_ notification: Notification) {
        
        remoteView.model.deviceModelArray = RemoteDMananger.mananger.deviceArray
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
}
