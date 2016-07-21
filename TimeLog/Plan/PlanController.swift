//
//  PlanController.swift
//  TimeLog
//
//  Created by 黄穆斌 on 16/7/21.
//  Copyright © 2016年 MuBinHuang. All rights reserved.
//

import UIKit

class PlanController: UIViewController {

    // MARK: - Navigation Bar
    
    @IBAction func addPlanAction(sender: UIBarButtonItem) {
        performSegueWithIdentifier("PlanEditor", sender: nil)
    }
    

}
