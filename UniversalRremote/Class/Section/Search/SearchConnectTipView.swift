//
//  SearchConnectTipView.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/13.
//

import UIKit

class SearchConnectTipView:UIView {
    
    enum tipType {
        case suc
        case fail
    }
    
    lazy var backView:UIView = {
        
        let backView:UIView = UIView()
        backView.height = 52.RW()
        backView.width  = 123.RW()
        backView.centerX = width / 2
        backView.y = navHeight + marginLR
        backView.backgroundColor = UIColor.colorWithHex(hexStr: "#00DF4A")
        
        return backView
    }()
    
    lazy var iconImageView:UIImageView = {
        
        let sview:UIImageView = UIImageView()
        sview.width = iconWH
        sview.height = iconWH
        sview.x = 12.RW()
        sview.centerY = backView.height / 2
        
        return sview
    }()
    
    lazy var tipLabel:UILabel = {
        
        let sview:UILabel = UILabel()
        sview.textColor = UIColor.colorWithHex(hexStr: whiteColor)
        sview.font = UIFont.systemFont(ofSize: 14.RW(), weight: .regular)
        
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
        
        addSubview(backView)
        backView.addSubview(iconImageView)
        backView.addSubview(tipLabel)
    }
    
    func showView(type:tipType) {
        
        DispatchQueue.main.async {[weak self] in
            guard let self else {return}
            
            switch type {
            case .suc:
                backView.backgroundColor = UIColor.colorWithHex(hexStr: "#00DF4A")
                tipLabel.text = "Connected"
                iconImageView.image = UIImage(named: "search_connect_suc_icon")
            case .fail:
                backView.backgroundColor = UIColor.colorWithHex(hexStr: "#FF5A3D")
                tipLabel.text = "Connect Failed"
                iconImageView.image = UIImage(named: "search_connect_fail_icon")
            }
            
            tipLabel.sizeToFit()
            
            backView.width = iconImageView.width + tipLabel.width + 32.RW()
            backView.cornerCut(radius: 12.RW(), corner: .allCorners)
            backView.centerX = width / 2
            iconImageView.x = 12.RW()
            iconImageView.centerY = backView.height / 2
            tipLabel.x = iconImageView.x + 8.RW() + iconImageView.width
            tipLabel.centerY = backView.height / 2
            backView.transform = CGAffineTransformMakeScale(0.9, 0.9)
            
            DispatchQueue.main.async {[weak self] in
                
                guard let self else {return}
                cWindow?.addSubview(self)
            }
             
             UIView.animate(withDuration: 0.25) {[weak self] in

                 guard let self else {return}
                 
                 self.backView.transform = CGAffineTransformMakeScale(1, 1);

             } completion: { Bool in

                 DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {[weak self] in
                     
                     guard let self else {return}
                     
                     self.removeFromSuperview()
                 })
             }
        }
        
        
     }
}
