//
//  LanchVC.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/6.
//

import UIKit
import Lottie

class LaunchVC:LDBaseViewController {
    
    lazy var backImage:UIImageView = {
        
        let sview:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: ScreenW, height: ScreenH))
        
        sview.contentMode = .scaleAspectFill
        sview.image = UIImage(named: "qidong_back")
        
        return sview
    }()
    
    lazy var titleLabel:UILabel = {
        
        let sview:UILabel = UILabel()
        sview.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        sview.textColor = UIColor.colorWithHex(hexStr: whiteColor)
        sview.text = "Universal Remote"
        sview.sizeToFit()
        sview.y = view.height - safeHeight - sview.height - 195
        sview.x = 16
        
        return sview
    }()
    
    lazy var logView:UIImageView = {
        
        let sview:UIImageView = UIImageView()
        sview.backgroundColor = UIColor.colorWithHex(hexStr: "#D9D9D9")
        sview.width = 88.RW()
        sview.height = 88.RW()
        sview.x = titleLabel.x
        sview.y = titleLabel.y - 12 - sview.height
        
        return sview
    }()
    
    lazy var loadingAnimation:AnimationView = {
        
        let animationView = Lottie.AnimationView(name: "Launch_loading")
            
        animationView.width = 100.RW()
        animationView.height = 100.RW()
        animationView.x = 16
        animationView.y = titleLabel.y + titleLabel.height + 0
        animationView.loopMode = .loop
        animationView.play()
        return animationView
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        changeRootVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.barHidden = true
    }
    
    override func addViews() {
        
        view.addSubview(backImage)
        view.addSubview(titleLabel)
        view.addSubview(logView)
        view.addSubview(loadingAnimation)
    }
    
    func changeRootVC() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            
            let vc = RemoteViewController()
            
            cWindow?.rootViewController = LDBaseNavViewController(rootViewController: vc)
            
            cWindow?.makeKeyAndVisible()
        })
    }
}
