//
//  PlanChorViewController.swift
//  TimeLog
//
//  Created by 黄穆斌 on 16/7/21.
//  Copyright © 2016年 MuBinHuang. All rights reserved.
//

import UIKit

class PlanTimeChoicerController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Values
    
    var day: Bool = true
    var time: Double = 0
    var action: ((Bool, Double) -> Void)?
    
    // MARK: - Deploy
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: Int(time), inSection: 0), atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
    }

    @IBAction func backAction(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - TableView
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return day ? 999 : 288
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PlanTimeChoicerCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = day ? String(format: "%d 天", indexPath.row+1) : String(format: "%d 分钟 (%.1f 小时)", (indexPath.row+1) * 5, Double(indexPath.row+1) / 12)
        
        cell.accessoryType = indexPath.row == Int(time) ? UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            action?(day, Double(indexPath.row  + 1) * (day ? 1 : 300))
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
    }
}
