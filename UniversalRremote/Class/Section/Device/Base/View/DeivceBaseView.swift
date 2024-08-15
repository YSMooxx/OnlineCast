//
//  DeivceBaseView.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/12.
//

import UIKit

class DeivceBaseView:UIView {
    
    var titleArray:[String] = []
    
    var deviceModel:Device
    
    var callBack:callBack = {text in}
    
    var connectStatus:connectStatusType? {
        
        didSet {
            
            changeConnectStatus()
        }
    }
    
    lazy var choiceView:DeviceBaseChoiceView = {
        
        let sview:DeviceBaseChoiceView = DeviceBaseChoiceView(frame: CGRect(x: marginLR, y: marginLR, width: width - 2 * marginLR, height: 52.RW()), titleArray: titleArray)
        
        sview.indexCallBack = {[weak self] index in
            
            guard let self else {return}
            
            let rect:CGRect = CGRect(x: scrollView.width * CGFloat(index), y: 0, width: scrollView.width, height: scrollView.height)
            
            self.scrollView.scrollRectToVisible(rect, animated: true)
        }
        
        return sview
    }()
    
    lazy var connectingView:DeviceConnectingView = {
        
        let sview:DeviceConnectingView = DeviceConnectingView(frame: CGRect(x: marginLR, y: marginLR, width: width - 2 * marginLR, height: 52.RW()))
        
        return sview
    }()
    
    lazy var connectFailView:DeviceConnectFailView = {
        
        let sview:DeviceConnectFailView = DeviceConnectFailView(frame: connectingView.frame)
        sview.isHidden = true
        sview.callBack = {[weak self] text in
            
            self?.callBack(text)
        }
        return sview
    }()
    
    lazy var scrollView:BtnCLickScrollView = {
        
        let cY:CGFloat = choiceView.y + choiceView.height
        let sview:BtnCLickScrollView = BtnCLickScrollView(frame: CGRect(x: 0, y: cY, width: width, height: height - cY))
        sview.contentSize = CGSize(width: CGFloat(titleArray.count) * width, height: sview.height)
        sview.showsHorizontalScrollIndicator = false
        sview.isPagingEnabled = true
        sview.delegate = self
        sview.delaysContentTouches = false
        return sview
    }()
    
    init(frame: CGRect,titleArray:[String],model:Device) {
        
        self.deviceModel = model
        self.titleArray = titleArray
        
        super.init(frame: frame)
        
        setupUI()
        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        backgroundColor = .clear
    }
    
    func addViews() {
        
        addSubview(choiceView)
        addSubview(connectingView)
        addSubview(connectFailView)
        addSubview(scrollView)
    }
    
    func scrollViewDidEnd(contentOffsetX: CGFloat) {
        
        let index:Int = Int(contentOffsetX / scrollView.width)
        choiceView.currentIndex = index
    }
    
    func changeConnectStatus() {
        
        DispatchQueue.main.async {[weak self] in
            
            guard let self else {return}
            
            switch connectStatus {
                
            case .startConnect:
                choiceView.isHidden = true
                connectingView.isHidden = false
                connectFailView.isHidden = true
            case .failConnect:
                
                choiceView.isHidden = true
                connectingView.isHidden = true
                connectFailView.isHidden = false
                
            case .sucConnect:
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {[weak self] in
                    
                    guard let self else {return}
                    self.choiceView.isHidden = false
                    self.connectingView.isHidden = true
                    self.connectFailView.isHidden = true
                })
                
            default:
                break
            }
        }
        
    }
}

extension DeivceBaseView:UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let scroend:Bool = (scrollView.isTracking) || (scrollView.isDragging) || (scrollView.isDecelerating)
        
        if scroend == false {
            
            let x:CGFloat = scrollView.contentOffset.x
            scrollViewDidEnd(contentOffsetX: x)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let scroend:Bool = (scrollView.isTracking) || (scrollView.isDragging) || (scrollView.isDecelerating)
        
        if scroend == false {
            
            let x:CGFloat = scrollView.contentOffset.x
            scrollViewDidEnd(contentOffsetX: x)
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        let scroend:Bool = (scrollView.isTracking) || (scrollView.isDragging) || (scrollView.isDecelerating)
        
        if scroend == false {
            
            let x:CGFloat = scrollView.contentOffset.x
            scrollViewDidEnd(contentOffsetX: x)
        }
    }
}

class BtnCLickScrollView: UIScrollView {
    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view is UIButton {
            return true
        }
        return super.touchesShouldCancel(in: view)
    }
}
