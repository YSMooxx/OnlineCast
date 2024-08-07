//
//  PrivacyPolicyWebViewController.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/7.
//

import UIKit

class PrivacyPolicyWebViewController:LDBaseWebViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        titleView.model.title = "Privacy Policy"
        
        LoadWithUrl(url: "https://ldyt.online/privacypolicy.html")
        
        view.backgroundColor = .white
        webView.width = ScreenW - 20.RW()
        webView.x = 10.RW()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.barStatyl = .lightContent
    }
    
}
