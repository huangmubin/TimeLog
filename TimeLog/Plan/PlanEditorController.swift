//
//  PlanEditorController.swift
//  TimeLog
//
//  Created by 黄穆斌 on 16/7/21.
//  Copyright © 2016年 MuBinHuang. All rights reserved.
//

import UIKit

class PlanEditorController: UIViewController {

    // MARK: - Values
    
    var plan: Plan?
    
    var day: Double = 10 {
        didSet {
            
        }
    }
    
    var time: Double = 3600 {
        didSet {
            
        }
    }
    
    // MARK: - Deploy
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Views
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var dayButton: Button!
    @IBOutlet weak var timeButton: Button!
    @IBOutlet weak var textView: TextView!
    @IBOutlet weak var deleteButton: Button!
    
    // MARK: - Actions
    
    @IBAction func textFieldChangedAction(sender: UITextField) {
        saveButton.enabled = sender.text?.isEmpty == false
    }
    
    @IBAction func timeChoicerActions(sender: Button) {
        performSegueWithIdentifier("PlanTimeChoicer", sender: sender.note == "Day")
    }
    
    @IBAction func deleteAction(sender: Button) {
        
    }
    
    // MARK: - Layout
    
    @IBOutlet weak var topLayout: NSLayoutConstraint!
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PlanTimeChoicer" {
            let choicer = segue.destinationViewController as! PlanTimeChoicerController
        }
    }

}
