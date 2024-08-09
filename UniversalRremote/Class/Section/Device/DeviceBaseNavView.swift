//
//  DeviceBaseNavView.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/9.
//


import UIKit

class DeviceBaseNavView:UIView {
    
    var callBack:callBack = {text in}
    
    lazy var settingsBtn:EnlargeBtn = {
        
        let sview:EnlargeBtn = EnlargeBtn(frame: CGRect(x: 0, y: navCenterY, width: iconWH, height: iconWH))
        sview.width = iconWH
        sview.height = iconWH
        sview.x = marginLR
        sview.centerY = navCenterY
        sview.setBackgroundImage(UIImage(named: "remoteD_settings_icon"), for: .normal)
        sview.addTarget(self, action: #selector(settingsBtnClick), for: .touchUpInside)
        
        return sview
    }()
    
    lazy var titleLable:UILabel = {
        
        let sview:UILabel = UILabel()
        sview.font = UIFont.systemFont(ofSize: 20.RW(), weight: .medium)
        sview.textColor = UIColor.colorWithHex(hexStr: whiteColor)
        sview.text = "Universal Remote"
        sview.sizeToFit()
        sview.x = settingsBtn.x + settingsBtn.width + 8.RW()
        sview.centerY = settingsBtn.centerY
        
        return sview
    }()
    
    lazy var addBtn:EnlargeBtn = {
        
        let sview:EnlargeBtn = EnlargeBtn(frame: CGRect(x: 0, y: navCenterY, width: iconWH, height: iconWH))
        sview.width = iconWH
        sview.height = iconWH
        sview.x = width - sview.width - marginLR
        sview.centerY = navCenterY
        sview.setBackgroundImage(UIImage(named: "remoteD_add_icon"), for: .normal)
        sview.addTarget(self, action: #selector(addBtnClick), for: .touchUpInside)
        
        return sview
    }()
    
    lazy var lineView:UIView = {
        
        let sview:UIView = UIView()
        sview.width = width
        sview.height = 0.5
        sview.y = height - 0.5
        sview.x = 0
        
        sview.backgroundColor = UIColor.colorWithHex(hexStr: whiteColor, alpha: 0.08)
        
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
        
        backgroundColor = UIColor.colorWithHex(hexStr: dBackColor)
    }
    
    func addViews() {
        
        addSubview(settingsBtn)
        addSubview(titleLable)
        addSubview(addBtn)
        addSubview(lineView)
    }
    
    @objc func settingsBtnClick() {
        
        callBack("setting")
    }
    
    @objc func addBtnClick() {
        
        callBack("add")
    }
}
