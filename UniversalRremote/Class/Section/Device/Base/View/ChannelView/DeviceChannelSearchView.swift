//
//  DeviceChannelSearchView.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/12.
//

import UIKit

class DeviceChannelSearchView:UIView {
    
    let footerID:String = "ChannelViewControllerFooterID"
    
    var callBack:callBack = {text in}
    
    var channelIDCallBacl:callBack = {id in}
    
    lazy var model:ChannelSearchViewModel =  {
       
        let model :ChannelSearchViewModel = ChannelSearchViewModel()
        
        model.callBack = {[weak self] (text) in
            
            if text == ChannelSearchViewModel.ChangeSearchResultModelArrayKey {
                
                self?.modelChange()
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
            
            if indexPath.row < model.searchResultModelArray.count {
                
                smodel = model.searchResultModelArray[indexPath.row]
            }
            
        default:
            break
            
        }
        
        cell.model = smodel
        
        cell.callBack = {[weak self] text in
            
            guard let self else {return}
            
            if text == "collect" {
              
                if smodel?.model?.isCollect ?? false {
                    
                    RokuChannelMananger.mananger.addChannelArray(channel: smodel?.model ?? RokuChannelResultListDataModel())
                }else {
                    
                    var smodelArray:[RokuChannelResultListDataModel] = []
                    
                    for model in model.allChangeModelArray {
                        
                        if model.model?.isCollect ?? false {
                            
                            smodelArray.append(model.model ?? RokuChannelResultListDataModel())
                        }
                    }
                    
                    RokuChannelMananger.mananger.removeDeivce(channels: smodelArray)
                }
                
                collectionView.reloadData()
                
            }else {
                
                channelIDCallBacl(smodel?.model?.id ?? "")
            }
        }
        
        return cell
    }
}

extension DeviceChannelSearchView:WaterfallMutiSectionDelegate,UICollectionViewDataSource,UICollectionViewDelegate {
    
    func heightForRowAtIndexPath(collectionView collection: UICollectionView, layout: WaterfallMutiSectionFlowLayout, indexPath: IndexPath, itemWidth: CGFloat) -> CGFloat {
        
        if indexPath.row < model.searchResultModelArray.count {
            
            let model = model.searchResultModelArray[indexPath.row]
            
            return model.height
        }else {
            
            return 88.RW()
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func columnNumber(collectionView collection: UICollectionView, layout: WaterfallMutiSectionFlowLayout, section: Int) -> Int {
        
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return model.searchResultModelArray.count
        case 1:
            
            return model.searchResultModelArray.count
            
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
                
            case 0:
                
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
            
        case 0:
            
            if section < model.headModelArray.count {
                
                return CGSize(width: collection.width, height: model.headModelArray[section].height)
            }
        default:
            return CGSizeZero
        }
        
        return CGSizeZero
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        callBack("BeginDragging")
    }
}

class ChannelSearchViewModel {
    
    static let ChangeSearchResultModelArrayKey = "ChangeSearchResultModelArrayKey"
//    static let ChangeSearchKeyKey = "ChangeSearchKey"
    
    var callBack:callBack = {text in}
    
    var allChangeModelArray:[ChannelResultListModel] = []
    
    var key:String = "" {
        
        didSet {
            
            if key.count == 0 {
                
                searchResultModelArray = []
            }
            
            var channelModelArray:[ChannelResultListModel] = []
            
            for subModel in allChangeModelArray {

                if key.range(of: (subModel.model?.name ?? ""), options: .caseInsensitive) != nil || (subModel.model?.name ?? "").range(of: (key), options: .caseInsensitive) != nil {
                    channelModelArray.append(subModel)
                }
            }
            
            searchResultModelArray = channelModelArray
        }
    }
    
    var searchResultModelArray:[ChannelResultListModel] = [] {
        
        didSet {
            
            if searchResultModelArray.count <= 0 {
                
                headModelArray.first?.height = 0
            }else {
                
                headModelArray.first?.height = 32.RW()
            }
            
            callBack(ChannelSearchViewModel.ChangeSearchResultModelArrayKey)
        }
    }
    
    lazy var headModelArray:[ChannelCollectionSectionModel] = {
        
        let array = [["title":"All Channels","height":32.RW()]]
        
        let jsonString = JsonUtil.getJSONStringFromArray(array: array)
        
        let modelArray = JsonUtil.jsonArrayToModel(jsonString, ChannelCollectionSectionModel.self) as? [ChannelCollectionSectionModel]
        
        return modelArray ?? []
        
    }()
    
    let lineSpacing:CGFloat = 8.RW()
    
    let interitemSpacing:CGFloat = 8.RW()
}

