//
//  EnlargeBtn.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/8.
//

import UIKit

class EnlargeBtn:UIButton {
    
}

extension EnlargeBtn {
    
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {

        var boundCGRect = self.bounds

        boundCGRect = CGRectInset(boundCGRect, -marginLR, -marginLR)

        return CGRectContainsPoint(boundCGRect, point)
    }
}
