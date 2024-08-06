//
//  Common.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/6.
//

import UIKit

let ScreenW:CGFloat = UIScreen.main.bounds.size.width

let ScreenH:CGFloat = UIScreen.main.bounds.size.height

let RW:CGFloat = RScreenW()

let RH:CGFloat = RScreenH()

let tabHeight:CGFloat = 49

var safeHeight:CGFloat = 0

var statusBarHeight:CGFloat = 0

let navHeight:CGFloat = 44

let marginLR:CGFloat = 16.RW()

func RScreenW() -> CGFloat {
    
    return ScreenW / 375
}

func RScreenH() -> CGFloat {
    
    let radio:CGFloat = ScreenH / 812
    
    return radio
}


/*
 *Color
 */

//defaultBack
let dBackColor:String = "#241E1E"
//black
let blackColor:String = "#000000"
//white
let whiteColor:String = "#FFFFFF"


public func Print(_ items: Any...) {
    
    #if DEBUG
    print(items)
    #else
//    print(items)
    #endif
}
