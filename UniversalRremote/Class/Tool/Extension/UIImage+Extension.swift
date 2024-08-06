//
//  UIImage+Extension.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/6.
//

import Foundation
import UIKit
import SVGKit
import SDWebImage

extension UIImage {
    
    class func svgWithName(name:String,size:CGSize = CGSize(width: 0, height: 0),color:String = "",opacity:CGFloat = 1) -> UIImage {
        
        if name.count == 0 {
            
            return UIImage()
        }
        
        if size.width == 0 {
            
            guard let svgImage = SVGKImage.init(named: name) else { return UIImage()}
            
            if color.count != 0 {
                
                svgImage.fillColor(color: UIColor.colorWithHex(hexStr: color), opacity: opacity)
                let colorImage:UIImage = svgImage.uiImage
                
                return colorImage
            }else {
                
                return svgImage.uiImage
            }
            
        }else {
            
            guard let svgImage = SVGKImage.init(named: name) else { return UIImage()}
            
            svgImage.size = size
           
            if color.count != 0 {
                
                svgImage.fillColor(color: UIColor.colorWithHex(hexStr: color), opacity: opacity)
                let colorImage:UIImage = svgImage.uiImage
                
                return colorImage
            }else {
                
                return svgImage.uiImage
            }
        }
        
    }
    
    class func initWithUrl(urlString:String,result: @escaping (_ image1:UIImage?,_ error:String)->Void) {
        
        guard let URl = NSURL.init(string: urlString) else { return }
        
        SDWebImageManager.shared.loadImage(with: URl as URL, options: SDWebImageOptions.refreshCached) { pro, totle, url in


        } completed: { imagec, totle, error, cacheType, isTrue, url in

            DispatchQueue.main.async {
                
                if (error == nil) {

                    guard let imaged = imagec else {result(nil,"no"); return}
                    
                    result(imaged,"")
                }else {
                    
                    result(nil,"no")
                }
            }
            
        }

    }

}

extension SVGKImage {
    
    func fillColor(color: UIColor,opacity: CGFloat) {
        
        if let layer = caLayerTree {
            fillColorForSubLayer(layer: layer, color: color, opacity: opacity)
        }
    }
    
    private func fillColorForSubLayer(layer: CALayer, color: UIColor,opacity: CGFloat) {
        
        if layer is CAShapeLayer {
            let shapeLayer = layer as! CAShapeLayer
            shapeLayer.fillColor = color.cgColor
            shapeLayer.opacity = Float(opacity)
        }

        if let sublayers = layer.sublayers {
            for subLayer in sublayers {
                fillColorForSubLayer(layer: subLayer, color: color,opacity: opacity)
            }
        }
    }

}


