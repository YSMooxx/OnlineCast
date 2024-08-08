//
//  SettingViewController.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/7.
//

import UIKit
import MessageUI

class SettingViewController:LDBaseViewController {
    
    lazy var settingView:SettingView = {
        
        let sview:SettingView = SettingView(frame: CGRect(x: 0, y: 0, width: 240.RW(), height: ScreenH))
        
        sview.callBack = {[weak self] (text) in
            
            self?.didClickWithName(title: text)
        }
        
        return sview
    }()
    
    lazy var listArray:[settingListModel] = {
        
        let array = [["icon":"contactus","title":"Contact Us"],["icon":"pp","title":"Privacy Policy"],["icon":"tou","title":"Terms of Use"]]
        
        let arrayStr = JsonUtil.getJSONStringFromArray(array: array)
        
        let modelArray:[settingListModel] = JsonUtil.jsonArrayToModel(arrayStr, settingListModel.self) as? [settingListModel] ?? []
        
        return modelArray
    }()
    
    lazy var emailTipView:AllTipCheckView = {
        
        let tipModel:AllTipCheckViewModel = AllTipCheckViewModel()
        tipModel.tip = "Please install an email application before trying again."
        tipModel.noTipCheck = "Cancel"
        tipModel.yesTipCheck = "Go To Setting"
        let tipView:AllTipCheckView = AllTipCheckView(frame: view.bounds, model: tipModel)
        
        return tipView
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
            
            sendEmail()
        }else if cIndex == 1 {
            let vc:PrivacyPolicyWebViewController = PrivacyPolicyWebViewController()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
            
        }else if cIndex == 2 {
            
            let vc:TermOfUseWebViewController = TermOfUseWebViewController()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    func sendEmail() {
        // 检查设备是否支持邮件功能
        if MFMailComposeViewController.canSendMail() {
            
            let infoDic = Bundle.main.infoDictionary
            
            let systemVersion:String = UIDevice.current.systemVersion
            let appVersion:String = infoDic?["CFBundleShortVersionString"] as? String ?? ""
            
            let messageBody:String = "App version：V" + appVersion + "\n" + "Device version：iOS" + systemVersion + "\n" + "Your problem："
            
            DispatchQueue.main.async {[weak self] in
                
                let mailComposer = MFMailComposeViewController()
                mailComposer.mailComposeDelegate = self
                mailComposer.setToRecipients(["cs@ldyt.online.com"]) // 设置收件人
                mailComposer.setSubject("Universal Remote") // 设置邮件主题
                
                mailComposer.setMessageBody(messageBody, isHTML: false) // 设置邮件内容，isHTML 参数表示内容是否为 HTML
                
                // 拉起邮件应用
                self?.present(mailComposer, animated: true, completion: nil)
            }
            
        } else {
            
            emailTipView.showView()
        }
    }
    
}

extension SettingViewController:MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true, completion: nil)
        }
}
