//
//  UIView+Extension.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/6.
//

import UIKit

extension UIView {
    
    func responderViewController() -> UIViewController? {

        for view in sequence(first: self.superview, next: { $0?.superview }) {

            if let responder = view?.next {

                if responder.isKind(of: UIViewController.self){

                    return responder as? UIViewController
                }

            }

        }

        return nil
    }
    
    func cornerCut(radius:CGFloat,corner:UIRectCorner){
        
        let maskPath = UIBezierPath.init(roundedRect: bounds, byRoundingCorners: corner, cornerRadii: CGSize.init(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
    
    func setShadow(
        cornerRadius:CGFloat = 4.RW(),
        sColor:UIColor = UIColor.colorWithHex(hexStr: blackColor, alpha: 0.08),
        offset:CGSize = CGSize(width: 0, height: 0),
        opacity:Float = 1,
        radius:CGFloat = 8.RW()
    ) {
        //设置阴影颜色
        self.layer.shadowColor = sColor.cgColor
        //设置透明度
        self.layer.shadowOpacity = opacity
        //设置阴影半径
        self.layer.shadowRadius = radius
        //设置阴影偏移量
        self.layer.shadowOffset = offset
        //
        self.layer.cornerRadius = cornerRadius
    }
    
    var x :CGFloat {
        
        get {
            
            return frame.origin.x
        }
        
        set {
            
            var frame1:CGRect = frame
            frame1.origin.x = newValue
            frame = frame1
        }
    }
    
    var y :CGFloat {
        
        get {
            
            return frame.origin.y
        }
        
        set {
            
            var frame1:CGRect = frame
            frame1.origin.y = newValue
            frame = frame1
            
        }
    }
    var width :CGFloat {
        
        get {
            
            return frame.size.width
        }
        
        set {
            
            var frame1:CGRect = frame
            frame1.size.width = newValue
            frame = frame1
            
        }
    }
    
    var height :CGFloat {
        
        get {
            
            return frame.size.height
        }
        
        set {
            
            var frame1:CGRect = frame
            frame1.size.height = newValue
            frame = frame1
            
        }
    }
    
    var size :CGSize {
        
        get {
            
            return frame.size
        }
        
        set {
            
            var frame1:CGRect = frame
            frame1.size = newValue
            frame = frame1
            
        }
    }
    
    var centerX :CGFloat {
        
        get {
            
            return center.x
        }
        
        set {
            
            var center1:CGPoint = center
            center1.x = newValue
            center = center1
        }
    }
    
    var centerY :CGFloat {
        
        get {
            
            return center.y
        }
        
        set {
            
            var center1:CGPoint = center
            center1.y = newValue
            center = center1
        }
    }
}
