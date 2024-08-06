//
//  UIViewController.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/6.
//

import UIKit

extension UIViewController {
    
    func setStatusBarStyle(style:UIStatusBarStyle) {
        
        guard let nav = self.navigationController as? LDBaseNavViewController else {return}
        
        nav.barStatyl = style
    }
    
    func setStatusBarHidden(isHidden:Bool) {
        
        guard let nav = self.navigationController as? LDBaseNavViewController else {return}
        
        nav.barHidden = isHidden
    }
    
}
