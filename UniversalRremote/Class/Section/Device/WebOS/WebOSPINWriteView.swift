//
//  WebOSPINWriteView.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/13.
//


import UIKit

class WebOSPINWriteView:BaseShowTipView {
    
    var resultCallBack:callBack = {text in}
    
    override func setupUI() {
        
        super.setupUI()
        
        backView.height = 216.RW()
        backView.width = 343.RW()
        backView.centerY = (height - navHeight) / 2
        backView.centerX = width / 2
        backView.backgroundColor = UIColor.colorWithHex(hexStr: "#292929")
        backView.cornerCut(radius: 12.RW(), corner: .allCorners)
        
        closeBtn.y = 12.RW()
        closeBtn.x = backView.width - 12.RW() - closeBtn.width
        
        titleLabel.font = UIFont.systemFont(ofSize: 20.RW(), weight: .medium)
        titleLabel.text = "Pairing with device"
        titleLabel.numberOfLines = 0
        titleLabel.width = 297.RW()
        titleLabel.sizeToFit()
        titleLabel.y = 32.RW()
        titleLabel.centerX = backView.width / 2
        
        
        pinTextView.width = backView.width - 60.RW()
        pinTextView.cornerCut(radius: 12.RW(), corner: .allCorners)
        pinTextView.centerX = backView.width / 2
        pinTextView.y = titleLabel.y + titleLabel.height + 20.RW()
        
        errorLabel.y = pinTextView.y + pinTextView.height + 6.RW()
        errorLabel.centerX = backView.width / 2
        
        noBtn.y = pinTextView.y + pinTextView.height + 24.RW()
        noBtn.width = 130.RW()
        noBtn.height = 44.RW()
        noBtn.x = 30.RW()
        noBtn.cornerCut(radius: 8.RW(), corner: .allCorners)
        
        yesBtn.y = pinTextView.y + pinTextView.height + 24.RW()
        yesBtn.width = 130.RW()
        yesBtn.height = 44.RW()
        yesBtn.x = backView.width - 30.RW() - yesBtn.width
        yesBtn.setBackgroundImage(UIImage(named: ""), for: .normal)
        yesBtn.backgroundColor = UIColor.colorWithHex(hexStr: mColor)
        yesBtn.cornerCut(radius: 8.RW(), corner: .allCorners)
        pinTextView.becomeFirstResponder()
       
    }
    
    lazy var noBtn:UIButton = {
       
        let btn:UIButton = UIButton()
        btn.setTitle("Cancel", for: .normal)
        btn.setTitleColor(UIColor.colorWithHex(hexStr: "#575757"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14.RW())
        btn.backgroundColor = UIColor.colorWithHex(hexStr: "#F5F5F5")
        btn.width = 275.RW()
        btn.height = 37.RW()
        btn.addTarget(self, action: #selector(noBtnClick), for: .touchUpInside)
        
        return btn
    }()
    
//    lazy var pinTextView:PinTextView = {
//
//        let sview:PinTextView = PinTextView(frame: CGRect(x: marginLR, y:0, width:224.RW(), height: 44.RW()))
//
//        sview.callBack = {[weak self] text in
//
//            self?.checkText()
//        }
//
//        return sview
//    }()
    
    lazy var pinTextView:UITextField = {
        
        let searchHeight:CGFloat = 44.RW()
        
        let sview:UITextField = UITextField(frame: CGRect(x: marginLR, y:0, width:224.RW(), height: searchHeight))
        sview.backgroundColor = UIColor.colorWithHex(hexStr: "#383838")
        
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.colorWithHex(hexStr: "#666666"), // 设置你想要的颜色
            .font: UIFont.systemFont(ofSize: 14.RW()) // 你也可以设置字体等其他属性
        ]
        
        sview.attributedPlaceholder = NSAttributedString(string: "Please enter the pin code", attributes: attributes)

        let leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: marginLR, height: searchHeight))
        leftView.backgroundColor = sview.backgroundColor
        sview.leftView = leftView
        sview.leftViewMode = .always
        sview.textAlignment = .left
        sview.tintColor = UIColor.colorWithHex(hexStr: mColor)
        sview.font = UIFont.systemFont(ofSize: 14)
        sview.textColor = UIColor.colorWithHex(hexStr: whiteColor)
        sview.keyboardType = .numberPad
        sview.cornerCut(radius: 12.RW(), corner: .allCorners)
        
        return sview
    }()
    
    lazy var yesBtn:UIButton = {
       
        let btn:UIButton = UIButton()
        btn.setTitle("OK", for: .normal)
        btn.setTitleColor(UIColor.colorWithHex(hexStr: whiteColor), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14.RW())
        btn.setBackgroundImage(UIImage(named: "search_ok_back"), for: .normal)
        btn.width = 275.RW()
        btn.height = 37.RW()
        btn.addTarget(self, action: #selector(yesBtnClick), for: .touchUpInside)
        btn.cornerCut(radius: 8.RW(), corner: .allCorners)
        return btn
    }()
    
    lazy var errorLabel:UILabel = {
        
        let sview:UILabel = UILabel()
        
        sview.text = "Incorrect PIN code."
        sview.textColor = UIColor.colorWithHex(hexStr: "#FF5A43")
        sview.font = UIFont.systemFont(ofSize: 12.RW(), weight: .regular)
        sview.sizeToFit()
        sview.isHidden = true
        return sview
    }()
    
    override func addViews() {
        
        super.addViews()
        
        backView.transform = CGAffineTransformMakeScale(0.9, 0.9);
        backView.alpha = 0.5;
        backView.addSubview(yesBtn)
        backView.addSubview(noBtn)
        backView.addSubview(pinTextView)
        backView.addSubview(errorLabel)
        
    }
    
    @objc func connectBtnClick() {
        
        dissMiss() {[weak self] (text) in
            
            if text == "diss" {
                
                self?.callBack("sure")
            }
        }
    }
    
    override func showView() {
        
        cWindow?.addSubview(self)
        
        UIView.animate(withDuration: 0.25) {[weak self] in

            self?.backView.transform = CGAffineTransformMakeScale(1, 1);

            self?.backView.alpha = 1;

        } completion: { Bool in

            
        }
    }
    
    override func dissMiss(suc: @escaping callBack = {text in}) {
        
        callBack("cancel")
        self.removeFromSuperview()
    }
    
    func checkText() {
        
        let text = pinTextView.text ?? ""
        
        if text.count == 8 {
            
            resultCallBack(text)
            
        }else {
            
            self.seterror()
        }
    }
    
    func seterror() {
        
//        pinTextView.restore()
        pinTextView.text = ""
        shakeAnimation()
        errorLabel.isHidden = false
    }
    
    @objc func yesBtnClick() {
        
        checkText()
    }
    
    @objc func noBtnClick() {
        
        dissMiss()
    }
    
    func shakeAnimation(){
    //移除self.mineTopView.layer上的所有动画，可以避免多次重复添加
    self.backView.layer.removeAllAnimations()
            let momAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            momAnimation.fromValue = NSNumber(value: -0.1) //左幅度
            momAnimation.toValue = NSNumber(value: 0.1) //右幅度
            momAnimation.duration = 0.1
            momAnimation.repeatCount = 2 //无限重复
            momAnimation.autoreverses = true //动画结束时执行逆动画

            self.backView.layer.add(momAnimation, forKey: "centerLayer")
    }
}
