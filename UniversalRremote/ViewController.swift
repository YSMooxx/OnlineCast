//
//  ViewController.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/6.
//

import UIKit

class ViewController: UIViewController {

    let urlArray:[String] = ["http://ldyt.online/FLogo.jpg","http://vjs.zencdn.net/v/oceans.mp4"]
    
    lazy var FireLabel:UILabel = {
        
        let sview:UILabel = UILabel()
        sview.textColor = UIColor.colorWithHex(hexStr: blackColor)
        sview.font = UIFont.systemFont(ofSize: 16.RW(), weight: .medium)
        sview.y = FireCastBtn.y + FireCastBtn.height + marginLR
        sview.x = marginLR
        return sview
    }()
    
    lazy var FireCastBtn:UIButton = {
        
        let sview:UIButton = UIButton()
        
        sview.backgroundColor = UIColor.colorWithHex(hexStr: "383838")
        sview.setTitleColor(UIColor.colorWithHex(hexStr: whiteColor), for: .normal)
        sview.setTitle("FireCast", for: .normal)
        sview.addTarget(self, action: #selector(FireCastBtnClick), for: UIControl.Event.touchUpInside)
        sview.sizeToFit()
        sview.width += 2 * marginLR
        sview.y = textView.y + textView.height + marginLR
        sview.x = marginLR
        sview.cornerCut(radius: 12.RW(), corner: .allCorners)
        return sview
    }()
    
    lazy var LGCastImageBtn:UIButton = {
        
        let sview:UIButton = UIButton()
        
        sview.backgroundColor = UIColor.colorWithHex(hexStr: "383838")
        sview.setTitleColor(UIColor.colorWithHex(hexStr: whiteColor), for: .normal)
        sview.setTitle("LGCastImage", for: .normal)
        sview.addTarget(self, action: #selector(LGCastImageBtnClick), for: UIControl.Event.touchUpInside)
        sview.sizeToFit()
        sview.width += 2 * marginLR
        sview.y = FireCastBtn.y + FireCastBtn.height + 100.RW()
        sview.x = marginLR
        sview.cornerCut(radius: 12.RW(), corner: .allCorners)
        return sview
    }()
    
    lazy var LGCastVideoBtn:UIButton = {
        
        let sview:UIButton = UIButton()
        
        sview.backgroundColor = UIColor.colorWithHex(hexStr: "383838")
        sview.setTitleColor(UIColor.colorWithHex(hexStr: whiteColor), for: .normal)
        sview.setTitle("LGCastVideo", for: .normal)
        sview.addTarget(self, action: #selector(LGCastVideoBtnClick), for: UIControl.Event.touchUpInside)
        sview.sizeToFit()
        sview.width += 2 * marginLR
        sview.y = FireCastBtn.y + FireCastBtn.height + 100.RW()
        sview.x = LGCastImageBtn.x + LGCastImageBtn.width + marginLR
        sview.cornerCut(radius: 12.RW(), corner: .allCorners)
        return sview
    }()
    
    lazy var LGLabel:UILabel = {
        
        let sview:UILabel = UILabel()
        sview.textColor = UIColor.colorWithHex(hexStr: blackColor)
        sview.font = UIFont.systemFont(ofSize: 16.RW(), weight: .medium)
        sview.y = LGCastImageBtn.y + LGCastImageBtn.height + marginLR
        sview.x = marginLR
        return sview
    }()
    
    lazy var RokuCastImageoBtn:UIButton = {
        
        let sview:UIButton = UIButton()
        
        sview.backgroundColor = UIColor.colorWithHex(hexStr: "383838")
        sview.setTitleColor(UIColor.colorWithHex(hexStr: whiteColor), for: .normal)
        sview.setTitle("RokuCastImage", for: .normal)
        sview.addTarget(self, action: #selector(RokuCastImageBtnClick), for: UIControl.Event.touchUpInside)
        sview.sizeToFit()
        sview.width += 2 * marginLR
        sview.y = LGCastImageBtn.y + LGCastImageBtn.height + 100.RW()
        sview.x = marginLR
        sview.cornerCut(radius: 12.RW(), corner: .allCorners)
        return sview
    }()
    
    lazy var RokuCastVideoBtn:UIButton = {
        
        let sview:UIButton = UIButton()
        
        sview.backgroundColor = UIColor.colorWithHex(hexStr: "383838")
        sview.setTitleColor(UIColor.colorWithHex(hexStr: whiteColor), for: .normal)
        sview.setTitle("RokuCastVideo", for: .normal)
        sview.addTarget(self, action: #selector(RokuCastVideoBtnClick), for: UIControl.Event.touchUpInside)
        sview.sizeToFit()
        sview.width += 2 * marginLR
        sview.y = RokuCastImageoBtn.y
        sview.x = RokuCastImageoBtn.x + RokuCastImageoBtn.width + marginLR
        sview.cornerCut(radius: 12.RW(), corner: .allCorners)
        return sview
    }()
    
    lazy var RokuLabel:UILabel = {
        
        let sview:UILabel = UILabel()
        sview.textColor = UIColor.colorWithHex(hexStr: blackColor)
        sview.font = UIFont.systemFont(ofSize: 16.RW(), weight: .medium)
        sview.y = RokuCastVideoBtn.y + RokuCastVideoBtn.height + marginLR
        sview.x = marginLR
        return sview
    }()
    
    
    lazy var textView:UITextField = {
        
        let searchHeight:CGFloat = 44.RW()
        
        let sview:UITextField = UITextField(frame: CGRect(x: marginLR, y:navHeight + marginLR, width:ScreenW - 2 * marginLR , height: searchHeight))
        sview.backgroundColor = UIColor.colorWithHex(hexStr: "#383838")
        sview.textColor = UIColor.colorWithHex(hexStr: whiteColor)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.colorWithHex(hexStr: "#666666"), // 设置你想要的颜色
            .font: UIFont.systemFont(ofSize: 14.RW()) // 你也可以设置字体等其他属性
        ]
        
        sview.attributedPlaceholder = NSAttributedString(string: "Please Write Url", attributes: attributes)
        sview.cornerCut(radius: 12.RW(), corner: .allCorners)
        
        return sview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(textView)
        self.view.addSubview(self.FireLabel)
        self.view.addSubview(self.FireCastBtn)
        
        self.view.addSubview(self.LGCastImageBtn)
        self.view.addSubview(self.LGCastVideoBtn)
        self.view.addSubview(self.LGLabel)
        
        self.view.addSubview(self.RokuCastImageoBtn)
        self.view.addSubview(self.RokuCastVideoBtn)
        self.view.addSubview(self.RokuLabel)
        
        setup()
    }
    
    func setup() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {[weak self] in
            
            guard let self else {return}
            
            self.FireLabel.text = AmazonFlingMananger.mananger.getName(Index: 0)
            self.FireLabel.sizeToFit()
            self.FireLabel.width = ScreenW - 2 * marginLR
        })
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            
            ConnectSDKManager.manager.stopDiscovery()
        })
    }
    
    @objc func FireCastBtnClick() {
        
        var text:String = textView.text ?? ""
        
        if text.count == 0 {
            
            text = getUrl()
        }
        
        AmazonFlingMananger.mananger.castIndex(Index: 0, url: text)
        
    }
    
    @objc func LGCastImageBtnClick() {
        
        let text = ConnectSDKManager.manager.LGCastImage(url: getImage())
        
        DispatchQueue.main.async {
            
            self.LGLabel.text = text
            self.LGLabel.sizeToFit()
            self.LGLabel.width = ScreenW - 2 * marginLR
        }
    }
    
    @objc func LGCastVideoBtnClick() {
        
        let text = ConnectSDKManager.manager.LGCastVideo(url: getVideo())
        
        DispatchQueue.main.async {
            
            self.LGLabel.text = text
            self.LGLabel.sizeToFit()
            self.LGLabel.width = ScreenW - 2 * marginLR
        }
    }
    
    @objc func RokuCastVideoBtnClick() {
        
        let text = ConnectSDKManager.manager.RokuCastVideo(url: getVideo())
        
        DispatchQueue.main.async {
            
            self.RokuLabel.text = text
            self.RokuLabel.sizeToFit()
            self.RokuLabel.width = ScreenW - 2 * marginLR
        }
    }
    
    
    @objc func RokuCastImageBtnClick() {
        
        let text = ConnectSDKManager.manager.RokuCastImage(url: getVideo())
        
        DispatchQueue.main.async {
            
            self.RokuLabel.text = text
            self.RokuLabel.sizeToFit()
            self.RokuLabel.width = ScreenW - 2 * marginLR
        }
    }
    
    func getUrl() -> String {
        
        let index:Int = Int(arc4random() % UInt32(urlArray.count))
        
        return urlArray[index]
    }
    
    func getImage() -> String {
        
        var text:String = textView.text ?? ""
        
        if text.count == 0 {
            
            text = urlArray[0]
        }
        
        return text
    }
    
    func getVideo() -> String {
        
        var text:String = textView.text ?? ""
        
        if text.count == 0 {
            
            text = urlArray[1]
        }
        
        return text
    }
    
}

