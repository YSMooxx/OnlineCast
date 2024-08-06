//
//  LDBaseNavViewController.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/6.
//

import UIKit

class LDBaseNavViewController:UINavigationController,UIGestureRecognizerDelegate {
    
    var barStatyl:UIStatusBarStyle = .darkContent {
        
        didSet {
            
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    var barHidden:Bool = false {
        
        didSet {
            
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    var callBack:callBack = {text in}
    
    enum AnimationType {
        case def
        case recectToFull
        case dissRight
    }
    
    enum PushAnimationType {
        case normal
        case diy
        case bottomToTop
        case book
    }
    
    var isAnimation:AnimationType
    
    var cIsPopGestureRecognizer:Bool
    
    var cPushAnimation:PushAnimationType
    
    init(isAnimation:AnimationType = .def,rootViewController:UIViewController,isPopGestureRecognizer:Bool = true,pushAnimation:PushAnimationType = .normal) {
        
        self.isAnimation = isAnimation
        self.cIsPopGestureRecognizer = isPopGestureRecognizer
        self.cPushAnimation = pushAnimation
        super.init(rootViewController: rootViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI()  {
        
        navigationBar.isHidden = true
        
        self.delegate = self
        
        interactivePopGestureRecognizer?.delegate = self
        
        if isAnimation != .def {
            
            self.transitioningDelegate = self
        }else {
            
            self.transitioningDelegate = nil
        }
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if !cIsPopGestureRecognizer {
            
            return false
        }
        
        if children.count == 1 {
            
            return false
        }else {
            
            return true
        }
        
    }
    
    func UMPCheck() {
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return barStatyl
    }
    
    override var prefersStatusBarHidden:Bool {
        
        return barHidden
    }
    
    func pushViewController(_ viewController: UIViewController, animated: Bool,pushAnimationType:PushAnimationType) {
        
        cPushAnimation = pushAnimationType
        
        super.pushViewController(viewController, animated: animated)
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
}

extension LDBaseNavViewController:UIViewControllerTransitioningDelegate {
    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if isAnimation == .recectToFull {
            
            return RecectToFullTransition(Recect: CGRect(x: 0, y: ScreenH - tabHeight, width: ScreenW, height: tabHeight))
        }else {
            
            return nil
        }
        
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        
        if isAnimation == .recectToFull {
            
            return FullToRecectTransition(Recect: CGRect(x: 0, y: ScreenH - tabHeight, width: ScreenW, height: tabHeight))
        }else if isAnimation == .dissRight{
            
            return RightToLeftTransition()
        }else {
            
            return nil
        }
        
    }
    
}

extension LDBaseNavViewController:UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                                  animationControllerFor operation: UINavigationController.Operation,
                                  from fromVC: UIViewController,
                                  to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        
            if operation == .push {
                
                if cPushAnimation == .diy {
                    
                    cPushAnimation = .normal
                    return FullToRecectTransition(Recect: CGRect(x: 0, y: ScreenH - tabHeight, width: ScreenW, height: tabHeight))
                }else if cPushAnimation == .bottomToTop{
                    
                    cPushAnimation = .normal
                    return BottomToTopTransition()
                }else if cPushAnimation == .book {
                    
                    cPushAnimation = .normal
                    return  BookFlipAnimator()
                }else {
                    
                    cPushAnimation = .normal
                    return nil
                }
                
            } else {
                return nil
            }
        
        }
    
}

