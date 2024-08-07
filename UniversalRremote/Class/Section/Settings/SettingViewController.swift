//
//  SettingViewController.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/7.
//

import UIKit

class SettingViewController:LDBaseViewController {
    
    lazy var settingView:SettingView = {
        
        let sview:SettingView = SettingView(frame: CGRect(x: 0, y: 0, width: 240.RW(), height: ScreenH))
        
        sview.callBack = {[weak self] (text) in
            
            self?.didClickWithName(title: text)
        }
        
        return sview
    }()
    
    lazy var listArray:[settingListModel] = {
        
        let array = [["icon":"contactus","title":"Contact Us"],["icon":"rateus","title":"Rate Us"],["icon":"pp","title":"Privacy Policy"],["icon":"tou","title":"Terms of Use"]]
        
        let arrayStr = JsonUtil.getJSONStringFromArray(array: array)
        
        let modelArray:[settingListModel] = JsonUtil.jsonArrayToModel(arrayStr, settingListModel.self) as? [settingListModel] ?? []
        
        return modelArray
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.colorWithHex(hexStr: blackColor, alpha: 0.6)
        
        settingView.listModelArray = listArray
    }
    
    override func addViews() {
        
        view.addSubview(settingView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        var result:Bool? = true
        
        for touch:AnyObject in touches{
            
            let touch:UITouch = touch as! UITouch
            let result1:Bool = touch.view?.isDescendant(of:self.settingView) ?? true
            result = result1
        }
        
        if result != true {
            
            self.navigationController?.dismiss(animated: true)
        }
    }
    
    func didClickWithName(title:String) {
        
        var index:Int?
        
        for (i,smodel) in listArray.enumerated() {
            
            if title == smodel.title {
                
                index = i
            }
        }
        
        guard let cIndex = index else {return}
        
        if cIndex == 0 {
            
            
        }else if cIndex == 1 {
            
            
        }else if cIndex == 2 {
            let vc:PrivacyPolicyWebViewController = PrivacyPolicyWebViewController()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
            
        }else if cIndex == 3 {
            
            let vc:TermOfUseWebViewController = TermOfUseWebViewController()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}
