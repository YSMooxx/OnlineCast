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
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    
                    SSDPDiscovery.shared.discoverService(forDuration: 15, searchTarget: AllTag, port: 1900)
                })
                logEvent(eventId: search_device)
            case .haveData:
                DispatchQueue.main.async {[weak self] in
                    
                    self?.refreshBtn.isHidden = false
                }
                
            case .noNet,.noData:
                DispatchQueue.main.async {[weak self] in
                    
                    self?.refreshBtn.isHidden = true
                }
            case .noLocalNet:
                DispatchQueue.main.async {[weak self] in
                    
                    self?.refreshBtn.isHidden = false
                }
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
    
    lazy var searchConnectTipView:SearchConnectTipView = {
        
        let sview:SearchConnectTipView = SearchConnectTipView(frame: CGRect(x: 0, y: 0, width: ScreenW, height: ScreenH))
        
        return sview
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
    
    lazy var writePin:WebOSPINWriteView = {
        
        let sview:WebOSPINWriteView = WebOSPINWriteView()
        
        return sview
    }()
    
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
                    
                    SSDPDiscovery.shared.stop()
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
    
//    override func didMove(toParent parent: UIViewController?) {
//        
//        super.didMove(toParent: parent)
//        
//        if (parent == nil)  {
//            
//            SSDPDiscovery.shared.stop()
//            SSDPDiscovery.shared.delegate = nil
//        }
//        
//    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        SSDPDiscovery.shared.stop()
        SSDPDiscovery.shared.delegate = nil
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
                
                AllTipLoadingView.loadingShared.dissMiss()
                
                if text == Load_suc {
                    
                    for smodel in self.searchView.resultView.deviceModelArray {
                        
                        smodel.isConnect = false
                    }
                    
                    model.isConnect = true
                    
                    self.searchView.resultView.tableView.reloadData()
                    
                    self.searchConnectTipView.showView(type: .suc)
                    
                    logEvent(eventId: device_connect_success,param: ["device":"Roku-" + smodel.friendlyName])
                }else if text == Load_fail {
                    
                    self.searchConnectTipView.showView(type: .fail)
                }
            }
            
            logEvent(eventId: device_click_connect,param: ["device":"Roku-" + String(smodel.friendlyName.prefix(5))])
        }else if smodel.type == Fire {
            
            guard let fireDevice = smodel as? FireDevice else {return}
            
            self.fireClick(fireModel: fireDevice) {[weak self] text in
                
                guard let self else {return}
                
                AllTipLoadingView.loadingShared.dissMiss()
                
                if text == Load_suc {
                    
                    for smodel in self.searchView.resultView.deviceModelArray {
                        
                        smodel.isConnect = false
                    }
                    
                    model.isConnect = true
                    
                    self.searchView.resultView.tableView.reloadData()
                    
                    self.searchConnectTipView.showView(type: .suc)
                    
                    logEvent(eventId: device_connect_success,param: ["device":"Fire-" + smodel.friendlyName])
                    
                }else if text == Load_fail{
                    
                    self.searchConnectTipView.showView(type: .fail)
                    
                }else if text == Click_cancel {
                    
                    
                }
            }
            
            logEvent(eventId: device_click_connect,param: ["device":"Fire-" + smodel.friendlyName])
        }else if smodel.type == WebOS {
            
            guard let webDevice = smodel as? WebOSDevice else {return}
            
            self.checkWebOSStatus(webOSModel: webDevice) { status in
                
                AllTipLoadingView.loadingShared.dissMiss()
                
                if status == Load_fail{
                    
                    self.searchConnectTipView.showView(type: .fail)
                    
                }else if status == Click_cancel {
                    
                    
                }else if status == Load_suc {
                    
                    for smodel in self.searchView.resultView.deviceModelArray {
                        
                        smodel.isConnect = false
                    }
                    
                    model.isConnect = true
                    
                    self.searchView.resultView.tableView.reloadData()
                    
                    self.searchConnectTipView.showView(type: .suc)
                    
                    logEvent(eventId: device_connect_success,param: ["device":"LG-" + smodel.friendlyName])
                }
            }
            
            logEvent(eventId: device_click_connect,param: ["device":"LG-" + smodel.friendlyName])
        }
        
        
    }
    
    func rokuClick(rokuModel:RokuDevice,sucstatus:@escaping callBack = {status in}) {
        
        AllTipLoadingView.loadingShared.showView()
        
        rokuModel.connectDevice {[weak self] suc in
            
            if suc == Load_suc {
                
                let newDevice:RokuDevice = RokuDevice(device: rokuModel)
                
                RemoteDMananger.mananger.addDeviceArray(device: newDevice)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    
                    sucstatus(Load_suc)
                    AllTipLoadingView.loadingShared.dissMiss()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {[weak self] in
                        
                        guard let self else {return}
                        
                        let vc:RokuViewController = RokuViewController(model: newDevice,isRConnet: false)
                        
                        self.navigationController?.pushViewController(vc, animated: true)

                    })
                    
                })
                
            }else {
                
                sucstatus(Load_fail)
            }
            
        }
    }
    
    func fireClick(fireModel:FireDevice,sucstatus:@escaping callBack = {status in}) {
        
        AllTipLoadingView.loadingShared.showView()
        
        self.checkFireStatus(subModel: fireModel) {[weak self] status in
            
            guard let self else {return}
            
            self.checkStatusTime = nil
            
            if status == Load_suc {
                
                fireModel.showPin { text in
                    
                    if text == Load_suc {
                        
                        let writePin:FirePINWriteView = FirePINWriteView()
                        writePin.fireModel = fireModel
                        writePin.showView()
                        writePin.callBack = {text in
                            
                            if text == Load_error {
                                
                                fireModel.showPin { text in
                                    
                                    if text == Load_fail {
                                        
                                        sucstatus(text)
                                    }
                                }
                                
                            }else {
                                
                                sucstatus(text)
                            }
                            
                        }
                        
                        writePin.resultCallBack = {text in
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                                
                                fireModel.token = text
                                
                                fireModel.getVoice { isVoice in
                                    
                                    guard let voice = isVoice else {sucstatus(Load_fail);return }
                                    
                                    AllTipLoadingView.loadingShared.showView()
                                    
                                    fireModel.isVolum = voice
                                    
                                    let newDevice:FireDevice = FireDevice(device: fireModel)
                                    
                                    RemoteDMananger.mananger.addDeviceArray(device: newDevice)
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                        
                                        sucstatus(Load_suc)
                                        AllTipLoadingView.loadingShared.dissMiss()
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {[weak self] in
                                            
                                            let vc:FireViewController = FireViewController(model: newDevice,isRConnet: false)
                                            
                                            self?.navigationController?.pushViewController(vc, animated: true)
                                        })
                                        
                                    })
                                }
                                
                            })
                            
                        }
                        
                    }else {
                        
                        sucstatus(text)
                    }
                }
                
            }else {
                     
                sucstatus(status)

            }
        }
        
    }
    
    var checkStatusTime:Int64?
    
    func checkFireStatus(subModel:FireDevice,suc:@escaping callBack = {text in}) {
        
        if checkStatusTime != nil {
            
            if (checkStatusTime ?? 0) + 5 < Int64(Date().timeIntervalSince1970) {
                
                checkStatusTime = nil
                Print("status--------超时")
                suc(Load_fail)
                return
            }
            
        }else {
            
            checkStatusTime = Int64(Date().timeIntervalSince1970)
        }
        
        subModel.checkStatus(suc: {[weak self] text in
            
            guard let self else{ return}
            
            if text == Load_suc {
                
                self.checkStatusTime = nil
                Print("status--------成功")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    
                    suc(text)
                })
                
            }else {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {[weak self] in
                    
                    guard let self else {return}
                    
                    self.checkFireStatus(subModel: subModel, suc: {text in
                        suc(text)
                    })
                })
                
            }
            
        })
    }
    
    var iscanConnect:Bool = false
    
    var timer: Timer?
    
    var startTime:TimeInterval?
    
    func startTimer(webOSModel:WebOSDevice,suc:@escaping callBack = {text in}) {
        
        DispatchQueue.main.async {[weak self] in
            
            guard let self else {return}
            
            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {[weak self] timer in
                
                guard let self else {return}
                
                if iscanConnect  {
                    self.stopTimer(webOSModel: webOSModel)
                }else {
                    
                    if (self.startTime ?? 0) + 10 < getNowTimeInterval() {
                        
                        webOSModel.callBackStatus = {status,content in }
                        suc(Load_fail)
                        webOSModel.disconnect()
                        self.stopTimer(webOSModel: webOSModel)
                    }
                }
            }
        }
    }

    
    func stopTimer(webOSModel:WebOSDevice) {
        
        startTime = nil
        timer?.invalidate()
        timer = nil
    }
    
    var timer2: Timer?
    
    var startTime2:TimeInterval?
    
    var iscanWritet:Bool = false
    
    func startTimer2(webOSModel:WebOSDevice,suc:@escaping callBack = {text in}) {
        
        DispatchQueue.main.async {[weak self] in
            
            guard let self else {return}
            
            self.timer2 = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {[weak self] timer in
                
                guard let self else {return}
                
                if iscanWritet  {
                    self.stopTimer2(webOSModel: webOSModel)
                }else {
                    
                    if (self.startTime2 ?? 0) + 10 < getNowTimeInterval() {
                        
                        webOSModel.callBackStatus = {status,content in }
                        suc(Load_fail)
                        webOSModel.disconnect()
                        self.writePin.pinTextView.text = nil
                        self.writePin.removeFromSuperview()
                        self.stopTimer2(webOSModel: webOSModel)
                    }
                }
            }
        }
    }

    
    func stopTimer2(webOSModel:WebOSDevice) {
        
        startTime2 = nil
        timer2?.invalidate()
        timer2 = nil
    }
    
    func checkWebOSStatus(webOSModel:WebOSDevice,suc:@escaping callBack = {text in}) {
        
        AllTipLoadingView.loadingShared.showView()
        
        self.startTime = getNowTimeInterval()
        startTimer(webOSModel: webOSModel) { status in
            
            suc(status)
        }
        
        webOSModel.connectDevice()
        
        webOSModel.callBackStatus = {[weak self] status,content in
            guard let self else {return}
            
            switch status{
            case .didConnect: break
                
            case .didDisplayPin:
                
                self.iscanConnect = true
                DispatchQueue.main.async {[weak self] in
                    
                    guard let self else {return}
                    
                    self.writePin.showView()
                    self.writePin.resultCallBack = { text in
                        
                        AllTipLoadingView.loadingShared.showView()
                        
                        self.startTime2 = getNowTimeInterval()
                        self.startTimer2(webOSModel: webOSModel, suc: {status in
                            
                            suc(status)
                        })
                        webOSModel.checkPin(pin: text)
                    }
                    
                    self.writePin.callBack = {text in
                        
                        if text == "cancel" {
                            webOSModel.canCelPin()
                            webOSModel.didDisconnect()
                        }
                        suc(text)
                    }
                }
            case .didRegister:
                
                let newDevice:WebOSDevice = WebOSDevice(device: webOSModel)
                self.iscanWritet = true
                newDevice.token = content
//                newDevice.client = webOSModel.client
                RemoteDMananger.mananger.addDeviceArray(device: newDevice)
                
                DispatchQueue.main.async {[weak self] in
                    
                    self?.writePin.pinTextView.text = nil
                    self?.writePin.removeFromSuperview()
                }
                
                webOSModel.disconnect()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    
                    suc(Load_suc)
                    
                    webOSModel.callBackStatus = { status,text in
                        
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {[weak self] in
//                        
                        let vc:WebOSViewController = WebOSViewController(model:newDevice,isRConnet: true)
                        
                        self?.navigationController?.pushViewController(vc, animated: true)
                    })
                    
                })
                
            case .pinError:
                self.iscanWritet = true
                AllTipLoadingView.loadingShared.dissMiss()
                webOSModel.connectDevice()
                DispatchQueue.main.async {[weak self] in
                    
                    self?.writePin.seterror()
                }
            case .error:
                
                self.stopTimer2(webOSModel: webOSModel)
                suc(Load_fail)
                
                DispatchQueue.main.async {[weak self] in
                    self?.writePin.pinTextView.text = nil
                    self?.writePin.removeFromSuperview()
                }
                
                webOSModel.disconnect()
                
            default:
                break
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
            
            logEvent(eventId: search_support_device,param: ["name":device.friendlyName])
        }
    }
    
    func ssdpDiscoveryDidFinish(_ discovery: SSDPDiscovery) {
        
        if NetStatusManager.manager.currentStatus == .WIFI {
            
            if self.searchView.model.deviceModelArray.count != 0 {
                
                self.status = .haveData
            }else {
                
                self.status = .noData
                logEvent(eventId: no_device)
            }
        }
    }
}

