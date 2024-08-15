//
//  DeviceListBtn.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/9.
//

import UIKit

class DeviceListBtn:UIButton {
    
    var modelCallBack:(_ model:DeviceListbtnModel?) -> () = {model in}
    
    var model:DeviceListbtnModel? {
        
        didSet {
            
            setupUI()
        }
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        guard let sModel = model else { return}
        
        
        var iconSize:CGSize = CGSizeMake(iconWH, iconWH)
        
        if sModel.title.count != 0 {
            
            iconSize = CGSizeMake(22.RW(), 22.RW())
        }
        
        self.setImage(UIImage.svgWithName(name: sModel.iconImage, size: iconSize), for: .normal)
        self.setBackgroundImage(UIImage(named: sModel.norlImage), for: .normal)
        self.setTitleColor(UIColor.colorWithHex(hexStr: whiteColor), for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 10.RW(), weight: .medium)
        if !sModel.noHight {
            
            self.setBackgroundImage(UIImage(named: sModel.hightLImage), for: .highlighted)
        }
        
        self.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
        self.addTarget(self, action: #selector(buttonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside])
        
        if sModel.title.count != 0{
            self.setTitle(sModel.title, for: .normal)
            changBtnWithStytl(btnStyle: .imageTop, margin: 0)
        }else {
            self.setTitle("", for: .normal)
            changBtnWithStytl(btnStyle: .defalut, margin: 0)
        }
        
    }
    
    @objc func buttonTouchDown(_ sender: UIButton) {
        
        modelCallBack(model)
        
        sender.isHighlighted = true
    }
        
    // 按钮松开时触发
    @objc func buttonTouchUp(_ sender: UIButton) {
        
        sender.isHighlighted = false
    }
}

class DeviceListbtnModel:BaseModel {
    
    var norlImage:String = "deviceVC_list_norl_back"
    var hightLImage:String = "deviceVC_list_hight_back"
    var iconImage:String = ""
    var title:String = ""
    var noHight:Bool = false
    var key:String = ""
    //1  defalut 2 22.rw()
}

class volumBtn:UIButton {
    
    var callBack:callBack = {text in}
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        let hitView = super.hitTest(point, with: event)
                
                // 判断如果点击在自身范围内，则传递事件
        if hitView == self {
            // 返回nil让点击事件继续传递给底层按钮
            self.isHighlighted = true
            callBack(self.titleLabel?.text ?? "")
            return nil
        }
        
        return hitView
    }
    
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {

        var boundCGRect = self.bounds

        boundCGRect = CGRectInset(boundCGRect, -marginLR, -marginLR)

        return CGRectContainsPoint(boundCGRect, point)
    }
}
