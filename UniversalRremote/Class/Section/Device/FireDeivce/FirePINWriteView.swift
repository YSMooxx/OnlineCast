//
//  FirePINWriteView.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/13.
//

import UIKit

class FirePINWriteView:BaseShowTipView {
    
    var resultCallBack:callBack = {text in}
    
    var fireModel:FireDevice?
    
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
        
        if text.count == 4 {
            
            fireModel?.checkPin(pin: text, suc: {[weak self] pin in
                
                guard let self else {return}
                
                if pin == Load_fail {
                    
                    self.seterror()
                }else {
                    
                    self.resultCallBack(pin)
                }
                
                self.dissMiss()

            })
            
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

class PinTextView: UIView {
    
    var callBack:callBack = {text in }
    
    let firstTextField = CustomTextField()
    let secondTextField = CustomTextField()
    let thirdTextField = CustomTextField()
    let fourthTextField = CustomTextField()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupUI() {
        
        self.backgroundColor = .clear
        
        setupTextField(firstTextField, placeholder: "", tag: 1)
        setupTextField(secondTextField, placeholder: "", tag: 2)
        setupTextField(thirdTextField, placeholder: "", tag: 3)
        setupTextField(fourthTextField, placeholder: "", tag: 4)
        
        let stackView = UIStackView(arrangedSubviews: [firstTextField, secondTextField, thirdTextField, fourthTextField])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 16.RW()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            firstTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupTextField(_ textField: CustomTextField, placeholder: String, tag: Int) {
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        textField.delegate = self
        textField.customDelegate = self
        textField.tag = tag
        textField.textColor = .white
        textField.backgroundColor = UIColor.colorWithHex(hexStr: "#332D2D")
        textField.font = UIFont.systemFont(ofSize: 14.RW(), weight: .bold)
        textField.tintColor = UIColor.colorWithHex(hexStr: mColor)
    }
    
    func becomFires() {
        
        firstTextField.becomeFirstResponder()
    }
    
    func getString() -> String {
        
        let text:String = (firstTextField.text ?? "") + (secondTextField.text ?? "") + (thirdTextField.text ?? "") + (fourthTextField.text ?? "")
        
        return text
    }
    
    func checkStatu() -> Bool {
        
        let text:String = getString()
        
        if text.count == 4 {
            
            return true
        }else {
            
            return false
        }
    }
    
    func restore() {
        
        firstTextField.text = ""
        secondTextField.text = ""
        thirdTextField.text = ""
        fourthTextField.text = ""
        firstTextField.becomeFirstResponder()
    }
    
}

extension PinTextView:CustomTextFieldDelegate {
    
    func textFieldDidDelete(_ textField: UITextField) {
        
        switch textField.tag {
        case 2:
            firstTextField.becomeFirstResponder()
        case 3:
            secondTextField.becomeFirstResponder()
        case 4:
            thirdTextField.becomeFirstResponder()
        default:
            break
        }
    }
    
    
}

extension PinTextView:UITextFieldDelegate {
    
    // UITextFieldDelegate method to handle text input and move to the next field
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if newText.count > 1 {
            
            if textField.text?.count == 1 {
                switch textField.tag {
                case 1:
                    secondTextField.becomeFirstResponder()
                case 2:
                    thirdTextField.becomeFirstResponder()
                case 3:
                    fourthTextField.becomeFirstResponder()
                case 4:break
                default:
                    break
                }
            }
            
            return false
        }
        
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
//        if textField.text?.count == 0 {
//
//            switch textField.tag {
//            case 2:
//                firstTextField.becomeFirstResponder()
//            case 3:
//                secondTextField.becomeFirstResponder()
//            case 4:
//                thirdTextField.becomeFirstResponder()
//            default:
//                break
//            }
//        }
        
        if textField.text?.count == 1 {
            switch textField.tag {
            case 1:
                secondTextField.becomeFirstResponder()
            case 2:
                thirdTextField.becomeFirstResponder()
            case 3:
                fourthTextField.becomeFirstResponder()
            case 4:break
            default:
                break
            }
        }
        
    }
}


protocol CustomTextFieldDelegate: AnyObject {
    func textFieldDidDelete(_ textField: UITextField)
}

class CustomTextField: UITextField {
    
    weak var customDelegate: CustomTextFieldDelegate?

    override func deleteBackward() {
        super.deleteBackward()
        customDelegate?.textFieldDidDelete(self)
    }
}


