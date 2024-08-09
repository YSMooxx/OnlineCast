//
//  AllTipLoadingView.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/9.
//

import UIKit
import Lottie

class AllTipLoadingView:UIView {
    
    static let loadingModel:AllTipLoadingViewModel = {
        
        let smodel:AllTipLoadingViewModel = AllTipLoadingViewModel()
        
        smodel.maxWH = 104.RW()
        smodel.title = "Connecting"
        
        return smodel
    }()
    
    static let loadingShared:AllTipLoadingView = AllTipLoadingView(model: AllTipLoadingView.loadingModel)
    
    lazy var backView:UIView = {
        
        let backView:UIView = UIView()
        backView.height = model.maxWH
        backView.width  = model.maxWH
        backView.centerX = width / 2
        backView.centerY = (height - navHeight) / 2
        backView.backgroundColor = UIColor.colorWithHex(hexStr: "#383838")
        backView.setShadow(cornerRadius: 12.RW(),sColor: UIColor.colorWithHex(hexStr: blackColor, alpha: 0.16))
        
        return backView
    }()
    
    lazy var titleLabel:UILabel = {
        
        let sview:UILabel = UILabel()
        sview.text = model.title
        sview.width = model.maxWH - 10.RW() * 2
        sview.numberOfLines = 0
        sview.font = UIFont.systemFont(ofSize: 14.RW(), weight: .regular)
        sview.textColor = UIColor.colorWithHex(hexStr: whiteColor)
        sview.textAlignment = .center
        sview.sizeToFit()
        sview.width = model.maxWH - 10.RW() * 2
        sview.y = backView.height - 15.RW() - sview.height
        sview.centerX = backView.width / 2
        
        return sview
    }()
    
    lazy var loadingAnimation:AnimationView = {
        
        let animationView = Lottie.AnimationView(name: "All_loading")
            
        animationView.width = 50.RW()
        animationView.height = 50.RW()
        animationView.centerX = backView.width / 2
        animationView.y = 14.RW()
        animationView.loopMode = .loop
        animationView.play()
        return animationView
    }()
    
    init(model: AllTipLoadingViewModel) {
        
        self.model = model
        
        super.init(frame: CGRect(x: 0, y: 0, width: ScreenW, height: ScreenH))
        
        setupUI()
        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model:AllTipLoadingViewModel {
        
        didSet {
            
            setupUI()
        }
    }
    
    func setupUI() {
        
        backgroundColor = .clear
        
        titleLabel.text = model.title
        titleLabel.sizeToFit()
        titleLabel.width = model.maxWH - 14.RW() * 2
        titleLabel.y = backView.height - 13.RW() - titleLabel.height
        titleLabel.centerX = backView.width / 2
    }
    
    func addViews() {
        
        addSubview(backView)
        backView.addSubview(loadingAnimation)
        backView.addSubview(titleLabel)
    }
    
    func showView() {
       
        self.loadingAnimation.play()
        
       DispatchQueue.main.async {[weak self] in
           
           guard let self else {return}
           cWindow?.addSubview(self)
       }
        
//        UIView.animate(withDuration: 0.25) {[weak self] in
//
//            guard let self else {return}
//            
//            self.backView.transform = CGAffineTransformMakeScale(1, 1);
//
//            self.backView.alpha = 1;
//
//        } completion: { Bool in
//
//            
//        }
    }
    
    func dissMiss() {
        
//        self.backView.transform = CGAffineTransformMakeScale(0.9, 0.9)
        self.loadingAnimation.pause()
        self.removeFromSuperview()
    }
}

class AllTipLoadingViewModel {
    
    var title:String = ""
    var maxWH:CGFloat = 100.RW()
}
