//
//  BaseShowTipView.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/13.
//

import UIKit

class BaseShowTipView:UIView {
    
    var callBack:callBack = {text in}
    
    lazy var backView:UIView = {
        
        let backView:UIView = UIView()
        backView.height = 267.RW()
        backView.width  = width
        backView.x = 0
        backView.y = height
        backView.cornerCut(radius: 12.RW(), corner: [.topLeft,.topRight])
        backView.backgroundColor = UIColor.colorWithHex(hexStr: cellBackColor)
        
        return backView
    }()
    
    lazy var closeBtn:UIButton = {
        
       let closeBtn:UIButton = UIButton()
        closeBtn.width = iconWH
        closeBtn.height = iconWH
        closeBtn.x = backView.width - closeBtn.width - 10.RW()
        closeBtn.y = 10.RW()
        closeBtn.setBackgroundImage(UIImage(named: "close_icon"), for: .normal)
        closeBtn.addTarget(self, action: #selector(closeBtnClick(btn:)), for: .touchUpInside)
        
        return closeBtn
    }()
    
    lazy var titleLabel:UILabel = {
        
        let titleLabel:UILabel = UILabel()
        titleLabel.y = 44.RW()
        titleLabel.width = 20.RW()
        titleLabel.centerX = backView.width / 2
        titleLabel.font = UIFont.systemFont(ofSize: 16.RW(), weight: .regular)
        titleLabel.textColor = UIColor.colorWithHex(hexStr: whiteColor)
        
        return titleLabel
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: CGRect(x: 0, y: 0, width: ScreenW, height: ScreenH))
        setupUI()
        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        backgroundColor = UIColor.colorWithHex(hexStr: blackColor, alpha: 0.6)
    }
    
    func addViews() {
        
        addSubview(backView)
        backView.addSubview(closeBtn)
        backView.addSubview(titleLabel)
    }
    
    func dissMiss(suc:@escaping callBack = {text in}) {
        
        UIView.animate(withDuration: 0.3) {[weak self] in
            
            self?.backView.y = (self?.height ?? ScreenH)
        }completion: {[weak self] Bool in
            
            self?.removeFromSuperview()
        }
    }
    
    func showView() {
        
        cWindow?.addSubview(self)
        UIView.animate(withDuration: 0.3) {[weak self] in

            self?.backView.y = (self?.height ?? ScreenH) - (self?.backView.height ?? 0)
        }

    }
    
    @objc func closeBtnClick(btn:UIButton) {
        
        callBack(Click_cancel)
        dissMiss()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        var result:Bool? = true
        
        for touch:AnyObject in touches{
            
            let touch:UITouch = touch as! UITouch
            let result1:Bool = touch.view?.isDescendant(of:self.backView) ?? true
            result = result1
        }
        
        if result != true {
            
            dissMiss()
        }
        
    }
}


