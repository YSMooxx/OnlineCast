//
//  RemoteView.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/7.
//

import UIKit

class RemoteView:UIView {
    
    var callBack:callBack = {text in}
    
    var clickCallBack:(_ device:Device) -> () = {device in}
    
    lazy var model:RemoteViewModel = {
        
        let smodel:RemoteViewModel = RemoteViewModel()
        
        smodel.callBack = {[weak self] (text) in
            
            guard let self else {return}
            if text == RemoteViewModel.changedeviceModelArrayKey {
                
                self.changedeviceModelArray()
            }
        }
        
        return smodel
    }()
    
    lazy var navView:RemoteNavView = {
        
        let sview:RemoteNavView = RemoteNavView(frame: CGRect(x: 0, y: 0, width: ScreenW, height: navHeight))
        
        sview.callBack = {[weak self] (text) in
            
            if text == "setting" {
                
                self?.callBack(text)
            }else if text == "add" {
                
//                self?.addDevice()
                self?.callBack(text)
            }
        }
        
        return sview
    }()
    
    lazy var resultView:RemoteResultView = {
        
        let cY:CGFloat = navView.y + navView.height
        let cW:CGFloat = width - 2 * marginLR
        
        let sview:RemoteResultView = RemoteResultView(frame: CGRect(x: marginLR, y: cY, width: cW, height: height - cY))
        
        sview.clickCallBack = {[weak self] model in
            
            guard let self, let smodel = model else {return}
            
            self.clickCallBack(smodel)
        }
        
        return sview
    }()
    
    lazy var noResultView:RemoteDNoResultView = {
        
        let cY:CGFloat = navView.y + navView.height
        let cW:CGFloat = width - 2 * marginLR
        
        let sview:RemoteDNoResultView = RemoteDNoResultView(frame: CGRect(x: marginLR, y: cY, width: cW, height: height - cY))
        
        sview.callBack = {[weak self] (text) in
            
            if text == "add" {
                
//                self?.addDevice()
                self?.callBack(text)
            }
        }
        
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
        
        
    }
    
    func addViews() {
        
        addSubview(navView)
        addSubview(resultView)
        addSubview(noResultView)
    }
    
    func addDevice() {
        
        let array:[String] = [Roku,Fire,WebOS]
        let index:Int = Int(arc4random() % UInt32(array.count))
        
        let deivce:Device = Device(url: "http://192.168.50.2/dd.xml", ip: "192.168.50.2")
        deivce.reName = array[index]
        deivce.type = array[index]
        
        RemoteDMananger.mananger.addDeviceArray(device: deivce)
    }
    
    func changedeviceModelArray() {
        
        DispatchQueue.main.async {[weak self] in
            
            guard let self else {return}
            
            if model.deviceModelArray.count == 0 {
                
                resultView.isHidden = true
                noResultView.isHidden = false
            }else {
                
                resultView.isHidden = false
                noResultView.isHidden = true
                
                var modelArray:[RemoteDListCollectionCellModel] = []
                
                for deviceModel in self.model.deviceModelArray {
                    
                    let smodel:RemoteDListCollectionCellModel = RemoteDListCollectionCellModel()
                    smodel.smodel = deviceModel
                    modelArray.append(smodel)
                }
                
                resultView.deviceModelArray = modelArray
            }
        }
    }
}

class RemoteViewModel {
    
    static let changedeviceModelArrayKey:String = "changedeviceModelArray"
    
    var callBack:callBack = {text in}
    
    var deviceModelArray:[Device] = [] {
        
        didSet {
            
            callBack(RemoteViewModel.changedeviceModelArrayKey)
        }
    }
}
