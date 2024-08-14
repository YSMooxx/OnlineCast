//
//  AllTipView.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/14.
//

import UIKit

class AllTipView:UIView {
    
    let tipLabelMinWith:CGFloat = 248.RW()
    static let shard:AllTipView = AllTipView(frame: CGRect(x: 0, y: 0, width: 248.RW() + 2 * marginLR, height: 32.RW() + 12.RW()))
    
    lazy var tipLabel:UILabel = {
        
        let sview:UILabel = UILabel()
        sview.font = UIFont.systemFont(ofSize: 14.RW(), weight: .semibold)
        sview.textColor = UIColor.colorWithHex(hexStr: whiteColor)
        sview.numberOfLines = 0
        sview.textAlignment = .center
        sview.width = tipLabelMinWith
        return sview
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.setupUI()
        self.addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        self.backgroundColor = UIColor.colorWithHex(hexStr: blackColor, alpha: 0.86)
        self.alpha = 0.5;
    }
    
    func addViews() {
        
        addSubview(tipLabel)
    }
    
    func changeFrameWithString(content:String) {
        
        tipLabel.text = content
        tipLabel.width = tipLabelMinWith
        tipLabel.sizeToFit()
        self.width = tipLabel.width + (2 * marginLR)
        self.height = tipLabel.height + (2 * marginLR)
        self.cornerCut(radius: 4.RW(), corner: .allCorners)
        
        self.tipLabel.centerX = self.width  / 2
        self.tipLabel.centerY = self.height / 2
        
        self.centerX = ScreenW / 2
        self.centerY = (ScreenH - tabHeight) / 2
        
        self.transform = CGAffineTransformMakeScale(0.9, 0.9);
        
        cWindow?.addSubview(self)
        
    }
    
    func showViewWithView(content:String) {
        
        DispatchQueue.main.async {[weak self] in
            
            guard let self else {return}
            
            if self.superview != nil {
                
                return
            }
            
            changeFrameWithString(content: content)
            
            UIView.animate(withDuration: 0.25) {[weak self] in

                guard let self else { return }
                
                self.transform = CGAffineTransformMakeScale(1, 1);

                self.alpha = 1;

            } completion: { Bool in
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {[weak self] in
                    
                    self?.removeFromSuperview()
                }
            }
        }
        
    }

}




