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
    @IBInspectable var masks: Bool = false
    
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
        layer.masksToBounds = masks
    }

}

class CornerView: UIView {
    
    @IBInspectable var cornerA: CGFloat = 0
    @IBInspectable var cornerB: CGFloat = 0
    @IBInspectable var cornerC: CGFloat = 0
    @IBInspectable var cornerD: CGFloat = 0
    @IBInspectable var type: Int = 0 {
        didSet {
            switch type {
            case 0:
                backgroundColor = UIColor.clearColor()
                background = AppTint.mainColor()
            case 1:
                backgroundColor = UIColor.clearColor()
                background = AppTint.accentColor()
            default:
                background = backgroundColor ?? UIColor.clearColor()
//                backgroundColor = UIColor.clearColor()
//                layer.backgroundColor = color?.CGColor
            }
            self.setNeedsDisplay()
        }
    }
    
    var background: UIColor = AppTint.backColor()
    override func drawRect(rect: CGRect) {
        let path = Drawer.roundedPath(rect.size, a: cornerA, b: cornerB, c: cornerC, d: cornerD)
        background.setFill()
        path.fill()
    }
    
}