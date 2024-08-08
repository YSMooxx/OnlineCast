//
//  RemoteDNoResultView.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/7.
//

import UIKit

class RemoteDNoResultView:UIView {
    
    var callBack:callBack = {text in}
    
    lazy var bacView:UIButton = {
        
        let sview:UIButton = UIButton()
        sview.height = 104.RW()
        sview.width = width
        sview.centerY = (height - navHeight) / 2
        sview.centerX = width / 2
        sview.setBackgroundImage(UIImage(named: "remoteD_add_back"), for: .normal)
        sview.setImage(UIImage(named: "remoteD_add_icon"), for: .normal)
        sview.titleLabel?.font = UIFont.systemFont(ofSize: 20.RW(), weight: .regular)
        sview.setTitleColor(UIColor.colorWithHex(hexStr: whiteColor), for: .normal)
        sview.setTitle("Connect", for: .normal)
        sview.setImage(UIImage(named: "remoteD_add_icon"), for: .normal)
        
        sview.changBtnWithStytl(btnStyle: .imageTop, margin: 8.RW())
        
        sview.addTarget(self, action: #selector(addClick), for: .touchUpInside)
        
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
        
        backgroundColor = .clear
    }
    
    func addViews() {
        
        addSubview(bacView)
    }
    
    @objc func addClick() {
        
        callBack("add")
    }
}
