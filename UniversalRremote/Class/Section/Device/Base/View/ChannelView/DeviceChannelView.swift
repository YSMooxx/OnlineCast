//
//  ChannelView.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/12.
//

import UIKit

class DeviceChannelView:UIView {
    
    var deviceModel:Device?
    
    var channelIDCallBacl:callBack = {id in}
    
    lazy var searchTextFieldX:UITextFieldX = {
       
        let searchHeight:CGFloat = 44.RW()
        let searImageWH:CGFloat = iconWH
        
        let textField:UITextFieldX = UITextFieldX(frame: CGRect(x: marginLR, y:20.RW(), width:width - 2 * marginLR, height: searchHeight))
        textField.backgroundColor = UIColor.colorWithHex(hexStr: cellBackColor,alpha:1)
        textField.returnKeyType = .search
        textField.textAlignment = .left
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.colorWithHex(hexStr: "#939191"), // 设置你想要的颜色
            .font: UIFont.systemFont(ofSize: 14.RW()) // 你也可以设置字体等其他属性
        ]
        
        textField.attributedPlaceholder = NSAttributedString(string: "What are you looking for?", attributes: attributes)

        let leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 44.RW(), height: searchHeight))
        let leftsearchImage:UIImageView = UIImageView(image: UIImage(named: "channel_search_icon"))
        leftsearchImage.width = searImageWH
        leftsearchImage.height = searImageWH
        leftsearchImage.x = 10.RW()
        leftsearchImage.y = (searchHeight - leftsearchImage.height) / 2
        leftView.addSubview(leftsearchImage)
        textField.leftView = leftView
        textField.leftViewMode = .always
        
        textField.tintColor = UIColor.colorWithHex(hexStr: mColor)
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textColor = UIColor.colorWithHex(hexStr: whiteColor)
        textField.delegate = self
        textField.cornerCut(radius: 12.RW(), corner: .allCorners)
        
        textField.callBack = {[weak self] (text) in
            
            if text == "cancel" {
                
                
            }else {
                
                
            }
            
        }
        
        return textField
    }()
    
    lazy var resultView:DeviceChannelResultView = {
        
        let cY:CGFloat = searchTextFieldX.y + searchTextFieldX.height
        
        let sview:DeviceChannelResultView = DeviceChannelResultView(frame: CGRect(x: 0, y: cY, width: width, height: height - cY))
        
        sview.channelIDCallBacl = {[weak self] idt in
            
            self?.channelIDCallBacl(idt)
        }
        
        return sview
    }()
    
    lazy var searchView:DeviceChannelSearchView = {
        
        let cY:CGFloat = searchTextFieldX.y + searchTextFieldX.height
        
        let sview:DeviceChannelSearchView = DeviceChannelSearchView(frame: CGRect(x: 0, y: cY, width: width, height: height - cY))
        
        sview.callBack = {[weak self] (text) in
            
            if text == "BeginDragging" {
                
                self?.searchTextFieldX.resignFirstResponder()
            }
        }
        
        sview.channelIDCallBacl = {[weak self] idt in
            
            self?.channelIDCallBacl(idt)
        }
        
        sview.isHidden = true
        
        return sview
    }()
    
    var isEdit:Bool? {
        
        didSet {
            
            self.changeEdit()
        }
    }
    
    init(frame: CGRect,model:Device) {
        
        self.deviceModel = model
        
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
        
        self.addSubview(searchTextFieldX)
        self.addSubview(resultView)
        self.addSubview(searchView)
    }
    
    func loadData() {
        

    }
    
    func changeEdit() {
        
        guard let isEdit = self.isEdit else {return}
        
        if isEdit {
            
            searchView.isHidden = false
            searchView.model.key = searchTextFieldX.text ?? ""
            resultView.isHidden = true
        }else {
            
            if searchTextFieldX.text?.count != 0 {
                
                searchView.isHidden = false
                resultView.isHidden = true
            }else {
                
                searchView.isHidden = true
                resultView.isHidden = false
            }
            
        }
    }
}

extension DeviceChannelView:UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        self.searchView.model.key = textField.text ?? ""
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.isEdit = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.text?.count == 0 {
            
            self.isEdit = false
        }else {
            
            self.isEdit = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        searchTextFieldX.resignFirstResponder()
        
        return true
    }
}
