//
//  SearchView.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/8.
//

import UIKit
import Lottie

class SearchView:UIView {
    
    var callBack:callBack = {text in}
    
    var modelCallBack:(_ model:searchDeviceCellModel) -> () = {model in}
    
    lazy var model:SearchViewModel = {
        
        let smodel:SearchViewModel = SearchViewModel()
        
        smodel.callBack = {[weak self] (text) in
            
            guard let self else {return}
            if text == SearchViewModel.changeDeviceModelArrayKey {
                
                self.changedeviceModelArray()
            }else if text == SearchViewModel.changeStatusKey {
                
                self.changeStatus()
            }
        }
        
        return smodel
    }()
     
    lazy var loadingAnimation:AnimationView = {
        
        let animationView = Lottie.AnimationView(name: "search_loading")
            
        animationView.width = 100.RW()
        animationView.height = 100.RW()
        animationView.centerX = width / 2
        animationView.y = marginLR
        animationView.loopMode = .loop
        animationView.play()
        return animationView
    }()
    
    lazy var loadingTipLabel : UILabel = {
        
        let sview:UILabel = UILabel()
        sview.text = "Searching..."
        sview.font = UIFont.systemFont(ofSize: 14.RW(), weight: .regular)
        sview.textColor = UIColor.colorWithHex(hexStr: whiteColor)
        sview.sizeToFit()
        sview.centerX = width / 2
        sview.y = loadingAnimation.y + loadingAnimation.height + 8.RW()
        return sview
        
    }()
    
    lazy var resultView:SearchResultView = {
        
        let sview:SearchResultView = SearchResultView(frame: bounds)
        
        sview.modelCallBack = {[weak self] (model) in
            
            guard let self ,let smodel = model else {return}
            
            self.modelCallBack(smodel)
        }
        
        return sview
    }()
    
    lazy var noWifiView:SearchNoWifiView = {
        
        let sview:SearchNoWifiView = SearchNoWifiView(frame: bounds)
        
        sview.callBack = {[weak self] text in
            guard let self else {return}
            if text == Click_allClick {
                
                self.callBack("noWiftClick")
            }
        }
        
        sview.isHidden = true
        
        return sview
    }()
    
    lazy var noResultView:SearchNoResultView = {
        
        let sview:SearchNoResultView = SearchNoResultView(frame: bounds)
        
        sview.callBack = {[weak self] text in
            guard let self else {return}
            if text == Click_allClick {
                
                self.callBack("noResultClick")
            }
        }
        
        sview.isHidden = true
        
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
        
        addSubview(loadingAnimation)
        addSubview(loadingTipLabel)
        addSubview(noWifiView)
        addSubview(noResultView)
        addSubview(resultView)
    }
    
    func changedeviceModelArray() {
        
        var array:[searchDeviceCellModel] = []
        
        for smodel in model.deviceModelArray {
            
            let model:searchDeviceCellModel = searchDeviceCellModel()
            model.smodel = smodel
            
            array.append(model)
        }
        
        resultView.deviceModelArray = array
    }
    
    func changeStatus() {
        
        DispatchQueue.main.async {[weak self] in
            
            guard let self else {return}
            
            switch model.status {
                
            case .startLoading:
                loadingAnimation.play()
                loadingAnimation.isHidden = false
                resultView.y = loadingTipLabel.y + loadingTipLabel.height + 20.RW()
                resultView.height = height - resultView.y
                resultView.isHidden = false
                noWifiView.isHidden = true
                noResultView.isHidden = true
            case .haveData:
                loadingAnimation.pause()
                loadingAnimation.isHidden = true
                resultView.y = 0
                resultView.height = height
                resultView.isHidden = false
                noWifiView.isHidden = true
                noResultView.isHidden = true
            case .noData,.noLocalNet:
                loadingAnimation.pause()
                loadingAnimation.isHidden = true
                resultView.isHidden = true
                noWifiView.isHidden = true
                noResultView.isHidden = false
            case .noNet:
                loadingAnimation.pause()
                loadingAnimation.isHidden = true
                resultView.isHidden = true
                noWifiView.isHidden = false
                noResultView.isHidden = true
            default:
                break
            }
            
            loadingTipLabel.isHidden = loadingAnimation.isHidden
        }
    }
}

class SearchViewModel {
    
    static let changeDeviceModelArrayKey:String = "Search_ChangeDeviceModelArray"
    static let changeStatusKey:String = "Search_changeStatus"
    
    var callBack:callBack = {text in}
    
    enum SearchStatus {
        case startLoading
        case haveData
        case noNet
        case noData
        case noLocalNet
    }
    
    var deviceModelArray:[Device] = [] {
        
        didSet {
            
            callBack(SearchViewModel.changeDeviceModelArrayKey)
        }
    }
    
    var status:SearchStatus? {
        
        didSet {
            
            callBack(SearchViewModel.changeStatusKey)
        }
    }
}
