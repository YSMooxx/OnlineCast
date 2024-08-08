//
//  AllTipCheckView.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/8.
//

import UIKit

class AllTipCheckView:UIView {
    
    var callBack:callBack = {text in}
    
    lazy var backView:UIView = {
        
        let backView:UIView = UIView()
        backView.height = 267.RW()
        backView.width  = width - 2 * model.CLM
        backView.x = 0
        backView.centerY = height / 2
        backView.backgroundColor = UIColor.colorWithHex(hexStr: "#292929")
        
        return backView
    }()
    
    lazy var titleLabel:UILabel = {
        
        let sview:UILabel = UILabel()
        sview.text = model.tip
        sview.width = width - model.CBLM * 2
        sview.numberOfLines = 0
        sview.font = UIFont.systemFont(ofSize: 14.RW(), weight: .regular)
        sview.textColor = UIColor.colorWithHex(hexStr: whiteColor)
        sview.textAlignment = .center
        sview.sizeToFit()
        sview.width = width - model.CLM * 2
        sview.y = 32.RW()
        sview.centerX = backView.width / 2
        
        return sview
    }()
    
    lazy var noBtn:UIButton = {
       
        let btn:UIButton = UIButton()
        btn.setTitle(model.noTipCheck, for: .normal)
        btn.setTitleColor(UIColor.colorWithHex(hexStr: whiteColor), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14.RW())
        btn.backgroundColor = UIColor.colorWithHex(hexStr: "#575757")
        btn.width = model.leftWidth
        btn.height = model.CH
        btn.y = titleLabel.y + titleLabel.height + 24.RW()
        btn.x = model.CBLM
        btn.addTarget(self, action: #selector(noBtnClick), for: .touchUpInside)
        btn.cornerCut(radius: 8.RW(), corner: .allCorners)
        return btn
    }()
    
    lazy var yesBtn:UIButton = {
       
        let btn:UIButton = UIButton()
        btn.setTitle(model.yesTipCheck, for: .normal)
        btn.backgroundColor = UIColor.colorWithHex(hexStr: mColor)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14.RW())
        btn.width = model.rightWidth
        btn.height = model.CH
        btn.y = titleLabel.y + titleLabel.height + 24.RW()
        btn.x = backView.width - model.CBLM - btn.width
        btn.addTarget(self, action: #selector(yesBtnClick), for: .touchUpInside)
        btn.cornerCut(radius: 8.RW(), corner: .allCorners)
        return btn
    }()
    
    init(frame:CGRect,model: AllTipCheckViewModel) {
        
        self.model = model
        
        super.init(frame: frame)
        
        setupUI()
        
        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model:AllTipCheckViewModel {
        
        didSet {
            
            
        }
    }
    
    func setupUI() {
        
        backgroundColor = UIColor.colorWithHex(hexStr: blackColor, alpha: 0.6)
    }
    
    func addViews() {
        
        addSubview(backView)
        backView.addSubview(titleLabel)
        backView.addSubview(noBtn)
        backView.addSubview(yesBtn)
        
        backView.height = yesBtn.y + yesBtn.height + 32.RW()
        backView.centerX = width / 2
        backView.centerY = (height - tabHeight) / 2
        backView.cornerCut(radius: 12.RW(), corner: .allCorners)
        backView.transform = CGAffineTransformMakeScale(0.9, 0.9)
    }
    
   func showView() {
       
       DispatchQueue.main.async {[weak self] in
           
           guard let self else {return}
           cWindow?.addSubview(self)
       }
        
        UIView.animate(withDuration: 0.25) {[weak self] in

            guard let self else {return}
            
            self.backView.transform = CGAffineTransformMakeScale(1, 1);

            self.backView.alpha = 1;

        } completion: { Bool in

            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if model.isTouchBack {
            
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
    
    func dissMiss() {
        
        callBack("diss")
        self.backView.transform = CGAffineTransformMakeScale(0.9, 0.9)
        self.removeFromSuperview()
    }
    
    @objc func noBtnClick() {
        
        callBack("no")
        
        dissMiss()
    }
    
    @objc func yesBtnClick() {
        
        callBack("yes")
        
        dissMiss()
    }
}

class AllTipCheckViewModel {
    
    var CLM:CGFloat = 20.RW()
    var CBLM:CGFloat = 30.RW()
    var CH:CGFloat = 44.RW()
    var tip:String = ""
    var noTipCheck:String = ""
    var yesTipCheck:String = ""
    var leftWidth:CGFloat = 130.RW()
    var rightWidth:CGFloat = 130.RW()
    var isTouchBack:Bool = true
}

