//
//  UITextFieldX.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/7.
//

import UIKit

class UITextFieldX: UITextField {
    
    var callBack: (_ text:String) ->() = {text in }
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
         
        // 键盘完成按钮
        let toolBar = UIToolbar(frame: CGRectMake(0, 0, ScreenW, 40))
        toolBar.barStyle = UIBarStyle.default
         
        let quxiaoBtn = UIButton(frame: CGRectMake(marginLR, 0, 50, 40))
        quxiaoBtn.setTitleColor(UIColor.colorWithHex(hexStr: "#979797"), for: UIControl.State.normal)
        
        quxiaoBtn.setTitle("Cancel", for: UIControl.State.normal)
        quxiaoBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        quxiaoBtn.addTarget(self, action: #selector(quxiaoBtn(btn:)), for: UIControl.Event.touchUpInside)
        
        let item1 = UIBarButtonItem(customView: quxiaoBtn)
        
        let btnFished = UIButton(frame: CGRectMake(0, 0, 50, 40))
        btnFished.setTitleColor(UIColor.colorWithHex(hexStr: "#7F33FF"), for: UIControl.State.normal)
        
        btnFished.setTitle("Done", for: UIControl.State.normal)
        btnFished.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btnFished.addTarget(self, action: #selector(finishTapped(sender:)), for: UIControl.Event.touchUpInside)
        
        let item3 = UIBarButtonItem(customView: btnFished)
         
        let space = UIView(frame: CGRectMake(marginLR + quxiaoBtn.width, 0, ScreenW - btnFished.frame.width - 2 * marginLR - quxiaoBtn.width, 40))
        let item2 = UIBarButtonItem(customView: space)
         
        toolBar.setItems([item1,item2,item3], animated: true)
         
        self.inputAccessoryView = toolBar
    }
     
    @objc func finishTapped(sender:UIButton){
        
        DispatchQueue.main.async {[weak self] in
            
            guard let self else { return }
            
            self.resignFirstResponder()
        }
        
        callBack(Click_sure)
    }
    
    @objc func quxiaoBtn(btn:UIButton) {
        
        DispatchQueue.main.async {[weak self] in
            
            guard let self else { return }
            
            self.text = ""
            
            self.resignFirstResponder()
        }
        
        callBack(Click_cancel)
    }
 
}


