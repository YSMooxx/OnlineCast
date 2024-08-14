//
//  DeivceOtherRemoteView.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/14.
//

import UIKit

class DeivceOtherRemoteView:UIView {
    
    lazy var touImage:[String] = ["deviceVC_btn","deviceVC_touch"]
    
    var listModelArray:[DeviceListbtnModel] = []
    
    var dirListModelArray:[DeviceListbtnModel] = []
    
    var callBack:callBack = {text in}
    
    lazy var touchBtnView:DeviceTouchBtnView = {
        
        let cW:CGFloat = 92.RW()
        let sview:DeviceTouchBtnView = DeviceTouchBtnView(frame: CGRect(x: width - cW - marginLR, y: marginLR, width: cW, height: 50.RW()), titleArray: touImage)
        sview.indexCallBack = {[weak self] index in
            guard let self else {return}
            if index == 0 {
                
                self.dirView.isHidden = false
                self.touchView.isHidden = true
                self.callBack("dir")
            }else if index == 1 {
                
                self.dirView.isHidden = true
                self.touchView.isHidden = false
                self.callBack("touch")
            }
        }
        
        return sview
    }()
    
    lazy var scrollView:BtnCLickScrollView = {
        
        let cY:CGFloat = 82.RW() + centerHeigit + 24.RW()
        let sview:BtnCLickScrollView = BtnCLickScrollView(frame: CGRect(x: 0, y: cY, width: width, height: 212.RW()))
        sview.contentSize = CGSize(width: CGFloat(3 * width), height: sview.height)
        sview.showsHorizontalScrollIndicator = false
        sview.isPagingEnabled = true
        sview.isUserInteractionEnabled = true
        sview.delaysContentTouches = false
        sview.delegate = self
        return sview
    }()
    
    lazy var pageControlView:DeivceOtherPageControlView = {
        
        let sview:DeivceOtherPageControlView = DeivceOtherPageControlView(frame: CGRect(x: 0, y: scrollView.y + scrollView.height + 20.RW(), width: 20.RW(), height: 6.RW()), count: 3)
        
        sview.centerX = width / 2
        
        return sview
    }()
    
    lazy var volumeBackImage:UIButton = {
        
        let xW:CGFloat = 78.RW()
        
        let sview:UIButton = UIButton(frame: CGRect(x: scrollView.width - xW - marginLR, y: 0, width: xW, height: 136.RW()))
        sview.setBackgroundImage(UIImage(named: "deviceVC_remote_other_norl"), for: .normal)
        sview.setBackgroundImage(UIImage(named: "deviceVC_remote_other_hight"), for: .highlighted)
        sview.addTarget(self, action: #selector(buttonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside])
        
        return sview
    }()
    
    var clickType:String = ""
    
    lazy var upVolumBtn:volumBtn = {
        
        let  sview:volumBtn = volumBtn(frame: CGRect(x: 0, y: 0, width: iconWH, height: iconWH))
        sview.centerX = volumeBackImage.width / 2
        sview.y = 17.RW()
        sview.setBackgroundImage(UIImage(named: "deviceVC_ovolumup_norl_icon"), for: .normal)
        sview.callBack = {[weak self] (text) in
            
            self?.clickType = "up"
        }
        
        return sview
    }()
    
    lazy var downVolumBtn:volumBtn = {
        
        let  sview:volumBtn = volumBtn(frame: CGRect(x: 0, y: 0, width: iconWH, height: iconWH))
        sview.centerX = volumeBackImage.width / 2
        sview.y = volumeBackImage.height - 17.RW() - sview.height
        sview.setBackgroundImage(UIImage(named: "deviceVC_ovolumdown_norl_icon"), for: .normal)
        sview.callBack = {[weak self] (text) in
            
            self?.clickType = "down"
        }
        
        return sview
    }()
    
    lazy var volunTipImage:UIImageView = {
        
        let sview:UIImageView = UIImageView(image: UIImage(named: "deviceVC_ovolum_tip"))
        sview.width = iconWH
        sview.height = iconWH
        sview.centerX = volumeBackImage.width / 2
        sview.centerY = volumeBackImage.height / 2
        
        return sview
    }()
    
    lazy var channelBackImage:UIButton = {
        
        let xW:CGFloat = 78.RW()
        
        let sview:UIButton = UIButton(frame: CGRect(x: marginLR, y: 0, width: xW, height: 136.RW()))
        sview.setBackgroundImage(UIImage(named: "deviceVC_remote_other_norl"), for: .normal)
        sview.setBackgroundImage(UIImage(named: "deviceVC_remote_other_hight"), for: .highlighted)
        sview.addTarget(self, action: #selector(channelButtonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside])
        
        return sview
    }()
    
    var channelClickType:String = ""
    
    lazy var upChannelBtn:volumBtn = {
        
        let  sview:volumBtn = volumBtn(frame: CGRect(x: 0, y: 0, width: iconWH, height: iconWH))
        sview.centerX = volumeBackImage.width / 2
        sview.y = 17.RW()
        sview.setBackgroundImage(UIImage(named: "deviceVC_ovolumup_norl_icon"), for: .normal)
        sview.callBack = {[weak self] (text) in
            
            self?.channelClickType = "up"
        }
        
        return sview
    }()
    
    lazy var downChannelBtn:volumBtn = {
        
        let  sview:volumBtn = volumBtn(frame: CGRect(x: 0, y: 0, width: iconWH, height: iconWH))
        sview.centerX = volumeBackImage.width / 2
        sview.y = volumeBackImage.height - 17.RW() - sview.height
        sview.setBackgroundImage(UIImage(named: "deviceVC_ovolumdown_norl_icon"), for: .normal)
        sview.callBack = {[weak self] (text) in
            
            self?.channelClickType = "down"
        }
        
        return sview
    }()
    
    lazy var channelTipImage:UIImageView = {
        
        let sview:UIImageView = UIImageView(image: UIImage(named: "deviceVC_ochannel_tip"))
        sview.width = iconWH
        sview.height = iconWH
        sview.centerX = volumeBackImage.width / 2
        sview.centerY = volumeBackImage.height / 2
        
        return sview
    }()
    
    lazy var dirView:UIView = {
        
        let sview:UIView = UIView(frame: CGRect(x: 0, y: 0, width: centerHeigit, height: centerHeigit))
        
        sview.centerX = width / 2
        sview.y = 82.RW()
        
        return sview
    }()
    
    lazy var touchView:UIImageView = {
        
        let sview:UIImageView = UIImageView(image: UIImage(named: "deviceVC_touch_back"))
        sview.width = width - 2 * marginLR
        sview.height = centerHeigit
        sview.centerX = width / 2
        sview.y = 82.RW()
        sview.isUserInteractionEnabled = true
        sview.isHidden = true
        sview.addGestureRecognizer(panGesture)
        sview.addGestureRecognizer(tapGesture)
        panGesture.require(toFail: tapGesture)
        return sview
    }()
    
    lazy var panGesture:UIPanGestureRecognizer = {
        
        let panGesture:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        
        return panGesture
    }()
    
    
    lazy var tapGesture:UITapGestureRecognizer = {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        tapGesture.numberOfTapsRequired = 1
        
        return tapGesture
    }()
    
    let allContentHeight:CGFloat = 500
    let allHMargin:CGFloat = 117
    let otherHeight:CGFloat = 252
    lazy var centerHeigit:CGFloat = {
        
        if height < (allContentHeight + allHMargin).RW() {
            
           return  height  - allHMargin.RW() - otherHeight.RW()
        }else {
            
            return 248.RW()
        }
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
        
        backgroundColor = .clear
    }
    
    func addViews() {
        
        addSubview(touchBtnView)
        addSubview(dirView)
        addSubview(touchView)
        addSubview(scrollView)
        addSubview(pageControlView)
        
        scrollView.addSubview(volumeBackImage)
        volumeBackImage.addSubview(upVolumBtn)
        volumeBackImage.addSubview(volunTipImage)
        volumeBackImage.addSubview(downVolumBtn)
        
        scrollView.addSubview(channelBackImage)
        channelBackImage.addSubview(upChannelBtn)
        channelBackImage.addSubview(downChannelBtn)
        channelBackImage.addSubview(channelTipImage)
        
//        addListBtn()
//        addDirListBtn()
    }
    
    func addListBtn() {
        
    
    }
    
    func addDirListBtn() {
        
        
    }
    
    @objc func buttonTouchUp(_ sender: UIButton) {
            
        upVolumBtn.isHighlighted = false
        downVolumBtn.isHighlighted = false
        
        if clickType == "up" {
            
            callBack("volumup")
        }else if clickType == "down" {
            
            callBack("volumdown")
        }
        
        clickType = ""
    }
    
    @objc func channelButtonTouchUp(_ sender: UIButton) {
            
        upChannelBtn.isHighlighted = false
        downChannelBtn.isHighlighted = false
        
        if channelClickType == "up" {
            
            callBack("channelup")
        }else if channelClickType == "down" {
            
            callBack("channeldown")
        }
        
        channelClickType = ""
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        
        if gesture.state == .ended {
            let translation = gesture.translation(in: touchView)
            
                    // 水平滑动距离大于垂直滑动距离，认定为水平滑动
            if abs(translation.x) > abs(translation.y) {
                if translation.x > 0 {
                    
                    if dirListModelArray.count == 5 {
                        
                        self.callBack(dirListModelArray[3].key)
                    }
                } else {
                    
                    if dirListModelArray.count == 5 {
                        
                        self.callBack(dirListModelArray[4].key)
                    }
                }
            } else {
                // 垂直滑动距离大于水平滑动距离，认定为垂直滑动
                if translation.y > 0 {
                    
                    if dirListModelArray.count == 5 {
                        
                        self.callBack(dirListModelArray[2].key)
                    }
                } else {
                    
                    if dirListModelArray.count == 5 {
                        
                        self.callBack(dirListModelArray[1].key)
                    }
                }
            }
        }
        
   }
    
    func scrollViewDidEnd(contentOffsetX: CGFloat) {
        
        let index:Int = Int(contentOffsetX / scrollView.width)
        pageControlView.currentCount = index
    }
    
    
    @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        if gesture.state == .recognized {
            
            if dirListModelArray.count == 5 {
                
                self.callBack(dirListModelArray[0].key)
            }
        }
    }
}

extension DeivceOtherRemoteView:UIScrollViewDelegate {
    
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

class DeivceOtherPageControlView:UIView {
    
    var count:Int = 0
    
    var currentCount:Int? {
        
        didSet {
            
            changeCurrentCount(oldIndex: oldValue ?? 9999)
        }
    }
    
    let norlColor:String = "#616161"
    let sellColor:String = "#FFFFFF"
    
    lazy var pointViewArray:[UIView] = []
    
    init(frame: CGRect,count:Int) {
        
        self.count = count
        
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
        
        let marX:CGFloat = 12.RW()
        let cWH:CGFloat = height
        
        for i in 0..<count {
            
            let sview:UIView = UIView(frame: CGRect(x: CGFloat(i) * (marX + cWH), y: 0, width: cWH, height: cWH))
            sview.backgroundColor = UIColor.colorWithHex(hexStr: norlColor)
            sview.cornerCut(radius: cWH / 2, corner: .allCorners)
            
            addSubview(sview)
            pointViewArray.append(sview)
            
            if i == count - 1 {
                
                width = sview.x + sview.width
            }
        }
        
        currentCount = 0
    }
    
    func changeCurrentCount(oldIndex:Int) {
        
        if oldIndex != currentCount {
            
            UIView.animate(withDuration: 0.3) {[weak self] in
                guard let self else {return}
                
                self.getViewWithIndex(index: oldIndex).backgroundColor = UIColor.colorWithHex(hexStr: self.norlColor)
                self.getViewWithIndex(index: currentCount ?? 0).backgroundColor = UIColor.colorWithHex(hexStr: self.sellColor)
            }
        }
    }
    
    func getViewWithIndex(index:Int) -> UIView {
        
        if index < pointViewArray.count {
            
            return pointViewArray[index]
        }else {
            
            return UIView()
        }
    }
}

