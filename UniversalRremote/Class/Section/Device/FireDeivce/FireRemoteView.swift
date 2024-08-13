//
//  FireRemoteView.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/13.
//

import UIKit

class FireRemoteView:DeivceRemoteView {
    
    override func addViews() {
        
        super.addViews()
        
        let array:[Any] = [["norlImage":"deviceVC_power_norl_back","hightLImage":"deviceVC_power_hight_back","iconImage":"roku_power","key":FireDevice.FireEventKey.Home.rawValue],["iconImage":"roku_back","key":FireDevice.FireEventKey.Back.rawValue],["iconImage":"roku_home","norlImage":"fire_home_back_norl","hightLImage":"fire_home_back_hight","key":FireDevice.FireEventKey.Home.rawValue],
                           ["iconImage":"roku_rewind","key":FireDevice.FireEventKey.Left.rawValue], ["iconImage":"roku_play","key":FireDevice.FireEventKey.Select.rawValue],["iconImage":"roku_fwd","key":FireDevice.FireEventKey.Right.rawValue],["iconImage":"fire_menu","key":FireDevice.FireEventKey.Info.rawValue],["iconImage":"roku_keyboard","key":"keyboard"],["iconImage":"roku_mute","key":FireDevice.FireEventKey.VolumeMute.rawValue]]
        
        let arrStr = JsonUtil.getJSONStringFromArray(array: array)
        
        listModelArray = JsonUtil.jsonArrayToModel(arrStr, DeviceListbtnModel.self) as? [DeviceListbtnModel] ?? []
        
        let array2:[Any] = [["norlImage":"fire_ok_norl_icon","noHight":true,"key":FireDevice.FireEventKey.Select.rawValue],["norlImage":"fire_up_norl_icon","noHight":true,"key":FireDevice.FireEventKey.Up.rawValue],["norlImage":"fire_down_norl_icon","noHight":true,"key":FireDevice.FireEventKey.Down.rawValue],["norlImage":"fire_right_norl_icon","noHight":true,"key":FireDevice.FireEventKey.Right.rawValue],["norlImage":"fire_left_norl_icon","noHight":true,"key":FireDevice.FireEventKey.Left.rawValue]]
        
        let arrStr2 = JsonUtil.getJSONStringFromArray(array: array2)
        
        dirListModelArray = JsonUtil.jsonArrayToModel(arrStr2, DeviceListbtnModel.self) as? [DeviceListbtnModel] ?? []
        
        addListBtn()
        addDirListBtn()
        
    }
    
    override func addListBtn() {
        
        var startY:CGFloat = 12.RW()
        
        for (index,smodel) in listModelArray.enumerated() {
            
            var btn:DeviceListBtn?
            
            switch index {
                
            case 0:
                let titleWH:CGFloat = 50.RW()
                btn = DeviceListBtn(frame: CGRect(x: marginLR, y: startY, width: titleWH, height: titleWH))
                startY = 102.RW() + centerHeigit
            case 1,2,3,4,5,6,7,8:
                
                let listStartX:CGFloat = marginLR
                let margerW:CGFloat = 10.RW()
                let margerH:CGFloat = 16.RW()
                let btnH:CGFloat = 60.RW()
                let btnW:CGFloat = 78.RW()
                let twoW:CGFloat = 166.RW()
                
                var row:Int = (index - 1) / 3
                var column:Int = (index - 1) % 3
                
                if index == 2 {
                    
                    btn = DeviceListBtn(frame: CGRect(x: listStartX, y: startY, width: twoW, height: btnH))
                    
                }else {
                    
                    if index > 2 {
                        
                        row = (index) / 3
                        column = (index) % 3
                    }
                    
                    btn = DeviceListBtn(frame: CGRect(x: listStartX, y: startY, width: btnW, height: btnH))
                }
                
                btn?.x = listStartX + CGFloat(column) * (btnW + margerW)
                btn?.y = startY + CGFloat(row) * (btnH + margerH)
                
            default:
                break
            }
            
            guard let mBtn = btn else {return}
            mBtn.model = smodel
            
            mBtn.modelCallBack = {[weak self] model in
                
                guard let self,let smodel = model else {return}
                
                self.callBack(smodel.key)
            }
            
            addSubview(mBtn)
        }
    }
    
    override func addDirListBtn() {
        
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
            mBtn.modelCallBack = {[weak self ]model in
                
                guard let self,let smodel = model else {return}
                
                callBack(smodel.key)
            }
            
            dirView.addSubview(mBtn)
        }
    }
}
