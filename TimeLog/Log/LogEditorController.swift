//
//  LogEditorController.swift
//  TimeLog
//
//  Created by 黄穆斌 on 16/7/22.
//  Copyright © 2016年 MuBinHuang. All rights reserved.
//

import UIKit

enum TimeType {
    case Start
    case End
    case Off
}

class LogEditorController: UIViewController, UITextViewDelegate {

    // MARK: - Values
    
    var log: Log?
    var id: String!
    var name: String!
    
    var format = NSDateFormatter()
    var start: Double = 0 {
        didSet {
            startButton.setTitle("  开始: \(format.stringFromDate(NSDate(timeIntervalSince1970: start)))", forState: .Normal)
        }
    }
    var end: Double = 0 {
        didSet {
            endButton.setTitle("  结束: \(format.stringFromDate(NSDate(timeIntervalSince1970: end)))", forState: .Normal)
        }
    }
    
    // MARK: - Deploy
    
    override func viewDidLoad() {
        super.viewDidLoad()
        format.dateFormat = "yyyy-MM-dd HH:mm"
        
        if log != nil {
            id = log?.id
            name = log?.name
            start = log!.start
            end   = log!.end
            
            textView.note = log?.note
        } else {
            end = Clock.unitDate(NSDate()).timeIntervalSince1970
            start = end - 1800
        }
        
        nameLabel.text = name
    }
    
    // MARK: - Navigation Bar
    
    @IBAction func backAction(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func saveAction(sender: UIBarButtonItem) {
        if log == nil {
            log = AppData.insertLog(id, name: name)
        }
        
        log?.start = start
        log?.end = end
        log?.note = textView.note
        
        CoreData.save()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Name
    
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: - Time
    
    @IBOutlet weak var startButton: Button!
    @IBOutlet weak var endButton: Button!
    
    @IBOutlet weak var startImage: UIImageView!
    @IBOutlet weak var endImage: UIImageView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var timeType = TimeType.Off {
        didSet {
            switch timeType {
            case .Off:
                animationDataPicker(true, show: false)
            case .Start:
                animationDataPicker(true, show: true)
            case .End:
                animationDataPicker(false, show: true)
            }
        }
    }
    
    @IBAction func timeActions(sender: Button) {
        datePicker.date = NSDate(timeIntervalSince1970: sender === startButton ? start : end)
        switch timeType {
        case .Off:
            if sender === startButton {
                timeType = TimeType.Start
            } else {
                timeType = TimeType.End
            }
        case .Start:
            if sender === startButton {
                timeType = TimeType.Off
            } else {
                timeType = TimeType.End
            }
        case .End:
            if sender === startButton {
                timeType = TimeType.Start
            } else {
                timeType = TimeType.Off
            }
        }
    }
    
    @IBAction func datePickerAction(sender: UIDatePicker) {
        if timeType == TimeType.Start {
            start = sender.date.timeIntervalSince1970
            if end <= start {
                end = start + 1800
            }
        } else {
            end = sender.date.timeIntervalSince1970
            if start >= end {
                start = end - 1800
            }
        }
    }
    
    // MARK: - Text View
    
    @IBOutlet weak var textView: TextView!
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        animationTop(true)
        return true
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        animationTop(false)
        return true
    }
    
    @IBAction func tapGestureAction(sender: UITapGestureRecognizer) {
        textView.resignFirstResponder()
    }
    @IBAction func swipeGestureAction(sender: UISwipeGestureRecognizer) {
        textView.resignFirstResponder()
    }
    
    
    // MARK: - Layout
    
    @IBOutlet weak var topLayout: NSLayoutConstraint!
    
    @IBOutlet weak var timeHeightLayout: NSLayoutConstraint!
    @IBOutlet weak var buttonSpaceLayout: NSLayoutConstraint!
    @IBOutlet weak var datePickerLayout: NSLayoutConstraint!
    
    // MARK: - Animation
    
    func animationDataPicker(start: Bool, show: Bool) {
        UIView.animateWithDuration(0.3) { 
            if show {
                self.timeHeightLayout.constant = 264
                if start {
                    self.buttonSpaceLayout.constant = 176
                    self.datePickerLayout.constant = 52
                    
                    self.startImage.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
                    self.endImage.transform = CGAffineTransformMakeRotation(CGFloat(0))
                } else {
                    self.buttonSpaceLayout.constant = 8
                    self.datePickerLayout.constant = 96
                    
                    self.startImage.transform = CGAffineTransformMakeRotation(CGFloat(0))
                    self.endImage.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
                }
            } else {
                self.timeHeightLayout.constant = 96
                self.buttonSpaceLayout.constant = 8
                self.datePickerLayout.constant = 96
                
                self.startImage.transform = CGAffineTransformMakeRotation(CGFloat(0))
                self.endImage.transform = CGAffineTransformMakeRotation(CGFloat(0))
            }
            self.view.layoutIfNeeded()
        }
    }
    
    func animationTop(scroll: Bool) {
        UIView.animateWithDuration(0.3) { 
            self.topLayout.constant = scroll ? 0 : 20
        }
    }
    
}
