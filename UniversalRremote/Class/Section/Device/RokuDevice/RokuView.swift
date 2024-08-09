//
//  RokuView.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/9.
//

import UIKit

class RokuView:UIView {
    
    lazy var titleArray:[String] = ["Remote","Channel","Mirror"]
    
    lazy var choiceView:DeviceBaseChoiceView = {
        
        let sview:DeviceBaseChoiceView = DeviceBaseChoiceView(frame: CGRect(x: marginLR, y: marginLR, width: width - 2 * marginLR, height: 52.RW()), titleArray: titleArray)
        
        sview.indexCallBack = {[weak self] index in
            
            guard let self else {return}
            if  index == 0 {
                self.scrollView.scrollRectToVisible(self.remoteView.frame, animated: true)
            }else if index == 1 {
                
                self.scrollView.scrollRectToVisible(self.channelView.frame, animated: true)
            }else if index == 2 {
                
                self.scrollView.scrollRectToVisible(self.mirrorView.frame, animated: true)
            }
            
        }
        
        return sview
    }()
    
    lazy var scrollView:UIScrollView = {
        
        let cY:CGFloat = choiceView.y + choiceView.height
        let sview:UIScrollView = UIScrollView(frame: CGRect(x: 0, y: cY, width: width, height: height - cY))
        sview.contentSize = CGSize(width: CGFloat(titleArray.count) * width, height: sview.height)
        sview.showsHorizontalScrollIndicator = false
        sview.isPagingEnabled = true
        sview.delegate = self
        return sview
    }()
    
    lazy var remoteView:RokuRemoteView = {
        
        let sview:RokuRemoteView = RokuRemoteView(frame: scrollView.bounds)
        
        return sview
    }()
    
    lazy var channelView:RokuChannelView = {
        
        let sview:RokuChannelView = RokuChannelView(frame: scrollView.bounds)
        sview.x = 1 * scrollView.width
        return sview
    }()
    
    lazy var mirrorView:RokuMirrorView = {
        
        let sview:RokuMirrorView = RokuMirrorView(frame: scrollView.bounds)
        sview.x = 2 * scrollView.width
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
        
        backgroundColor = .clear
    }
    
    func addViews() {
        
        addSubview(choiceView)
        addSubview(scrollView)
        scrollView.addSubview(remoteView)
        scrollView.addSubview(channelView)
        scrollView.addSubview(mirrorView)
    }
    
    func scrollViewDidEnd(contentOffsetX: CGFloat) {
        
        let index:Int = Int(contentOffsetX / scrollView.width)
        choiceView.currentIndex = index
    }
}

extension RokuView:UIScrollViewDelegate {
    
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
