//
//  DeviceConnectingView.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/12.
//

import UIKit
import Lottie

class DeviceConnectingView:UIView {
    
    var deviceName:String? {
        
        didSet {
            
            changeTipLabel()
        }
    }
    
    lazy var loadingAnimation:AnimationView = {
        
        let animationView = Lottie.AnimationView(name: "All_loading")
            
        animationView.width = 34.RW()
        animationView.height = 34.RW()
        animationView.x = 12.RW()
        animationView.centerY = height / 2
        animationView.loopMode = .loop
        animationView.play()
        return animationView
    }()
    
    lazy var tipLabel:UILabel = {
        
        let sview:UILabel = UILabel()
        sview.text = "Trying to connect "
        sview.textColor = UIColor.colorWithHex(hexStr: whiteColor)
        sview.font = UIFont.systemFont(ofSize: 14.RW(), weight: .regular)
        sview.x = loadingAnimation.x + loadingAnimation.width + 8.RW()
        sview.width = width - sview.x - 12.RW()
        sview.numberOfLines = 1
        sview.sizeToFit()
        sview.width = width - sview.x - 12.RW()
        sview.centerY = height / 2
        
        return sview
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupUI()
        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        self.backgroundColor = UIColor.colorWithHex(hexStr: "#FFA53D")
        self.cornerCut(radius: 12.RW(), corner: .allCorners)
    }
    
    func addViews() {
        
        addSubview(loadingAnimation)
        addSubview(tipLabel)
    }
    
    func changeTipLabel() {
        
        DispatchQueue.main.async {[weak self] in
            
            guard let self else {return}
            
            self.tipLabel.text = "Trying to connect to \"\(deviceName ?? "")\""
            self.tipLabel.width = width - tipLabel.x - 12.RW()
            self.tipLabel.sizeToFit()
            self.tipLabel.width = width - tipLabel.x - 12.RW()
            self.tipLabel.centerY = height / 2
        }
    }
}

class DeviceConnectFailView:UIView {
    
    var callBack:callBack = {text in}
    
    lazy var iconImage:UIImageView = {
        
        let animationView = UIImageView(image: UIImage(named: "deviceVC_connect_fail_icon"))
            
        animationView.width = iconWH
        animationView.height = iconWH
        animationView.x = 12.RW()
        animationView.centerY = height / 2
        return animationView
    }()
    
    lazy var tipLabel:UILabel = {
        
        let sview:UILabel = UILabel()
        sview.text = "Connection failed. Please check your network and click here to retry."
        sview.textColor = UIColor.colorWithHex(hexStr: whiteColor)
        sview.font = UIFont.systemFont(ofSize: 14.RW(), weight: .regular)
        sview.x = iconImage.x + iconImage.width + 8.RW()
        sview.width = width - sview.x - 12.RW()
        sview.numberOfLines = 2
        sview.sizeToFit()
        sview.centerY = height / 2
        
        return sview
    }()
    
    lazy var nextBtn:UIButton = {
        
        let sview:UIButton = UIButton()
        sview.width = 38.RW()
        sview.height = 38.RW()
        sview.x = width - sview.width - 12.RW()
        sview.centerY = height / 2
        sview.setBackgroundImage(UIImage(named: "deivceVC_connect_next_icon"), for: .normal)
        sview.addTarget(self, action: #selector(nextBtnClick), for: .touchUpInside)
        
        return sview
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupUI()
        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        self.backgroundColor = UIColor.colorWithHex(hexStr: "#FF5A3D")
        self.cornerCut(radius: 12.RW(), corner: .allCorners)
    }
    
    func addViews() {
        
        addSubview(iconImage)
        addSubview(tipLabel)
        addSubview(nextBtn)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        
        callBack("gotosearch")
    }
    
    @objc func nextBtnClick() {
        
        callBack("gotosearch")
    }
}

