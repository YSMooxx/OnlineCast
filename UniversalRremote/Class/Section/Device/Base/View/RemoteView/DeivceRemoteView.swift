//
//  DeivceRemoteView.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/12.
//

import UIKit

class DeivceRemoteView:UIView {
    
    lazy var touImage:[String] = ["deviceVC_btn","deviceVC_touch"]
    
    var listModelArray:[DeviceListbtnModel] = []
    
    var dirListModelArray:[DeviceListbtnModel] = []
    
    var callBack:callBack = {text in}
    
    lazy var touchBtnView:DeviceTouchBtnView = {
        
        let cW:CGFloat = 92.RW()
        let sview:DeviceTouchBtnView = DeviceTouchBtnView(frame: CGRect(x: width - cW - marginLR, y: 12.RW(), width: cW, height: 50.RW()), titleArray: touImage)
        sview.indexCallBack = {[weak self] index in
            guard let self else {return}
            if index == 0 {
                
                self.dirView.isHidden = false
                self.touchView.isHidden = true
                self.callBack("dir")
            }else if index == 1 {
                
                self.dirView.isHidden = true
                self.touchView.isHidden = false
                self.callBack("touch")
            }
        }
        
        return sview
    }()
    
    lazy var volumeBackImage:UIButton = {
        
        let xW:CGFloat = 78.RW()
        
        let sview:UIButton = UIButton(frame: CGRect(x: width - xW - marginLR, y: centerHeigit + 102.RW(), width: xW, height: 212.RW()))
        sview.setBackgroundImage(UIImage(named: "deviceVC_volum_norl_icon"), for: .normal)
        sview.setBackgroundImage(UIImage(named: "deviceVC_volum_height_icon"), for: .highlighted)
        sview.addTarget(self, action: #selector(buttonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside])
        
        return sview
    }()
    
    var clickType:String = ""
    
    lazy var upVolumBtn:volumBtn = {
        
        let  sview:volumBtn = volumBtn()
        sview.width = 34.RW()
        sview.height = 34.RW()
        sview.centerX = volumeBackImage.width / 2
        sview.y = 24.RW()
        sview.setBackgroundImage(UIImage(named: "deviceVC_volumup_norl_icon"), for: .normal)
        sview.callBack = {[weak self] (text) in
            
            self?.clickType = "up"
        }
        
        return sview
    }()
    
    lazy var downVolumBtn:volumBtn = {
        
        let  sview:volumBtn = volumBtn()
        sview.width = 34.RW()
        sview.height = 34.RW()
        sview.centerX = volumeBackImage.width / 2
        sview.y = volumeBackImage.height - 24.RW() - sview.height
        sview.setBackgroundImage(UIImage(named: "deviceVC_volumdown_norl_icon"), for: .normal)
        sview.callBack = {[weak self] (text) in
            
            self?.clickType = "down"
        }
        
        return sview
    }()
    
    lazy var volunTipImage:UIImageView = {
        
        let sview:UIImageView = UIImageView(image: UIImage(named: "deviceVC_volum_tip"))
        sview.width = 34.RW()
        sview.height = 34.RW()
        sview.centerX = volumeBackImage.width / 2
        sview.centerY = volumeBackImage.height / 2
        
        return sview
    }()
    
    lazy var dirView:UIView = {
        
        let sview:UIView = UIView(frame: CGRect(x: 0, y: 0, width: centerHeigit, height: centerHeigit))
        
        sview.centerX = width / 2
        sview.y = 78.RW()
        
        return sview
    }()
    
    lazy var touchView:UIImageView = {
        
        let backString = centerHeigit < 247.RW() ? "deviceVC_remote_smaltouch_back" : "deviceVC_touch_back"
        
        let sview:UIImageView = UIImageView(image: UIImage(named: backString))
        sview.width = width - 2 * marginLR
        sview.height = centerHeigit
        sview.centerX = width / 2
        sview.y = 78.RW()
        sview.isUserInteractionEnabled = true
        sview.isHidden = true
        sview.addGestureRecognizer(panGesture)
        sview.addGestureRecognizer(tapGesture)
        panGesture.require(toFail: tapGesture)
        return sview
    }()
    
    lazy var panGesture:UIPanGestureRecognizer = {
        
        let panGesture:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        
        return panGesture
    }()
    
    
    lazy var tapGesture:UITapGestureRecognizer = {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        tapGesture.numberOfTapsRequired = 1
        
        return tapGesture
    }()
    
    let allContentHeight:CGFloat = 478
    let allHMargin:CGFloat = 108
    let otherHeight:CGFloat = 230
    lazy var centerHeigit:CGFloat = {
        
        if height < (allContentHeight + allHMargin).RW() {
            
           return  height  - allHMargin.RW() - otherHeight.RW()
        }else {
            
            return 248.RW()
        }
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
        
        addSubview(touchBtnView)
        addSubview(volumeBackImage)
        addSubview(dirView)
        addSubview(touchView)
        volumeBackImage.addSubview(upVolumBtn)
        volumeBackImage.addSubview(volunTipImage)
        volumeBackImage.addSubview(downVolumBtn)
        
//        addListBtn()
//        addDirListBtn()
    }
    
    func addListBtn() {
        
    
    }
    
    func addDirListBtn() {
        
        
    }
    
    @objc func buttonTouchUp(_ sender: UIButton) {
            
        upVolumBtn.isHighlighted = false
        downVolumBtn.isHighlighted = false
        
        if clickType == "up" {
            
            callBack("volumup")
        }else if clickType == "down" {
            
            callBack("volumdown")
        }
        
        clickType = ""
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        
        if gesture.state == .ended {
            let translation = gesture.translation(in: touchView)
            
                    // 水平滑动距离大于垂直滑动距离，认定为水平滑动
            if abs(translation.x) > abs(translation.y) {
                if translation.x > 0 {
                    
                    if dirListModelArray.count == 5 {
                        
                        self.callBack(dirListModelArray[3].key)
                    }
                } else {
                    
                    if dirListModelArray.count == 5 {
                        
                        self.callBack(dirListModelArray[4].key)
                    }
                }
            } else {
                // 垂直滑动距离大于水平滑动距离，认定为垂直滑动
                if translation.y > 0 {
                    
                    if dirListModelArray.count == 5 {
                        
                        self.callBack(dirListModelArray[2].key)
                    }
                } else {
                    
                    if dirListModelArray.count == 5 {
                        
                        self.callBack(dirListModelArray[1].key)
                    }
                }
            }
        }
        
   }
    
    
    @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        if gesture.state == .recognized {
            
            if dirListModelArray.count == 5 {
                
                self.callBack(dirListModelArray[0].key)
            }
        }
    }
}
