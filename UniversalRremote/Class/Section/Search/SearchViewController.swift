//
//  SearchViewController.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/8.
//

import UIKit

var defaultDeviceArray:[Device] = []

class SearchViewController:LDBaseViewController {
    
    var status:SearchViewModel.SearchStatus? {
        
        didSet {
            
            switch self.status {
                
            case .startLoading:
                self.searchView.model.deviceModelArray = defaultDeviceArray
                SSDPDiscovery.shared.discoverService(forDuration: 15, searchTarget: AllTag, port: 1900)
            case .haveData,.noData:
                SSDPDiscovery.shared.stop()
                refreshBtn.isHidden = false
            case .noNet:
                refreshBtn.isHidden = true
            case .noLocalNet:
                refreshBtn.isHidden = false
            default:
                break
            }
            
            self.searchView.model.status = self.status
        }
    }
    
    lazy var searchView:SearchView = {
        let cY:CGFloat = titleView.y + titleView.height
        let sview:SearchView = SearchView(frame: CGRect(x: 0, y: cY, width: view.width, height: view.height - cY))
        
        sview.callBack = {[weak self] (text) in
            
            guard let self else { return}
            
            if text == "noWiftClick" {
                
                gotoSettings(url: set_wifi)
            }else if text == "noResultClick" {
                
                self.checkStatus()
            }
        }
        
        sview.modelCallBack = {[weak self] (model) in
            
            guard let self else {return}
            
            self.clickModel(model: model)
        }
        
        return sview
    }()
    
    lazy var refreshBtn:UIButton = {
       
        let refreshBtn:UIButton = UIButton()
        refreshBtn.width = iconWH
        refreshBtn.height = iconWH
        refreshBtn.centerY = titleView.titleLabel.centerY
        refreshBtn.x = titleView.width - 16.RW() - refreshBtn.width
        refreshBtn.setImage(UIImage(named: "search_refresh_icon"), for: .normal)
        refreshBtn.addTarget(self, action: #selector(refreshBtnClick(btn:)), for: .touchUpInside)
        refreshBtn.isHidden = true
        return refreshBtn
    }()
    
    lazy var noLocalNetTipView:AllTipCheckView = {
        
        let tipModel:AllTipCheckViewModel = AllTipCheckViewModel()
        tipModel.tip = "Permission to access local network needed."
        tipModel.noTipCheck = "Cancel"
        tipModel.yesTipCheck = "Go To Setting"
        let tipView:AllTipCheckView = AllTipCheckView(frame: view.bounds, model: tipModel)
        
        tipView.callBack = {[weak self] text in
            
            if text == "yes" {
                
                gotoSettings(url: set_wifi)
            }
        }
        
        return tipView
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        titleView.model.title = "Search Device"
        
        SSDPDiscovery.shared.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(LocalNetworkNotification(_:)), name: Notification.Name("LocalNetwork_Change"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: Notification.Name("NetWork_Change"), object: nil)
        
        checkStatus()
    }
    
    override func addViews() {
        
        super.addViews()
        
        view.addSubview(searchView)
        
        titleView.addSubview(refreshBtn)
    }
    
    func addDevice() {
        
        var deviceArray:[Device] = []
        
        for _ in 0..<5 {
            
            let array:[String] = [Roku,Fire,WebOS]
            let index:Int = Int(arc4random() % UInt32(array.count))
            
            let deivce:Device = Device(url: "http://192.168.50.2/dd.xml", ip: "192.168.50.2")
            deivce.friendlyName = array[index]
            deivce.type = array[index]
            
            deviceArray.append(deivce)
        }
        
        searchView.model.deviceModelArray = deviceArray
        
    }
    
    func checkStatus() {
        
        if NetStatusManager.manager.currentStatus == .WIFI {
            
            if LMLocalNetworkAuthorization.mananger.currentStatus == nil {
                
                LMLocalNetworkAuthorization.mananger.requestAuthorization { text in
                    
                    LMLocalNetworkAuthorization.mananger.currentStatus = text
                }
            }else {
                
                if LMLocalNetworkAuthorization.mananger.currentStatus ?? false {
                    
                    self.status = .startLoading
                }else {
                    
                    showNoLocalNetView()
                    
                    self.status = .noLocalNet
                }
            }
            
        }else {
            
            self.status = .noNet
        }
        
    }
    
    @objc func handleNotification(_ notification: Notification) {
        
        if let userInfo = notification.userInfo {
            if let message = userInfo["status"] as? NetStatus {
                
                if message == .WIFI {
                    checkStatus()
                }else {
                    
                    self.status = .noNet
                }
            }
        }
    }
    
    @objc func LocalNetworkNotification(_ notification: Notification?) {
        
        if let userInfo = notification?.userInfo {
            guard let _ = userInfo["status"] as? Bool else {return}
            
            if UserDef.shard.locaNetwork != nil {
                
                checkStatus()
            }else {
                
                if NetStatusManager.manager.currentStatus == .WIFI {
                    
                    if LMLocalNetworkAuthorization.mananger.currentStatus ?? false {
                        
                        self.status = .startLoading
                    }else {
                        
                        self.status = .noLocalNet
                    }
                    
                }else {
                    
                    status = .noNet
                }
                
                UserDef.shard.locaNetwork = true
                UserDef.shard.saveUserDefToSandBox()
            }
        }
        
    }
    
    override func didMove(toParent parent: UIViewController?) {
        
        super.didMove(toParent: parent)
        
        if (parent == nil)  {
            SSDPDiscovery.shared.delegate = nil
            SSDPDiscovery.shared.stop()
        }
        
    }
    
    func showNoLocalNetView() {
        
        noLocalNetTipView.showView()
    }
    
    @objc func refreshBtnClick(btn:UIButton) {
        
        btn.isHidden = true
        checkStatus()
    }
    
    func clickModel(model:searchDeviceCellModel) {
        
        guard let smodel = model.smodel else {return}
        
        if smodel.type == Roku {
            
            guard let rokuDevice = smodel as? RokuDevice else {return}
            
            self.rokuClick(rokuModel: rokuDevice) {[weak self] text in
                
                guard let self else {return}
                if text == Load_suc {
                    
                    for smodel in self.searchView.resultView.deviceModelArray {
                        
                        smodel.isConnect = false
                    }
                    
                    model.isConnect = true
                    
                    self.searchView.resultView.tableView.reloadData()
                }
            }
        }
    }
    
    func rokuClick(rokuModel:RokuDevice,sucstatus:@escaping callBack = {status in}) {
        
        AllTipLoadingView.loadingShared.showView()
        
        rokuModel.connectDevice { suc in
            
            if suc == Load_suc {
                
                RemoteDMananger.mananger.addDeviceArray(device: rokuModel)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    
                    sucstatus(Load_suc)
                    AllTipLoadingView.loadingShared.dissMiss()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {[weak self] in
                        
                        let vc:RokuViewController = RokuViewController(model: rokuModel)
                        
                        self?.navigationController?.pushViewController(vc, animated: true)
                    })
                    
                })
                
            }else {
                
                sucstatus(Load_fail)
            }
            
           
        }
    }
    
    deinit {
        SSDPDiscovery.shared.stop()
        NotificationCenter.default.removeObserver(self)
        Print("xiaohui")
    }
    
}

extension SearchViewController:SSDPDiscoveryDelegate { 
    
    func ssdpDiscovery(_ discovery: SSDPDiscovery, didDiscoverService service: SSDPService) {
        
        Print("host-----------\(service.host)")
        Print("location-----------\(String(describing: service.location))")
        Print("service-----------\(String(describing: service.server))")
        Print("uniqueServiceName-----------\(String(describing: service.uniqueServiceName))")
        Device.getTypeDeviceWith(servece: service) {[weak self] device in
            
            guard let self else {return}
            
            if !defaultDeviceArray.contains(where: { $0.ip == device.ip }) {

                defaultDeviceArray.append(device)
                self.searchView.model.deviceModelArray = defaultDeviceArray
            }
        }
    }
    
    func ssdpDiscoveryDidFinish(_ discovery: SSDPDiscovery) {
        
        if NetStatusManager.manager.currentStatus == .WIFI {
            
            if self.searchView.model.deviceModelArray.count != 0 {
                
                self.status = .haveData
            }else {
                
                self.status = .noData
            }
        }
    }
}

