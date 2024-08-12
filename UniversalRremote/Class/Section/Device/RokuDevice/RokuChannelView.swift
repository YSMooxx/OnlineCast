//
//  RokuChannelView.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/9.
//

import UIKit

class RokuChannelView:DeviceChannelView {
    
    override func loadData() {
        
        guard let smodel = self.deviceModel as? RokuDevice else {return}
        
        smodel.getALlChannel {[weak self] arr in
            
            let arrString = JsonUtil.getJSONStringFromArray(array: arr)
            let modelArray = JsonUtil.jsonArrayToModel(arrString, RokuChannelResultListDataModel.self) as? [RokuChannelResultListDataModel]
            
            var channelModelArray:[ChannelResultListModel] = []
            
            for subModel in modelArray ?? [] {
                
                let model:ChannelResultListModel = ChannelResultListModel()
                
                subModel.isCollect = false
                
                model.model = subModel
                
                channelModelArray.append(model)
            }
            
            self?.resultView.model.changeModelArray = channelModelArray
            self?.searchView.model.allChangeModelArray = channelModelArray
            self?.setWithArray()
        }
    }
    
    func setWithArray() {
        
        var collectModelArray:[ChannelResultListModel] = []
        
        for smodel in RokuChannelMananger.mananger.collectionArray {
            
            let model:ChannelResultListModel = ChannelResultListModel()
            smodel.isCollect = true
            model.model = smodel
            
            for cmodel in  self.resultView.model.changeModelArray{
                
                if smodel.id == cmodel.model?.id {
                    
                    cmodel.model?.isCollect = true
                }
            }
            
            collectModelArray.append(model)
        }
        
        self.resultView.model.collectModelArray = collectModelArray
    }
}
