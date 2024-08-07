//
//  Transiotion.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/6.
//

import UIKit

class BookFlipAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var isPush: Bool = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard let fromView = transitionContext.view(forKey: .from),
                  let toView = transitionContext.view(forKey: .to) else {
                return
            }
            
        
        }
}

class RightToLeftTransition: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5 // 设置过渡动画的持续时间
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from),
              let toViewController = transitionContext.viewController(forKey: .to)else {
            return
        }
        
        let containerView:UIView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toViewController)
        let screenWidth = UIScreen.main.bounds.width
        
        // 初始位置在屏幕右侧
        toViewController.view.frame = finalFrame.offsetBy(dx: screenWidth, dy: 0)
        containerView.addSubview(toViewController.view)

        // 执行动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromViewController.view.frame = finalFrame.offsetBy(dx: -screenWidth, dy: 0)
            toViewController.view.frame = finalFrame
        }, completion: { finished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

class  LeftToRightTransition: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5 // 设置过渡动画的持续时间
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from),
              let toViewController = transitionContext.viewController(forKey: .to)else {
            return
        }
        
        let containerView:UIView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toViewController)
        let screenWidth = UIScreen.main.bounds.width
        
        // 初始位置在屏幕右侧
        toViewController.view.frame = finalFrame.offsetBy(dx: screenWidth, dy: 0)
        containerView.addSubview(toViewController.view)

        // 执行动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromViewController.view.frame = finalFrame.offsetBy(dx: -screenWidth, dy: 0)
            toViewController.view.frame = finalFrame
        }, completion: { finished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

class BottomToTopTransition: NSObject, UIViewControllerAnimatedTransitioning {

    let duration = 0.4
        
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to),
              let fromViewController = transitionContext.viewController(forKey: .from) else {
            return
        }
        
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toViewController)
        
        toViewController.view.frame = finalFrame.offsetBy(dx: 0, dy: finalFrame.height)
        containerView.addSubview(toViewController.view)
        
        UIView.animate(withDuration: duration, animations: {
            toViewController.view.frame = finalFrame
        }, completion: { finished in
            fromViewController.view.removeFromSuperview()
            transitionContext.completeTransition(finished)
        })
    }
}

class RecectToFullTransition: NSObject, UIViewControllerAnimatedTransitioning {

    let startFrame:CGRect
    
    init(Recect:CGRect) {
        
        let rect:CGRect = CGRect(x: Recect.origin.x + Recect.size.height, y: Recect.origin.y, width: Recect.size.height, height: Recect.size.height)
        self.startFrame = rect
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4 // 设置过渡动画的持续时间
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else {
                    return
                }
                
        let containerView = transitionContext.containerView
        toView.frame = self.startFrame
        toView.alpha = 0.1
        containerView.addSubview(toView)
        
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, animations: {
            toView.frame = containerView.bounds
            toView.alpha = 1
        }) { _ in
            transitionContext.completeTransition(true)
        }
    }
}

class FullToRecectTransition: NSObject, UIViewControllerAnimatedTransitioning {

    let endFrame:CGRect
    
    init(Recect:CGRect) {
        
        let rect:CGRect = CGRect(x: Recect.origin.x + Recect.size.height, y: Recect.origin.y, width: Recect.size.height, height: Recect.size.height)
        self.endFrame = rect
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3 // 设置过渡动画的持续时间
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else {
                    return
        }
        
        guard let toView = transitionContext.view(forKey: .to) else {
                    return
                }
        
        let containerView = transitionContext.containerView
        containerView.insertSubview(toView, at: 0)
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, animations: {
            fromView.frame = self.endFrame
            fromView.alpha = 0.1
        }) { _ in
            transitionContext.completeTransition(true)
        }
    }
}

class OverRightToLeftTransition: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3 // 设置过渡动画的持续时间
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from),
              let toViewController = transitionContext.viewController(forKey: .to)else {
            return
        }
        
        let containerView:UIView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toViewController)
        let screenWidth = UIScreen.main.bounds.width
        
        toViewController.view.alpha = 0
        // 初始位置在屏幕右侧
        toViewController.view.frame = finalFrame.offsetBy(dx: -screenWidth, dy: 0)
        containerView.addSubview(toViewController.view)

        // 执行动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toViewController.view.frame = finalFrame
            toViewController.view.alpha = 1
        }, completion: { finished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

class OverLeftToRightTransition: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3 // 设置过渡动画的持续时间
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from),
              let toViewController = transitionContext.viewController(forKey: .to)else {
            return
        }
        
        let containerView:UIView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toViewController)
        let screenWidth = UIScreen.main.bounds.width
        fromViewController.view.alpha = 1
        // 初始位置在屏幕右侧
//        toViewController.view.frame = finalFrame.offsetBy(dx: screenWidth, dy: 0)
//        containerView.addSubview(toViewController.view)

        // 执行动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromViewController.view.frame = finalFrame.offsetBy(dx: -screenWidth, dy: 0)
            fromViewController.view.alpha = 0
//            toViewController.view.frame = finalFrame
        }, completion: { finished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

