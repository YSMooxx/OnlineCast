//
//  TermOfUseWebViewController.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/7.
//

import UIKit

class TermOfUseWebViewController:LDBaseWebViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        titleView.model.title = "Term of Use"
        
        LoadWithUrl(url: "https://ldyt.online/termsofuse.html")
        
        view.backgroundColor = .white
        webView.width = ScreenW - 20.RW()
        webView.x = 10.RW()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.barStatyl = .lightContent
    }
}

