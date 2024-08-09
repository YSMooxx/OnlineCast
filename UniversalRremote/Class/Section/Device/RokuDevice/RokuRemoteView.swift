//
//  RokuRemoteView.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/9.
//

import UIKit

class RokuRemoteView:UIView {
    
    lazy var touImage:[String] = ["deviceVC_btn","deviceVC_touch"]
    
    lazy var listModelArray:[DeviceListbtnModel] = {
        
        let array:[Any] = [["norlImage":"deviceVC_power_norl_back","hightLImage":"deviceVC_power_hight_back","iconImage":"roku_power","key":RokuDevice.RokuEventKey.PowerOn.rawValue],["iconImage":"roku_keyboard","key":"keyborad"],["iconImage":"roku_back","key":RokuDevice.RokuEventKey.Back.rawValue],["iconImage":"roku_home","key":RokuDevice.RokuEventKey.Home.rawValue],
                           ["iconImage":"roku_rewind","key":RokuDevice.RokuEventKey.Rev.rawValue], ["iconImage":"roku_play","key":RokuDevice.RokuEventKey.Play.rawValue],["iconImage":"roku_fwd","key":RokuDevice.RokuEventKey.Fwd.rawValue],["iconImage":"roku_info","key":RokuDevice.RokuEventKey.Info.rawValue],["iconImage":"roku_refresh","key":RokuDevice.RokuEventKey.Replay.rawValue],["iconImage":"roku_mute","key":RokuDevice.RokuEventKey.VolumeMute.rawValue]]
        
        let arrStr = JsonUtil.getJSONStringFromArray(array: array)
        
        let modelArray:[DeviceListbtnModel] = JsonUtil.jsonArrayToModel(arrStr, DeviceListbtnModel.self) as? [DeviceListbtnModel] ?? []
        
        return modelArray
    }()
    
    lazy var dirListModelArray:[DeviceListbtnModel] = {
        
        let array:[Any] = [["norlImage":"roku_ok_norl_icon","noHight":true,"key":RokuDevice.RokuEventKey.Select.rawValue],["norlImage":"roku_up_norl_icon","noHight":true,"key":RokuDevice.RokuEventKey.Up.rawValue],["norlImage":"roku_down_norl_icon","noHight":true,"key":RokuDevice.RokuEventKey.Down.rawValue],["norlImage":"roku_right_norl_icon","noHight":true,"key":RokuDevice.RokuEventKey.Right.rawValue],["norlImage":"roku_left_norl_icon","noHight":true,"key":RokuDevice.RokuEventKey.Left.rawValue]]
        
        let arrStr = JsonUtil.getJSONStringFromArray(array: array)
        
        let modelArray:[DeviceListbtnModel] = JsonUtil.jsonArrayToModel(arrStr, DeviceListbtnModel.self) as? [DeviceListbtnModel] ?? []
        
        return modelArray
    }()
    
    lazy var touchBtnView:DeviceTouchBtnView = {
        
        let cW:CGFloat = 92.RW()
        let sview:DeviceTouchBtnView = DeviceTouchBtnView(frame: CGRect(x: width - cW - marginLR, y: 12.RW(), width: cW, height: 50.RW()), titleArray: touImage)
        sview.indexCallBack = {[weak self] index in
            guard let self else {return}
            if index == 0 {
                
                self.dirView.isHidden = false
                self.touchView.isHidden = true
            }else if index == 1 {
                
                self.dirView.isHidden = true
                self.touchView.isHidden = false
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
        
        let sview:UIImageView = UIImageView(image: UIImage(named: "deviceVC_touch_back"))
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
        
        addListBtn()
        addDirListBtn()
    }
    
    func addListBtn() {
        
        var startY:CGFloat = 12.RW()
        
        for (index,smodel) in listModelArray.enumerated() {
            
            var btn:DeviceListBtn?
            
            switch index {
                
            case 0:
                let titleWH:CGFloat = 50.RW()
                btn = DeviceListBtn(frame: CGRect(x: marginLR, y: startY, width: titleWH, height: titleWH))
                startY = 102.RW() + centerHeigit
            case 1,2,3,4,5,6,7,8,9:
                
                let listStartX:CGFloat = marginLR
                let margerW:CGFloat = 10.RW()
                let margerH:CGFloat = 16.RW()
                let btnH:CGFloat = 60.RW()
                let btnW:CGFloat = 78.RW()
                
                let row:Int = (index - 1) / 3
                let column:Int = (index - 1) % 3
                
                btn = DeviceListBtn(frame: CGRect(x: listStartX, y: startY, width: btnW, height: btnH))
                btn?.x = listStartX + CGFloat(column) * (btnW + margerW)
                btn?.y = startY + CGFloat(row) * (btnH + margerH)
                
            default:
                break
            }
            
            guard let mBtn = btn else {return}
            
            mBtn.model = smodel
            addSubview(mBtn)
        }
    }
    
    func addDirListBtn() {
        
        let cW:CGFloat = 154 / 248  *  centerHeigit
        let cH:CGFloat = 72 / 248  *  centerHeigit
        
        for (index,smodel) in dirListModelArray.enumerated() {
            
            var btn:DeviceListBtn?
            
            switch index {
                
            case 0:
                btn = DeviceListBtn(frame: CGRect(x: marginLR, y: 0, width: 102 / 248  *  centerHeigit, height: 102 / 248  *  centerHeigit))
                btn?.centerX = dirView.width / 2
                btn?.centerY = dirView.height / 2
            case 1:
                btn = DeviceListBtn(frame: CGRect(x: marginLR, y: 0, width: cW, height: cH))
                btn?.centerX = dirView.width / 2
                btn?.y = 0
            case 2:
                btn = DeviceListBtn(frame: CGRect(x: marginLR, y: 0, width: cW, height: cH))
                btn?.centerX = dirView.width / 2
                btn?.y = dirView.height - cH
            case 3:
                btn = DeviceListBtn(frame: CGRect(x: marginLR, y: 0, width: cH, height: cW))
                btn?.centerY = dirView.height / 2
                btn?.x = dirView.width - cH
            case 4:
                btn = DeviceListBtn(frame: CGRect(x: marginLR, y: 0, width: cH, height: cW))
                btn?.centerY = dirView.height / 2
                btn?.x = 0
            default:
                break
                
            }
            
            guard let mBtn = btn else {return}
            
            mBtn.model = smodel
            dirView.addSubview(mBtn)
        }
    }
    
    @objc func buttonTouchUp(_ sender: UIButton) {
            
        upVolumBtn.isHighlighted = false
        downVolumBtn.isHighlighted = false
        
        Print(clickType)
        
        clickType = ""
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        
        if gesture.state == .ended {
            let translation = gesture.translation(in: touchView)
            
                    // 水平滑动距离大于垂直滑动距离，认定为水平滑动
            if abs(translation.x) > abs(translation.y) {
                if translation.x > 0 {
                    
                    shock()
//                    self.callBack("right")
                } else {
                    
                    shock()
//                    self.callBack("left")
                }
            } else {
                // 垂直滑动距离大于水平滑动距离，认定为垂直滑动
                if translation.y > 0 {
                    
                    shock()
//                    self.callBack("down")
                } else {
                    
                    shock()
//                    self.callBack("up")
                }
            }
        }
        
   }
    
    
    @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
            if gesture.state == .recognized {
                
                shock()
//                self.callBack(RokuDevice.RokuEventKey.Select.rawValue)
            }
        }
}
