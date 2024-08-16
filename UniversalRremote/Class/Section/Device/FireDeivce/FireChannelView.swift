//
//  FireChannelView.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/13.
//

import UIKit

class FireChannelView:DeviceChannelView {
    
    lazy var loadingModel:AllTipLoadingViewModel = {
        
        let smodel:AllTipLoadingViewModel = AllTipLoadingViewModel()
        
        smodel.maxWH = 104.RW()
        smodel.title = "Loading"
        
        return smodel
    }()
    
    lazy var loadingView:AllTipLoadingView = {
        
        let sview:AllTipLoadingView = AllTipLoadingView(model: loadingModel)
        
        sview.frame = bounds
        
        sview.backView.centerY = (sview.height - navHeight) / 2
        
        sview.isHidden = true
        
        return sview
    }()
    
    override func addViews() {
        
        super.addViews()
        
        addSubview(loadingView)
    }
    
    override func loadData() {
        
        guard let smodel = self.deviceModel as? FireDevice else {return}
        
        self.loadShowDiss(iSD: true)
        
        smodel.getALlChannel {[weak self] arr in
            
            guard let self else {return}
            
            self.loadShowDiss(iSD: false)
            
            let arrString = JsonUtil.getJSONStringFromArray(array: arr)
            let modelArray = JsonUtil.jsonArrayToModel(arrString, FireChannelResultListDataModel.self) as? [FireChannelResultListDataModel]
            
            var channelModelArray:[ChannelResultListModel] = []
            
            for subModel in modelArray ?? [] {
                
                let model:ChannelResultListModel = ChannelResultListModel()
                
                subModel.isCollect = false
                
                model.fireModel = subModel
                
                channelModelArray.append(model)
            }
            
            self.resultView.model.changeModelArray = channelModelArray
            self.searchView.model.allChangeModelArray = channelModelArray
            self.setWithArray()
        }
    }
    
    func setWithArray() {
        
        var collectModelArray:[ChannelResultListModel] = []
        
        for cmodel in self.resultView.model.changeModelArray {
            
            cmodel.fireModel?.isCollect = false
        }
        
        for smodel in FireChannelMananger.mananger.collectionArray {
            
            let model:ChannelResultListModel = ChannelResultListModel()
            smodel.isCollect = true
            model.fireModel = smodel

            for cmodel in  self.resultView.model.changeModelArray{
                
                if smodel.appId == cmodel.fireModel?.appId {
                    
                    cmodel.fireModel?.isCollect = true
                }
            }
            
            collectModelArray.append(model)
        }
        
        self.resultView.model.collectModelArray = collectModelArray
    }
    
    func loadShowDiss(iSD:Bool) {
        
        DispatchQueue.main.async {[weak self] in
            
            guard let self else {return}
            
            if iSD {
                
                self.loadingView.loadingAnimation.play()
            }else {
                
                self.loadingView.loadingAnimation.pause()
            }
            
            self.loadingView.isHidden = !iSD
        }
        
    }
}
