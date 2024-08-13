//
//  FireChannelView.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/13.
//

import UIKit

class FireChannelView:DeviceChannelView {
    
    override func loadData() {
        
        guard let smodel = self.deviceModel as? FireDevice else {return}
        
        smodel.getALlChannel {[weak self] arr in
            
            let arrString = JsonUtil.getJSONStringFromArray(array: arr)
            let modelArray = JsonUtil.jsonArrayToModel(arrString, FireChannelResultListDataModel.self) as? [FireChannelResultListDataModel]
            
            var channelModelArray:[ChannelResultListModel] = []
            
            for subModel in modelArray ?? [] {
                
                let model:ChannelResultListModel = ChannelResultListModel()
                
                subModel.isCollect = false
                
                model.fireModel = subModel
                
                channelModelArray.append(model)
            }
            
            self?.resultView.model.changeModelArray = channelModelArray
            self?.searchView.model.allChangeModelArray = channelModelArray
            self?.setWithArray()
        }
    }
    
    func setWithArray() {
        
        var collectModelArray:[ChannelResultListModel] = []
        
        for smodel in FireChannelMananger.mananger.collectionArray {
            
            let model:ChannelResultListModel = ChannelResultListModel()
            smodel.isCollect = true
            model.fireModel = smodel
            
            for cmodel in  self.resultView.model.changeModelArray{
                
                if smodel.appId == cmodel.fireModel?.appId {
                    
                    cmodel.model?.isCollect = true
                }
            }
            
            collectModelArray.append(model)
        }
        
        self.resultView.model.collectModelArray = collectModelArray
    }
}
