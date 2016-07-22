//
//  PlanListCell.swift
//  TimeLog
//
//  Created by 黄穆斌 on 16/7/21.
//  Copyright © 2016年 MuBinHuang. All rights reserved.
//

import UIKit

class PlanListCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        //backView.layer.masksToBounds = true
        nameLabel.textColor = AppTint.fontColor().main
        todayLabel.textColor = AppTint.fontColor().main
        totalLabel.textColor = AppTint.fontColor().main
        ratioLabel.textColor = AppTint.fontColor().main
    }
    
    @IBOutlet weak var backView: View!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var ratioLabel: UILabel!
    
    var indexPath: NSIndexPath!
    var actions: ((String, NSIndexPath) -> Void)?

    @IBAction func buttonActions(sender: Button) {
        actions?(sender.note, indexPath)
    }
    
    
}
