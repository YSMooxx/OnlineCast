//
//  SearchNoWifiView.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/8.
//

import UIKit

class SearchNoWifiView:UIView {
    
    var callBack:callBack = {text in}
    
    lazy var tipImage:UIImageView = {
        
        let cWH:CGFloat = 200.RW()
        
        let sview:UIImageView = UIImageView(image: UIImage(named: "search_nowifi_icon"))
        sview.width = cWH
        sview.height = cWH
        sview.y = 0
        sview.centerX = width / 2
        
        return sview
    }()
    
    lazy var titleLabel:UILabel = {
        
        let sview:UILabel = UILabel()
        sview.font = UIFont.systemFont(ofSize: 20.RW(), weight: .medium)
        sview.textColor = UIColor.colorWithHex(hexStr: whiteColor)
        sview.text = "No Network Connection"
        sview.sizeToFit()
        sview.y = tipImage.y + tipImage.height
        sview.centerX = tipImage.centerX
        
        return sview
    }()
    
    lazy var tipLabel:UILabel = {
        let cW:CGFloat = width - 49.RW()
        let sview:UILabel = UILabel()
        sview.font = UIFont.systemFont(ofSize: 14.RW(), weight: .regular)
        sview.textColor = UIColor.colorWithHex(hexStr: "#999999")
        sview.text = "Please check your wireless network connection, then try again."
        sview.numberOfLines = 0
        sview.textAlignment = .center
        sview.width = cW
        sview.sizeToFit()
        sview.width = cW
        sview.y = titleLabel.y + titleLabel.height + 12.RW()
        sview.centerX = tipImage.centerX
        
        return sview
    }()
    
    lazy var operBtn:UIButton = {
        
        let sview:UIButton = UIButton()
        sview.backgroundColor = UIColor.colorWithHex(hexStr: mColor)
        sview.setTitleColor(UIColor.colorWithHex(hexStr: whiteColor), for: .normal)
        sview.titleLabel?.font = UIFont.systemFont(ofSize: 16.RW(), weight: .medium)
        sview.setTitle("Connect Now", for: .normal)
        sview.addTarget(self, action: #selector(operBtnClick), for: .touchUpInside)
        sview.width = 154.RW()
        sview.height = 44.RW()
        sview.y  = tipImage.y + tipImage.height + 148
        sview.centerX = tipImage.centerX
        sview.cornerCut(radius: 12.RW(), corner: .allCorners)
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
        
        
    }
    
    func addViews() {
        
        addSubview(tipImage)
        addSubview(titleLabel)
        addSubview(tipLabel)
        addSubview(operBtn)
    }
    
    @objc func operBtnClick() {
        
        callBack(Click_allClick)
    }
}
