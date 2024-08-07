//
//  RemoteDRenameView.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/7.
//

import UIKit

class RemoteDRenameView:UIView {
    
    var callBack:callBack = {text in}
    
    var resultCallBack:callBack = {text in}
    
    lazy var backView:UIView = {
        
        let sview:UIView = UIView()
        sview.height = 216.RW()
        sview.width = 343.RW()
        sview.centerX = width / 2
        sview.centerY = (height - statusBarHeight - 44) / 2
        sview.backgroundColor = UIColor.colorWithHex(hexStr: "#292929")
        sview.cornerCut(radius: 12.RW(), corner: .allCorners)
        return sview
    }()
    
    lazy var closeBtn:UIButton = {
        
        let cWH:CGFloat = 24.RW()
        let cXY:CGFloat = 12.RW()
        let sview:UIButton = UIButton()
        sview.width = cWH
        sview.height = cWH
        sview.x = backView.width - cWH - cXY
        sview.y = cXY
        sview.setBackgroundImage(UIImage(named: "remoteD_close_icon"), for: .normal)
        sview.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
        
        return sview
    }()
    
    lazy var titleLabel:UILabel = {
        
        let sview:UILabel = UILabel()
        sview.font = UIFont.systemFont(ofSize: 20.RW(), weight: .medium)
        sview.textColor = UIColor.colorWithHex(hexStr: whiteColor)
        sview.text = "Rename"
        sview.sizeToFit()
        sview.centerX = backView.width / 2
        sview.y = 32.RW()
        return sview
    }()
    
    lazy var textFieldX:UITextFieldX = {
       
        let searchHeight:CGFloat = 44.RW()
        let searImageWH:CGFloat = 24.RW()
        
        let textField:UITextFieldX = UITextFieldX(frame: CGRect(x: marginLR, y:titleLabel.y + titleLabel.height + 16.RW(), width:311.RW(), height: searchHeight))
        textField.centerX = backView.width / 2
        textField.backgroundColor = UIColor.colorWithHex(hexStr: "#383838",alpha:1)
        textField.returnKeyType = .done
        textField.textAlignment = .center
        textField.textColor = UIColor.colorWithHex(hexStr: whiteColor)
        textField.font = UIFont.systemFont(ofSize: 14.RW(), weight: .regular)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.colorWithHex(hexStr: "#939191"), // 设置你想要的颜色
            .font: UIFont.systemFont(ofSize: 14.RW()) // 你也可以设置字体等其他属性
        ]
        
        textField.attributedPlaceholder = NSAttributedString(string: "Change...", attributes: attributes)

        textField.cornerCut(radius: 12.RW(), corner: .allCorners)
        
        textField.callBack = {[weak self] (text) in
            
            if text == Click_sure {
                
                
            }else if text == Click_cancel{
                
                
            }
            
        }
        
        return textField
    }()
    
    lazy var cancelBtn:UIButton = {
        
        let cXY:CGFloat = 12.RW()
        let sview:UIButton = UIButton()
        sview.width = 116.RW()
        sview.height = 44.RW()
        sview.centerX = 98.RW()
        sview.y = textFieldX.y + textFieldX.height + 24.RW()
        sview.backgroundColor = UIColor.colorWithHex(hexStr: "#575757")
        sview.titleLabel?.font = UIFont.systemFont(ofSize: 16.RW(), weight: .medium)
        sview.setTitle("Cancel", for: .normal)
        sview.setTitleColor(UIColor.colorWithHex(hexStr: whiteColor), for: .normal)
        sview.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
        sview.cornerCut(radius: 12.RW(), corner: .allCorners)
        
        return sview
    }()
    
    lazy var saveBtn:UIButton = {
        
        let cXY:CGFloat = 12.RW()
        let sview:UIButton = UIButton()
        sview.width = 116.RW()
        sview.height = 44.RW()
        sview.x = cancelBtn.x + cancelBtn.width + 31.RW()
        sview.y = textFieldX.y + textFieldX.height + 24.RW()
        sview.backgroundColor = UIColor.colorWithHex(hexStr: "#7F33FF")
        sview.titleLabel?.font = UIFont.systemFont(ofSize: 16.RW(), weight: .medium)
        sview.setTitle("Save", for: .normal)
        sview.setTitleColor(UIColor.colorWithHex(hexStr: whiteColor), for: .normal)
        sview.addTarget(self, action: #selector(saveBtnClick), for: .touchUpInside)
        sview.cornerCut(radius: 12.RW(), corner: .allCorners)
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
        
        backgroundColor = UIColor.colorWithHex(hexStr: blackColor, alpha: 0.6)
    }
    
    func addViews() {
        
        addSubview(backView)
        backView.addSubview(closeBtn)
        backView.addSubview(titleLabel)
        backView.addSubview(textFieldX)
        backView.addSubview(cancelBtn)
        backView.addSubview(saveBtn)
        backView.transform = CGAffineTransformMakeScale(0.9, 0.9)
    }
    
    func showView(content:String) {
        
        DispatchQueue.main.async {[weak self] in
            
            guard let self else {return}
            self.textFieldX.text = content
            cWindow?.addSubview(self)
            self.textFieldX.becomeFirstResponder()
        }
        
        UIView.animate(withDuration: 0.25) {[weak self] in

            guard let self else {return}
            
            self.backView.transform = CGAffineTransformMakeScale(1, 1);

        } completion: { Bool in

            
        }
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
    
    func dissMiss(isCallBack:Bool = true) {
        
        if isCallBack {
            
            callBack(Click_close)
        }
        
        textFieldX.resignFirstResponder()
        self.backView.transform = CGAffineTransformMakeScale(0.9, 0.9)
        self.removeFromSuperview()
    }
    
    @objc func closeBtnClick() {
        
        dissMiss()
    }
    
    @objc func saveBtnClick() {
        
        let result:String = textFieldX.text ?? ""
        
        dissMiss(isCallBack:false)
        
        resultCallBack(result)
    }
}
