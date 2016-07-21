//
//  View.swift
//  TimeLog
//
//  Created by 黄穆斌 on 16/7/21.
//  Copyright © 2016年 MuBinHuang. All rights reserved.
//

import UIKit

class View: UIView {

    @IBInspectable var corner: CGFloat = 0
    @IBInspectable var opacity: Float = 0
    @IBInspectable var offsetW: CGFloat = 0
    @IBInspectable var offsetH: CGFloat = 0
    @IBInspectable var radius: CGFloat = 0
    
    // 0 mainColor; 1 accentColor;
    @IBInspectable var type: Int = 0 {
        didSet {
            switch type {
            case 0:
                backgroundColor = UIColor.clearColor()
                layer.backgroundColor = AppTint.mainColor().CGColor
            case 1:
                backgroundColor = UIColor.clearColor()
                layer.backgroundColor = AppTint.accentColor().CGColor
            default:
                let color = backgroundColor
                backgroundColor = UIColor.clearColor()
                layer.backgroundColor = color?.CGColor
            }
            self.setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        layer.cornerRadius = corner
        layer.shadowOpacity = opacity
        layer.shadowOffset = CGSize(width: offsetW, height: offsetH)
        layer.shadowRadius = radius
    }

}
