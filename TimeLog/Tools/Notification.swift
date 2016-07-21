//
//  Notification.swift
//  TimeLog
//
//  Created by 黄穆斌 on 16/7/21.
//  Copyright © 2016年 MuBinHuang. All rights reserved.
//

import UIKit

class Notification {
    
    // MARK: - Remove
    
    class func remove(observer: AnyObject) {
        NSNotificationCenter.defaultCenter().removeObserver(observer)
    }
    
    
    // MARK: - Data
    
    class func data(notify: NSNotification) -> AnyObject? {
        if let info = notify.userInfo {
            return info["Data"]
        }
        return nil
    }
    class func data(notify: NSNotification, key: NSObject) -> AnyObject? {
        if let info = notify.userInfo {
            return info[key]
        }
        return nil
    }
    
    // MARK: - Keyboard Notification
    
    /**
     UIKeyboardDidChangeFrameNotification
     UIKeyboardDidHideNotification
     UIKeyboardDidShowNotification
     
     if let rect = info.objectForKey(UIKeyboardFrameEndUserInfoKey)?.CGRectValue {
     
     }
     */

    class func keyboardWillChanged(observer: AnyObject, selector: Selector) {
        NSNotificationCenter.defaultCenter().addObserver(observer, selector: selector, name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    class func keyboardWillHide(observer: AnyObject, selector: Selector) {
        NSNotificationCenter.defaultCenter().addObserver(observer, selector: selector, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
}
