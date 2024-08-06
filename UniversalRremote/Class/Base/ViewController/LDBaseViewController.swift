//
//  LDBaseViewCOntroller.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/6.
//

import UIKit

class LDBaseViewController:UIViewController {
    
    var barStatyl:UIStatusBarStyle = .darkContent {
        
        didSet {
            
            self.setNeedsStatusBarAppearanceUpdate()
            self.setStatusBarStyle(style: barStatyl)
        }
    }
    
    var barHidden:Bool = false {
        
        didSet {
            
            self.setNeedsStatusBarAppearanceUpdate()
            self.setStatusBarHidden(isHidden: barHidden)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return barStatyl
    }
    
    override var prefersStatusBarHidden:Bool {
        
        return barHidden
    }
    
    lazy var titleView:LDBaseNavView = {
        
        let titleView:LDBaseNavView = LDBaseNavView()
        
        if navigationController?.children.count ?? 0 > 1 {
            
            titleView.model.isBackBtnShow = true
        }else {
            
            titleView.model.isBackBtnShow = false
        }
        
        titleView.callBack = {[weak self] (text) in
            
            if text == "back" {
                
                self?.close()
            }
        }
        
        return titleView
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = UIColor.colorWithHex(hexStr: dBackColor)
        addViews()
    }
    
    func addViews() {
        
        view.addSubview(titleView)
    }
    
    func close(animation:Bool = true) {
        
        if navigationController?.children.count ?? 0 > 1 {
            
            navigationController?.popViewController(animated: animation)
        }else {
            
            navigationController?.dismiss(animated: animation)
        }
    }
}
