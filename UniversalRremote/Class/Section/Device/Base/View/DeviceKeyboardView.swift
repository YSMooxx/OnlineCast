//
//  DeviceKeyboardView.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/13.
//

import UIKit

class DeviceKeyboardView:BaseShowTipView {
    
    var resultCallBack:callBack = {text in}
    var allresultCallBack:callBack = {text in}
    var allDelete:callBack = {text in}
    var fireModel:FireDevice?
    
    override func setupUI() {
        
        super.setupUI()
        
        backView.height = 238.RW()
        backView.width = 343.RW()
        backView.centerY = (height - navHeight) / 2
        backView.centerX = width / 2
        backView.backgroundColor = UIColor.colorWithHex(hexStr: "#292929")
        backView.cornerCut(radius: 12.RW(), corner: .allCorners)
        
        closeBtn.y = 12.RW()
        closeBtn.x = backView.width - 12.RW() - closeBtn.width
        
        titleLabel.font = UIFont.systemFont(ofSize: 20.RW(), weight: .medium)
        titleLabel.text = "KBD"
        titleLabel.numberOfLines = 0
        titleLabel.width = 297.RW()
        titleLabel.sizeToFit()
        titleLabel.y = 32.RW()
        titleLabel.centerX = backView.width / 2
        
        
        pinTextView.width = backView.width - 60.RW()
        pinTextView.cornerCut(radius: 12.RW(), corner: .allCorners)
        pinTextView.centerX = backView.width / 2
        pinTextView.y = titleLabel.y + titleLabel.height + 20.RW()
        
        tipLabel1.y = pinTextView.y + pinTextView.height + 8.RW()
        tipLabel2.centerY = tipLabel1.centerY
        
        noBtn.y = tipLabel2.y + tipLabel2.height + 24.RW()
        noBtn.width = 130.RW()
        noBtn.height = 44.RW()
        noBtn.x = 30.RW()
        noBtn.cornerCut(radius: 8.RW(), corner: .allCorners)
        
        yesBtn.y = tipLabel2.y + tipLabel2.height + 24.RW()
        yesBtn.width = 130.RW()
        yesBtn.height = 44.RW()
        yesBtn.x = backView.width - 30.RW() - yesBtn.width
        yesBtn.setBackgroundImage(UIImage(named: ""), for: .normal)
        yesBtn.backgroundColor = UIColor.colorWithHex(hexStr: mColor)
        yesBtn.cornerCut(radius: 8.RW(), corner: .allCorners)
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
    
    lazy var pinTextView:noGesTextField = {
        
        let searchHeight:CGFloat = 44.RW()
        
        let sview:noGesTextField = noGesTextField(frame: CGRect(x: marginLR, y:0, width:224.RW(), height: searchHeight))
        sview.backgroundColor = UIColor.colorWithHex(hexStr: "#383838")
        
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.colorWithHex(hexStr: "#666666"), // 设置你想要的颜色
            .font: UIFont.systemFont(ofSize: 14.RW()) // 你也可以设置字体等其他属性
        ]
        
        sview.attributedPlaceholder = NSAttributedString(string: "Enter text to send to TV", attributes: attributes)

        let leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: marginLR, height: searchHeight))
        leftView.backgroundColor = sview.backgroundColor
        sview.leftView = leftView
        sview.leftViewMode = .always
        sview.textAlignment = .left
        sview.tintColor = UIColor.colorWithHex(hexStr: mColor)
        sview.font = UIFont.systemFont(ofSize: 14)
        sview.textColor = UIColor.colorWithHex(hexStr: whiteColor)
        sview.keyboardType = .asciiCapable
        sview.cornerCut(radius: 12.RW(), corner: .allCorners)
        sview.delegate = self
        sview.callBack = {[weak self] (text) in
            
            guard let self else {return}
            
            self.resultCallBack(text)
            
            if self.pinTextView.text?.count ?? 0 <= 0 {
                
                self.allDelete(text)
            }
        }
        sview.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        
        
        return sview
    }()
    
    lazy var tipLabel1:UILabel = {
        
        let tipLabel2:UILabel = UILabel()
        tipLabel2.text = "*"
        tipLabel2.font = UIFont.systemFont(ofSize: 12.RW())
        tipLabel2.textColor = UIColor.colorWithHex(hexStr: "#FF512A")
        tipLabel2.sizeToFit()
        tipLabel2.y = pinTextView.y + pinTextView.height + 8.RW()
        tipLabel2.x = pinTextView.x
        return tipLabel2
    }()
    
    lazy var tipLabel2:UILabel = {
        
        let tipLabel2:UILabel = UILabel()
        tipLabel2.text = "Make sure your  Roku TV is in typing mode"
        tipLabel2.font = UIFont.systemFont(ofSize: 12.RW())
        tipLabel2.textColor = UIColor.colorWithHex(hexStr: "#7F7F7F")
        tipLabel2.sizeToFit()
        tipLabel2.centerY = tipLabel1.centerY - 2
        tipLabel2.x = tipLabel1.x + tipLabel1.width + 1.RW()
        return tipLabel2
    }()
    
    lazy var yesBtn:UIButton = {
       
        let btn:UIButton = UIButton()
        btn.setTitle("Send", for: .normal)
        btn.setTitleColor(UIColor.colorWithHex(hexStr: whiteColor), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14.RW())
        btn.setBackgroundImage(UIImage(named: "search_ok_back"), for: .normal)
        btn.width = 275.RW()
        btn.height = 37.RW()
        btn.addTarget(self, action: #selector(yesBtnClick), for: .touchUpInside)
        btn.cornerCut(radius: 8.RW(), corner: .allCorners)
        return btn
    }()
    
    override func addViews() {
        
        super.addViews()
        
        backView.transform = CGAffineTransformMakeScale(0.9, 0.9);
        backView.alpha = 0.5;
        backView.addSubview(yesBtn)
        backView.addSubview(noBtn)
        backView.addSubview(pinTextView)
        backView.addSubview(tipLabel1)
        backView.addSubview(tipLabel2)
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
        DispatchQueue.main.async {[weak self] in
            guard let self else {return}
            
            self.pinTextView.becomeFirstResponder()
        }
        
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
    
    @objc func yesBtnClick() {
        
        dissMiss()
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
    
    
    
    @objc func textFieldDidChange(textField:UITextField) {
        
        allresultCallBack(textField.text ?? "")
    }
}

extension DeviceKeyboardView:UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let containsChinese = string.range(of: "\\p{Han}", options: .regularExpression) != nil
                
        
        if containsChinese {
            return false
        }
        
        if string.contains("\n") {
            
            return false
        }
        
        // character[endIndex] // endIndex 直接用endIndex会越界,因为endIndex得到的index是字符串的长度,而字符串截取是从下标0开始的,这样直接用会越界
        // 想要获取字符串最后一位
        
        if !string.isEmpty {
            let lastIndex = string.index(before: string.endIndex) // 获取字符串的倒数第二个索引
            let lastChar = string[lastIndex] // 使用索引获取最后一个字符
//            Control.mananger.searchWithString(content:String(lastChar))
            resultCallBack(String(lastChar))
        }
        
        return true
    }
    
}

class noGesTextField: UITextField {
    
    var callBack:callBack = {text in}
    
    override func caretRect(for position: UITextPosition) -> CGRect {
            // 固定光标在当前输入的位置，或者返回 CGRect.zero 隐藏光标
            return super.caretRect(for: self.endOfDocument)
    }
    
    // 禁用选择文本功能（防止双击或长按选中光标移动）
    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        return []
    }

    // 禁止文本选择菜单（如复制、粘贴）
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
    override func deleteBackward() {
        super.deleteBackward()
        callBack("delete")
    }
}
