//
//  DeviceChannelResultView.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/12.
//

import UIKit

class DeviceChannelResultView:UIView {
    
    let footerID:String = "ChannelViewControllerFooterID"
    
    var channelIDCallBacl:callBack = {id in}
    
    lazy var model:ChannelResultViewModel =  {
       
        let model :ChannelResultViewModel = ChannelResultViewModel()
        
        model.callBack = {[weak self] (text) in
            
            if text == ChannelResultViewModel.ChangeChangeModelArrayKey {
                
                self?.modelChange()
            }else if text == ChannelResultViewModel.ChangeCollectModelArrayKey {
                
                self?.modelCollectChange()
            }
        }
        
        return model
    }()
    
    lazy var collectionView:UICollectionView = {
        
        let cY:CGFloat = 16.RW()
        
        let layout = WaterfallMutiSectionFlowLayout()
        layout.delegate = self
        let sview:UICollectionView = UICollectionView.init(frame: CGRect(x: marginLR, y: cY, width: width - 2 * marginLR, height: height - cY),  collectionViewLayout: layout)
        
        sview.dataSource = self
        sview.delegate = self
        sview.showsVerticalScrollIndicator = false
        sview.register(ChannelListCollectionCell.self, forCellWithReuseIdentifier: ChannelListCollectionCell.Identifier)
        sview.register(ChannelCollectionSection.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier:ChannelCollectionSection.headerIdef)
        sview.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier:footerID)
        sview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: model.lineSpacing, right: 0)
        sview.backgroundColor = .clear
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
        
        addSubview(collectionView)
    }
    
    func modelChange() {
        
        collectionView.reloadData()
    }
    
    func modelCollectChange() {
        
        collectionView.reloadData()
    }
    
    func getCell(indexPath:IndexPath) -> UICollectionViewCell {
        
        var smodel:ChannelResultListModel?
        let cell:ChannelListCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: ChannelListCollectionCell.Identifier, for: indexPath) as! ChannelListCollectionCell
        
        switch indexPath.section {
            
        case 0:
            
            if indexPath.row < model.collectModelArray.count {
                
                smodel = model.collectModelArray[indexPath.row]
            }
        case 1:
            
            if indexPath.row < model.changeModelArray.count {
                
                smodel = model.changeModelArray[indexPath.row]
            }
            
        default:
            break
            
        }
        
        cell.model = smodel
        
        cell.callBack = {[weak self] text in
            
            guard let self,let smodel1 = smodel else {return}
            
            if smodel?.model != nil {
                
                self.rokuChannelClick(smodel: smodel1, text: text)
            }
            
            if smodel?.fireModel != nil {
                
                self.FireChannelClick(smodel: smodel1, text: text)
            }
        }
        
        return cell
    }
    
    func rokuChannelClick(smodel:ChannelResultListModel,text:String) {
        
        if text == "collect" {
            
            if smodel.model?.isCollect ?? false {
                
                RokuChannelMananger.mananger.addChannelArray(channel: smodel.model ?? RokuChannelResultListDataModel())
            }else {
                
                var index:Int?
                
                for (i,model) in model.collectModelArray.enumerated() {
                    
                    if model.model?.id == smodel.model?.id {
                        
                        index = i
                    }
                }
                
                guard let cIndex = index else { return }
                
                model.collectModelArray.remove(at: cIndex)
                
                var smodelArray:[RokuChannelResultListDataModel] = []
                
                for model in model.collectModelArray {
                    
                    if model.model?.isCollect ?? false {
                        
                        smodelArray.append(model.model ?? RokuChannelResultListDataModel())
                    }
                }
                
                RokuChannelMananger.mananger.removeDeivce(channels: smodelArray)
            }
            
        }else {
            
            channelIDCallBacl(smodel.model?.id ?? "")
        }
    }
    
    func FireChannelClick(smodel:ChannelResultListModel,text:String) {
        
        if text == "collect" {
            
            if smodel.fireModel?.isCollect ?? false {
                
                FireChannelMananger.mananger.addChannelArray(channel: smodel.fireModel ?? FireChannelResultListDataModel())
            }else {
                
                var index:Int?
                
                for (i,model) in model.collectModelArray.enumerated() {
                    
                    if model.fireModel?.appId == smodel.fireModel?.appId {
                        
                        index = i
                    }
                }
                
                guard let cIndex = index else { return }
                
                model.collectModelArray.remove(at: cIndex)
                
                var smodelArray:[FireChannelResultListDataModel] = []
                
                for model in model.collectModelArray {
                    
                    if model.fireModel?.isCollect ?? false {
                        
                        smodelArray.append(model.fireModel ?? FireChannelResultListDataModel())
                    }
                }
                
                FireChannelMananger.mananger.removeDeivce(channels: smodelArray)
            }
            
        }else {
            
            channelIDCallBacl(smodel.fireModel?.appId ?? "")
        }
    }
}

extension DeviceChannelResultView:WaterfallMutiSectionDelegate,UICollectionViewDataSource,UICollectionViewDelegate {
    
    func heightForRowAtIndexPath(collectionView collection: UICollectionView, layout: WaterfallMutiSectionFlowLayout, indexPath: IndexPath, itemWidth: CGFloat) -> CGFloat {
        
        if indexPath.row < model.changeModelArray.count {
            
            let model = model.changeModelArray[indexPath.row]
            
            return model.height
        }else {
            
            return 88.RW()
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 2
    }
    
    func columnNumber(collectionView collection: UICollectionView, layout: WaterfallMutiSectionFlowLayout, section: Int) -> Int {
        
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return model.collectModelArray.count
        case 1:
            
            return model.changeModelArray.count
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return getCell(indexPath: indexPath)
    }
    
    func lineSpacing(collectionView collection: UICollectionView, layout: WaterfallMutiSectionFlowLayout, section: Int) -> CGFloat {
        
        return model.lineSpacing
    }
    
    func interitemSpacing(collectionView collection: UICollectionView, layout: WaterfallMutiSectionFlowLayout, section: Int) -> CGFloat {
        
        return model.interitemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if kind == UICollectionView.elementKindSectionHeader {
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ChannelCollectionSection.headerIdef, for: indexPath) as? ChannelCollectionSection
            
            switch indexPath.section{
                
            case 0,1:
                
                if indexPath.section < model.headModelArray.count {
                    
                    let smodel = model.headModelArray[indexPath.section]
                    
                    header?.model = smodel
                }
                default:
                    break
            }
            
            return header ?? UICollectionReusableView()
            
        }else if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerID, for: indexPath)
            return footer
        }
        
        return UICollectionReusableView()
    }
    
    func referenceSizeForHeader(collectionView collection: UICollectionView, layout: WaterfallMutiSectionFlowLayout, section: Int) -> CGSize {
        
        switch section {
            
        case 0,1:
            
            if section < model.headModelArray.count {
                
                return CGSize(width: collection.width, height: model.headModelArray[section].height)
            }
        default:
            return CGSizeZero
        }
        
        return CGSizeZero
    }
}

class ChannelResultViewModel {
    
    static let ChangeChangeModelArrayKey = "ChangeChangeModelArray"
    static let ChangeCollectModelArrayKey = "ChangeCollectModelArray"
    
    var callBack:callBack = {text in}
    
    var changeModelArray:[ChannelResultListModel] = [] {
        
        didSet {
            
            if changeModelArray.count <= 0 {
                
                headModelArray.last?.height = 0
                headModelArray.last?.isHidden = true
            }else {
                
                if collectModelArray.count <= 0 {
                    
                    headModelArray.last?.height = 32.RW()
                    headModelArray.last?.isHidden = false
                }else {
                    
                    headModelArray.last?.height = 48.RW()
                    headModelArray.last?.isHidden = false
                }
                
            }
            
            callBack(ChannelResultViewModel.ChangeChangeModelArrayKey)
        }
    }
    
    var collectModelArray:[ChannelResultListModel] = [] {
        
        didSet {
            
            if collectModelArray.count <= 0 {
                
                headModelArray.first?.height = 0
                headModelArray.first?.isHidden = true
                
                headModelArray.last?.height = 32.RW()
                headModelArray.last?.isHidden = false
                
            }else {
                
                headModelArray.first?.height = 32.RW()
                headModelArray.first?.isHidden = false
                
                if changeModelArray.count <= 0 {
                    
                    headModelArray.last?.height = 0
                    headModelArray.last?.isHidden = true
                }else {
                    
                    headModelArray.last?.height = 48.RW()
                    headModelArray.last?.isHidden = false
                }
                
            }
            
            callBack(ChannelResultViewModel.ChangeCollectModelArrayKey)
        }
    }
    
    lazy var headModelArray:[ChannelCollectionSectionModel] = {
        
        let array = [["title":"Favorite Channels","height":0.RW()],["title":"All channels","height":48.RW(),"topMar":16.RW()]]
        
        let jsonString = JsonUtil.getJSONStringFromArray(array: array)
        
        let modelArray = JsonUtil.jsonArrayToModel(jsonString, ChannelCollectionSectionModel.self) as? [ChannelCollectionSectionModel]
        
        return modelArray ?? []
        
    }()
    
    let lineSpacing:CGFloat = 8.RW()
    
    let interitemSpacing:CGFloat = 8.RW()
}

