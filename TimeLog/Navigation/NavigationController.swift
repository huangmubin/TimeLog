//
//  NavigationController.swift
//  TimeLog
//
//  Created by 黄穆斌 on 16/7/21.
//  Copyright © 2016年 MuBinHuang. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barTintColor = AppTint.navigationColor()
        self.navigationBar.tintColor = AppTint.backColor()
        self.navigationBar.alpha = 1
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.layer.masksToBounds = false
        self.navigationBar.layer.shadowOpacity = 0.5
        self.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
