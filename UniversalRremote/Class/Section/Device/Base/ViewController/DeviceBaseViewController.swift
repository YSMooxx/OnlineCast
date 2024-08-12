//
//  DeviceBaseViewController.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/9.
//

import UIKit
import Lottie

enum connectStatusType {
    
    case startConnect
    case sucConnect
    case failConnect
}

class DeviceBaseViewController:LDBaseViewController {
    
    var model:DeviceBaseViewModel = DeviceBaseViewModel()
    
    var connectStatus:connectStatusType? {
        
        didSet {
            
            changeConnectStatus()
        }
    }
    
    lazy var titleBtn:SelectableButton = {
        
        let titleBtn:SelectableButton = SelectableButton()
        titleBtn.setTitle("Click to Connect", for: .normal)
        titleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16.RW(), weight: .medium)
        titleBtn.setTitleColor(UIColor.colorWithHex(hexStr: whiteColor), for: .normal)
        titleBtn.setTitleColor(UIColor.colorWithHex(hexStr: whiteColor), for: .selected)
        titleBtn.setImage(UIImage.svgWithName(name: "deviceVC_client_nor_tip", size: CGSize(width: iconWH, height: iconWH)), for: .normal)
        titleBtn.setImage(UIImage.svgWithName(name: "deviceVC_client_sel_tip", size: CGSize(width: iconWH, height: iconWH)), for: .selected)
        titleBtn.addTarget(self, action: #selector(titleBtnClick(btn:)), for: .touchDown)
        titleBtn.titleLabel?.lineBreakMode = .byTruncatingTail
        titleBtn.sizeToFit()
        titleBtn.width += 10.RW()
        titleBtn.centerY = (titleView.height - statusBarHeight) / 2 + statusBarHeight
        titleBtn.centerX = titleView.width / 2
        titleBtn.changBtnWithStytl(btnStyle: .defalut, margin: 10.RW())
        
        return titleBtn
    }()
    
    lazy var settingsBtn:EnlargeBtn = {
        
        let sview:EnlargeBtn = EnlargeBtn(frame: CGRect(x: 0, y: navCenterY, width: iconWH, height: iconWH))
        sview.width = iconWH
        sview.height = iconWH
        sview.x = titleView.width - marginLR - sview.width
        sview.centerY = navCenterY
        sview.setBackgroundImage(UIImage(named: "remoteD_settings_icon"), for: .normal)
        sview.addTarget(self, action: #selector(settingsBtnClick), for: .touchUpInside)
        
        return sview
    }()
    
    lazy var loadingAnimation:AnimationView = {
        
        let animationView = Lottie.AnimationView(name: "All_loading")
            
        animationView.width = titleBtn.imageView?.width ?? 0
        animationView.height = titleBtn.imageView?.width ?? 0
        animationView.centerX = titleBtn.imageView?.centerX ?? 0
        animationView.centerY = titleBtn.imageView?.centerY ?? 0
        animationView.loopMode = .loop
        animationView.play()
        return animationView
    }()
    
    init(model:Device) {
        
        self.model.smodel = model
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        titleView.model.titleHidden = true
    }
    
    override func addViews() {
        
        super.addViews()
        
        titleView.addSubview(titleBtn)
        titleView.addSubview(settingsBtn)
        titleBtn.addSubview(loadingAnimation)
        
        titleBtn.imageView?.isHidden = true
    }
    
    @objc func titleBtnClick(btn:UIButton) {
        
        let vc:SearchViewController = SearchViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func settingsBtnClick() {
        
        let vc:DeviceBaseSettingViewController = DeviceBaseSettingViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setTitleString(text:String = "Click to Connect",isSelected:Bool = false) {
        
        if isSelected {
            
            titleBtn.setTitle(text, for: .selected)
        }else {
            
            titleBtn.setTitle(text, for: .normal)
        }
        
        titleBtn.isSelected = isSelected
    }
    
    func changeConnectStatus() {
        
        DispatchQueue.main.async(execute: {[weak self] in
            
            guard let self else {return}
            
            switch self.connectStatus {
                
            case .startConnect:
                titleBtn.imageView?.isHidden = true
                loadingAnimation.isHidden = false
                loadingAnimation.play()
            case .failConnect:
                
                titleBtn.imageView?.isHidden = false
                loadingAnimation.isHidden = true
                loadingAnimation.pause()
                setTitleString()
                
            case .sucConnect:
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {[weak self] in
                    
                    guard let self else {return}
                    
                    self.titleBtn.imageView?.isHidden = false
                    self.loadingAnimation.isHidden = true
                    self.loadingAnimation.pause()
                    self.setTitleString(text: model.smodel?.reName ?? "", isSelected: true)
                })
                
            default:
                break
            }
            
        })

    }
    
    override func close(animation: Bool = true) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
}

class DeviceBaseViewModel {
    
    var smodel:Device?
}


class SelectableButton: UIButton {
    
    override var isSelected: Bool {
        didSet {
            isSelectedChanged()
        }
    }
    
    private func isSelectedChanged() {
        // 在这里处理 isSelected 变化时的逻辑
        
        sizeToFit()
        width += 10.RW()
        if width > 259.RW() {
            
            width = 259.RW()
        }
        
        changBtnWithStytl(btnStyle: .defalut, margin: 10.RW())
        
        centerX = superview?.centerX ?? 0
    }
}
