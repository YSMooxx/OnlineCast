//
//  SettingView.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/7.
//

import UIKit

class SettingView:UIView {
    
    var callBack:callBack = {text in}
    
    var listModelArray:[settingListModel]? {
        
        didSet {
            
            addListBtn()
        }
    }
    
    lazy var logoImage:UIImageView = {
        
        let sview:UIImageView = UIImageView()
        sview.width = 100.RW()
        sview.height = 100.RW()
        sview.y = 50.RW()
        sview.x = 32.RW()
        sview.backgroundColor = UIColor.colorWithHex(hexStr: "#D9D9D9")
        sview.cornerCut(radius: 16.RW(), corner: .allCorners)
        
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
        
        backgroundColor = UIColor.colorWithHex(hexStr: "#292929")
    }
    
    func addViews() {
        
        addSubview(logoImage)
    }
    
    func addListBtn() {
        
        var cY:CGFloat = logoImage.y + logoImage.height + 49.RW()
        let mar:CGFloat = 32.RW()
        let cH:CGFloat = iconWH
        let cX:CGFloat = 32.RW()
        for smodel in listModelArray ?? [] {
            
            let btn = addBtn(model: smodel)
            btn.height = cH
            btn.y = cY
            btn.x = cX
            cY += btn.height + mar
            addSubview(btn)
        }
    }
    
    func addBtn(model:settingListModel) -> UIButton{
        
        let btn:UIButton = UIButton()
        
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14.RW(), weight: .regular)
        btn.setTitleColor(UIColor.colorWithHex(hexStr: "#CCCCCC"), for: .normal)
        btn.setTitle(model.title, for: .normal)
        btn.setImage(UIImage.svgWithName(name: model.icon ?? "", size: CGSize(width: iconWH, height: iconWH)), for: .normal)
        btn.sizeToFit()
        btn.width += 8.RW()
        btn.changBtnWithStytl(btnStyle: .defalut, margin: 8.RW())
        btn.addTarget(self, action: #selector(listBtnClick(btn:)), for: .touchUpInside)
        return btn
    }
    
    @objc func listBtnClick(btn:UIButton) {
        
        callBack(btn.titleLabel?.text ?? "")
    }
}

class settingListModel:BaseModel {
    
    var icon:String?
    var title:String?
}
