//
//  WebOSRemoteView.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/14.
//

import UIKit

class WebOSRemoteView:DeivceOtherRemoteView {
    
    override func addViews() {
        
        super.addViews()
        
        let array:[Any] = [["norlImage":"deviceVC_power_norl_back","hightLImage":"deviceVC_power_hight_back","iconImage":"roku_power","key":WebOSDevice.WebOSEventKey.Home.rawValue],["iconImage":"roku_back","key":WebOSDevice.WebOSEventKey.Back.rawValue],["iconImage":"roku_home","key":WebOSDevice.WebOSEventKey.Home.rawValue],
                           ["iconImage":"roku_mute","key":WebOSDevice.WebOSEventKey.Mute.rawValue], ["iconImage":"webos_exit","key":WebOSDevice.WebOSEventKey.Exit.rawValue],["iconImage":"roku_rewind","key":WebOSDevice.WebOSEventKey.Rewind.rawValue],["iconImage":"webos_play","key":WebOSDevice.WebOSEventKey.Play.rawValue],["iconImage":"webos_pause","key":WebOSDevice.WebOSEventKey.Pause.rawValue],["iconImage":"roku_fwd","key":WebOSDevice.WebOSEventKey.FastForward.rawValue],["iconImage":"webos_num1","key":WebOSDevice.WebOSEventKey.Num1.rawValue],["iconImage":"webos_num2","key":WebOSDevice.WebOSEventKey.Num2.rawValue],["iconImage":"webos_num3","key":WebOSDevice.WebOSEventKey.Num3.rawValue],["iconImage":"webos_num4","key":WebOSDevice.WebOSEventKey.Num4.rawValue],["iconImage":"webos_num5","key":WebOSDevice.WebOSEventKey.Num5.rawValue],["iconImage":"webos_num6","key":WebOSDevice.WebOSEventKey.Num6.rawValue],["iconImage":"webos_num7","key":WebOSDevice.WebOSEventKey.Num7.rawValue],["iconImage":"webos_num8","key":WebOSDevice.WebOSEventKey.Num8.rawValue],["iconImage":"webos_num9","key":WebOSDevice.WebOSEventKey.Num9.rawValue],["iconImage":"webos_num0","key":WebOSDevice.WebOSEventKey.Num0.rawValue],["iconImage":"webos_listapps","title":"CH LIST","key":WebOSDevice.WebOSEventKey.LiveTV.rawValue],["iconImage":"webos_livetv","title":"LIVE TV","key":WebOSDevice.WebOSEventKey.LiveTV.rawValue],["iconImage":"webos_red","norlImage":"webos_red_norl","hightLImage":"webos_red_hight","key":WebOSDevice.WebOSEventKey.Red.rawValue],["iconImage":"webos_green","norlImage":"webos_green_norl","hightLImage":"webos_green_hight","key":WebOSDevice.WebOSEventKey.Green.rawValue],["iconImage":"webos_yellow","norlImage":"webos_yellow_norl","hightLImage":"webos_yellow_hight","key":WebOSDevice.WebOSEventKey.Yellow.rawValue],["iconImage":"webos_blue","norlImage":"webos_blue_norl","hightLImage":"webos_blue_hight","key":WebOSDevice.WebOSEventKey.Blue.rawValue],["iconImage":"webos_keyboard","title":"KBD", "key":"keyboard"],["iconImage":"webos_search","title":"SEARCH","key":WebOSDevice.WebOSEventKey.Search.rawValue],["iconImage":"webos_input","title":"INPUT","key":WebOSDevice.WebOSEventKey.Input.rawValue],["iconImage":"webos_setting","title":"SETTING","key":WebOSDevice.WebOSEventKey.Setting.rawValue],["iconImage":"webos_guide","title":"GUIDE","key":WebOSDevice.WebOSEventKey.Guide.rawValue],["iconImage":"webos_menu","title":"MENU","key":WebOSDevice.WebOSEventKey.Menu.rawValue],["iconImage":"webos_info","title":"INFO","key":WebOSDevice.WebOSEventKey.Info.rawValue]]
        
       
        let arrStr = JsonUtil.getJSONStringFromArray(array: array)
        
        listModelArray = JsonUtil.jsonArrayToModel(arrStr, DeviceListbtnModel.self) as? [DeviceListbtnModel] ?? []
        
        let array2:[Any] = [["norlImage":"webos_ok_norl_icon","noHight":true,"key":WebOSDevice.WebOSEventKey.Enter.rawValue],["norlImage":"webos_up_norl_icon","noHight":true,"key":WebOSDevice.WebOSEventKey.Up.rawValue],["norlImage":"webos_down_norl_icon","noHight":true,"key":WebOSDevice.WebOSEventKey.Down.rawValue],["norlImage":"webos_right_norl_icon","noHight":true,"key":WebOSDevice.WebOSEventKey.Right.rawValue],["norlImage":"webos_left_norl_icon","noHight":true,"key":WebOSDevice.WebOSEventKey.Left.rawValue]]
        
        let arrStr2 = JsonUtil.getJSONStringFromArray(array: array2)
        
        dirListModelArray = JsonUtil.jsonArrayToModel(arrStr2, DeviceListbtnModel.self) as? [DeviceListbtnModel] ?? []
        
        addListBtn()
        addDirListBtn()
    }
    
    override func addListBtn() {
        
        var startY:CGFloat = marginLR
        
        for (index,smodel) in listModelArray.enumerated() {
            
            var btn:DeviceListBtn?
            
            switch index {
                
            case 0:
                let titleWH:CGFloat = 50.RW()
                btn = DeviceListBtn(frame: CGRect(x: marginLR, y: startY, width: titleWH, height: titleWH))
                startY = 102.RW() + centerHeigit
            case 1..<32:
//                1,2,3,4,5,6,7,8,9
                let listY:CGFloat = 0
                let listStartX:CGFloat = marginLR
                let margerW:CGFloat = 10.RW()
                let margerH:CGFloat = 16.RW()
                let btnH:CGFloat = 60.RW()
                let btnW:CGFloat = 78.RW()
                var Page:Int = 0
                
                var row:Int = (index - 1) / 3
                var column:Int = (index - 1) % 3
                
                btn = DeviceListBtn(frame: CGRect(x: listStartX, y: startY, width: btnW, height: btnH))
                
                if index < 5 {
                    
                    row = (index - 1) / 2
                    column = (index - 1) % 2 + 1
                    Page = 0
                }else if index < 9{
                    
                    row = (index - 5) / 4 + 2
                    column = (index - 5) % 4
                    Page = 0
                }else if index < 21{
                    
                    row = (index - 9) / 4
                    column = (index - 9) % 4
                    Page = 1
                }else {
                    
                    row = (index - 21) / 4
                    column = (index - 21) % 4
                    Page = 2
                }
                
                btn?.x = listStartX + CGFloat(Page) * scrollView.width + CGFloat(column) * (btnW + margerW)
                btn?.y = listY + CGFloat(row) * (btnH + margerH)
                
            default:
                break
            }
            
            guard let mBtn = btn else {return}
            mBtn.model = smodel
            
            mBtn.modelCallBack = {[weak self] model in
                
                guard let self,let smodel = model else {return}
                
                self.callBack(smodel.key)
            }
            
            if index == 0 {
                
                addSubview(mBtn)
            }else {
                
                scrollView.addSubview(mBtn)
            }
            
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
