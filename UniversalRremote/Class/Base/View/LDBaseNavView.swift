//
//  LDBaseNavView.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/6.
//

import UIKit

class LDBaseNavView:UIView {
    
    var callBack: callBack = {text in }
    
    lazy var model:LDBaseNavViewModel =  {
       
        let model :LDBaseNavViewModel = LDBaseNavViewModel()
        
        model.callBack = {[weak self] (text) in
            
            self?.setupUI()
        }
        
        return model
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
    
    lazy var titleLabel:UILabel = {
       
        let titleLabel:UILabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 18.RW(), weight: .medium)
        titleLabel.textColor = UIColor.colorWithHex(hexStr: whiteColor)
        return titleLabel
    }()
    
    lazy var backBtn:EnlargeBtn = {
        
        let sview:EnlargeBtn = EnlargeBtn(frame: CGRect(x: 0, y: 0, width: iconWH, height: iconWH))
        sview.setImage(UIImage.svgWithName(name: "nav_back", size: CGSize(width: iconWH, height: iconWH)), for: .normal)
        sview.height = iconWH
        sview.width = iconWH
        sview.x = 8.RW()
        sview.centerY = (height - statusBarHeight) / 2 + statusBarHeight
        sview.addTarget(self, action: #selector(backBtnClick(btn:)), for: .touchUpInside)
        
        return sview
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: CGRect(x: 0, y: 0, width: ScreenW, height: navHeight))
        setupUI()
        addView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        backgroundColor = UIColor.colorWithHex(hexStr: model.backgroundColor)
        
        titleLabel.text = model.title
        titleLabel.sizeToFit()
        titleLabel.centerX = width / 2
        titleLabel.centerY = (height - statusBarHeight) / 2 + statusBarHeight
        
        if model.titleLabelX != 0{
            
            titleLabel.x = backBtn.x + backBtn.width + model.titleLabelX
            titleLabel.width = width - titleLabel.x - 30.RW() - 28.RW()
        }
        
        backBtn.isHidden = !model.isBackBtnShow
    }
    
    func addView() {
        addSubview(lineView)
        addSubview(titleLabel)
        addSubview(backBtn)
    }
    
    @objc func backBtnClick(btn:UIButton) {
        
         callBack("back")
    }
}

class LDBaseNavViewModel {
    
    var callBack: callBack = {text in }
    
    
    var title:String = "Title" {
        
        didSet {
            callBack("title")
        }
    }
    
    var backgroundColor:String = dBackColor {
        
        didSet {
            
            callBack("backgroundColor")
        }
    }
    
    var isBackBtnShow:Bool = false {
        didSet {
            
            callBack("isBackBtnShow")
        }
    }
    
    var titleLabelX:CGFloat = 0 {
        
        didSet {
            
            callBack("titleLabelX")
        }
    }
    
}


