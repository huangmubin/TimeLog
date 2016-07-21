//
//  AppTint.swift
//  TimeLog
//
//  Created by 黄穆斌 on 16/7/21.
//  Copyright © 2016年 MuBinHuang. All rights reserved.
//

import UIKit

class AppTint {
    
    // MARK: - Colors
    
    class func navigationColor() -> UIColor {
        return DrawerColor(0, 51, 102, 1)
    }
    
    class func backColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    class func mainColor() -> UIColor {
        return DrawerColor(0, 153, 255, 1)
    }
    
    class func subColor() -> (A: UIColor, B: UIColor, C: UIColor) {
        return (
            UIColor.darkGrayColor(),
            UIColor.grayColor(),
            UIColor.lightGrayColor()
        )
    }
    
    class func accentColor() -> UIColor {
        return DrawerColor(255, 146, 146, 1)
    }
    
    // MARK: - Fonts
    
    class func fontColor() -> (main: UIColor, sub: UIColor, accent: UIColor) {
        return (
            UIColor.whiteColor(),
            UIColor.whiteColor(),
            UIColor.whiteColor()
        )
    }
    
    class func mainFont() -> UIFont {
        return UIFont.systemFontOfSize(UIFont.systemFontSize())
    }
    
    class func titleFont() -> UIFont {
        return UIFont.systemFontOfSize(UIFont.systemFontSize() + 5)
    }
    
    class func noteFont() -> UIFont {
        return UIFont.systemFontOfSize(UIFont.systemFontSize() - 5)
    }

}
