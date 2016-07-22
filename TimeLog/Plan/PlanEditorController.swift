//
//  PlanEditorController.swift
//  TimeLog
//
//  Created by 黄穆斌 on 16/7/21.
//  Copyright © 2016年 MuBinHuang. All rights reserved.
//

import UIKit

class PlanEditorController: UIViewController, UITextViewDelegate {

    // MARK: - Values
    
    var plan: Plan?
    
    var day: Double = 10 {
        didSet {
            dayButton.setTitle(String(format: "  我要坚持 %.0f 天", day), forState: .Normal)
        }
    }
    
    var time: Double = 3600 {
        didSet {
            timeButton.setTitle(String(format: "  每天投入 %.0f 分钟 (%.1f 小时)", time / 60, time / 3600), forState: .Normal)
        }
    }
    
    func setTime(day: Bool, time: Double) {
        if day {
            self.day = time
        } else {
            self.time = time
        }
    }
    
    // MARK: - Deploy
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if plan != nil {
            textField.text = plan?.name
            day = plan!.day
            time = plan!.time
            textView.text = plan?.note
            saveButton.enabled = true
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        Notification.remove(self)
    }
    
    // MARK: - Views
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var dayButton: Button!
    @IBOutlet weak var timeButton: Button!
    @IBOutlet weak var textView: TextView!
    @IBOutlet weak var deleteButton: Button!
    
    // MARK: - Actions
    
    @IBAction func backAction(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func saveAction(sender: UIBarButtonItem) {
        if plan == nil {
            plan = AppData.insertPlan()
        }
        
        plan?.name = textField.text
        plan?.day = day
        plan?.time = time
        plan?.note = textView.text
        plan?.goal = time * day
        
        CoreData.save()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    @IBAction func textFieldChangedAction(sender: UITextField) {
        saveButton.enabled = sender.text?.isEmpty == false
    }
    
    @IBAction func timeChoicerActions(sender: Button) {
        performSegueWithIdentifier("PlanTimeChoicer", sender: sender.note == "Day")
    }
    
    @IBAction func deleteAction(sender: Button) {
        AppData.delete(plan!)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Layout
    
    @IBOutlet weak var topLayout: NSLayoutConstraint!
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PlanTimeChoicer" {
            let choicer = segue.destinationViewController as! PlanTimeChoicerController
            choicer.action = setTime
            choicer.day = sender as! Bool
            choicer.time = choicer.day ? day - 1 : Double(Int(time / 360) + 1)
        }
    }
    
    
    // MARK: - Keyboard
    
    @IBAction func tapGestureAction(sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
        textView.resignFirstResponder()
    }
    @IBAction func swipeGestureAction(sender: UISwipeGestureRecognizer) {
        textField.resignFirstResponder()
        textView.resignFirstResponder()
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        
        UIView.animateWithDuration(0.3) {
            self.topLayout.constant = 0
            self.view.layoutIfNeeded()
        }
        
        return true
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        UIView.animateWithDuration(0.3) { 
            self.topLayout.constant = 20
            self.view.layoutIfNeeded()
        }
        return true
    }
    
}
