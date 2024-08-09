//
//  DeviceBaseChoiceView.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/9.
//

import UIKit

class DeviceBaseChoiceView:UIView {
    
    var indexCallBack:(_ index:Int) -> () = {index in}
    
    var titleArray:[String] = []
    var listBtnArray:[UIButton] = []
    var currentIndex:Int = 100 {
        
        didSet {
            
            self.changeWith(newIndex:currentIndex , oldIndex: oldValue)
        }
    }
    
    lazy var backImageView:UIImageView = {
        
        let sview:UIImageView = UIImageView(frame: bounds)
        sview.image = UIImage(named: "deviceVC_choice_back")
        sview.isUserInteractionEnabled = true
        
        return sview
    }()
    
    init(frame: CGRect,titleArray:[String]) {
        
        self.titleArray = titleArray
        
        super.init(frame: frame)
        
        setupUI()
        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        self.backgroundColor = .clear
    }
    
    func addViews() {
        
        addSubview(backImageView)
        addListBtn()
    }
    
    func addListBtn() {
        
        var startX:CGFloat = 4.RW()
        let cW:CGFloat = (backImageView.width - 2 * startX) / CGFloat(titleArray.count)
        let cH:CGFloat = 44.RW()
        
        for text in titleArray {
            
            let btn:UIButton = UIButton(frame: CGRect(x: startX, y: 0, width: cW, height: cH))
            btn.setBackgroundImage(UIImage(named: ""), for: .normal)
            btn.setBackgroundImage(UIImage(named: "deviceVC_choice_sel_back"), for: .selected)
            btn.setTitleColor(UIColor.colorWithHex(hexStr: "#666666"), for: .normal)
            btn.setTitleColor(UIColor.colorWithHex(hexStr: whiteColor), for: .selected)
            btn.setTitle(text, for: .normal)
            btn.addTarget(self, action: #selector(listBtnClick(btn:)), for: .touchUpInside)
            startX += cW
            
            btn.centerY = backImageView.height / 2
            backImageView.addSubview(btn)
            listBtnArray.append(btn)
        }
        
        self.currentIndex = 0
    }
    
    func changeWith(newIndex:Int,oldIndex:Int) {
        
        if newIndex != oldIndex {
            
            getBtnWithIndex(index: newIndex).isSelected = true
            getBtnWithIndex(index: oldIndex).isSelected = false
            
            indexCallBack(newIndex)
        }
    }
    
    @objc func listBtnClick(btn:UIButton) {
        
        var index:Int?
        var title:String = btn.titleLabel?.text ?? ""
        
        for (i,text) in titleArray.enumerated() {
            
            if title == text {
                
                index = i
            }
        }
        
        guard let cI = index else {return}
        
        self.currentIndex = cI
    }
    
    func getBtnWithIndex(index:Int) -> UIButton {
        
        if index < listBtnArray.count {
            
            return listBtnArray[index]
        }else {
            
            return UIButton()
        }
    }
}
