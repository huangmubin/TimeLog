//
//  PlanController.swift
//  TimeLog
//
//  Created by 黄穆斌 on 16/7/21.
//  Copyright © 2016年 MuBinHuang. All rights reserved.
//

import UIKit

class PlanController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Values
    
    var plans = [Plan]()
    
    // MARK: - Deploy
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        plans = AppData.plans()
        tableView.reloadData()
    }
    
    // MARK: - Navigation Bar
    
    @IBAction func addPlanAction(sender: UIBarButtonItem) {
        performSegueWithIdentifier("PlanEditor", sender: nil)
    }
    
    // MARK: - Table View
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plans.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PlanListCell", forIndexPath: indexPath) as! PlanListCell
        
        cell.indexPath = indexPath
        cell.actions   = tableViewCellActions
        
        
        cell.nameLabel.text = plans[indexPath.row].name
        cell.todayLabel.text = Clock.time(plans[indexPath.row].today)
        cell.totalLabel.text = Clock.time(plans[indexPath.row].total)
        cell.ratioLabel.text = String(format: "%.0f %%", plans[indexPath.row].total * 100 / plans[indexPath.row].goal)
        
        
        return cell
    }
    
    func tableViewCellActions(note: String, indexPath: NSIndexPath) {
        print("note = \(note); indexPath = \(indexPath.row)")
        performSegueWithIdentifier(note, sender: plans[indexPath.row])
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "PlanEditor":
            let controller = segue.destinationViewController as! PlanEditorController
            controller.plan = sender as? Plan
        case "LogEditor":
            let controller = segue.destinationViewController as! LogEditorController
            if let plan = sender as? Plan {
                controller.id = plan.id
                controller.name = plan.name
            }
        default:
            break
        }
    }

}
