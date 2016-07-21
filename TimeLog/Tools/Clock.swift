//
//  Clock.swift
//  TimeLog
//
//  Created by 黄穆斌 on 16/7/15.
//  Copyright © 2016年 Myron. All rights reserved.
//

import UIKit

class Clock: NSObject {
    
    // MARK: - 时间范围
    
    /// 输出日期当年的时间范围
    class func yearRange(date: NSDate) -> (start: NSDate, end: NSDate) {
        let calendar = NSCalendar.autoupdatingCurrentCalendar()
        var start: NSDate?
        calendar.rangeOfUnit(NSCalendarUnit.Year, startDate: &start, interval: nil, forDate: date)
        let days = calendar.component(NSCalendarUnit.Year, fromDate: date) % 4 == 0 ? 366 : 365
        let end = NSDate(timeIntervalSince1970: start!.timeIntervalSince1970 + Double(86400 * days))
        return (start!, end)
    }
    
    /// 输出日期当天的时间范围
    class func dayRange(date: NSDate) -> (start: NSDate, end: NSDate) {
        let calendar = NSCalendar.autoupdatingCurrentCalendar()
        var start: NSDate?
        calendar.rangeOfUnit(NSCalendarUnit.Day, startDate: &start, interval: nil, forDate: date)
        let end = NSDate(timeIntervalSince1970: start!.timeIntervalSince1970 + 86400)
        return (start!, end)
    }
    
    /// 输出日期当天的时间范围
    class func dayRange(date: Double) -> (start: Double, end: Double) {
        let calendar = NSCalendar.autoupdatingCurrentCalendar()
        var start: NSDate?
        calendar.rangeOfUnit(NSCalendarUnit.Day, startDate: &start, interval: nil, forDate: NSDate(timeIntervalSince1970: date))
        return (start!.timeIntervalSince1970, start!.timeIntervalSince1970 + 86400)
    }
    
    
    /// 输出日期当月的时间范围
    class func monthRange(date: NSDate) -> (start: NSDate, end: NSDate) {
        let calendar = NSCalendar.autoupdatingCurrentCalendar()
        var start: NSDate?
        calendar.rangeOfUnit(NSCalendarUnit.Month, startDate: &start, interval: nil, forDate: date)
        let days = calendar.rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: start!).length
        let end = NSDate(timeIntervalSince1970: start!.timeIntervalSince1970 + Double(86400 * days))
        return (start!, end)
    }
    
    /// 输出日期当年每个月的时间范围
    class func monthRangeInYear(date: NSDate) -> [(start: NSDate, end: NSDate)] {
        let calendar = NSCalendar.autoupdatingCurrentCalendar()
        var start: NSDate?
        calendar.rangeOfUnit(NSCalendarUnit.Year, startDate: &start, interval: nil, forDate: date)
        var ranges = [(start: NSDate, end: NSDate)](count: 12, repeatedValue: (start!, start!))
        for i in 0 ..< 12 {
            ranges[i] = monthRange(NSDate(timeIntervalSince1970: start!.timeIntervalSince1970 + Double(i) * 2678400))
        }
        return ranges
    }
    
    /// 输出日期当周的时间范围
    class func weekRange(date: NSDate) -> (start: NSDate, end: NSDate) {
        let calendar = NSCalendar.autoupdatingCurrentCalendar()
        var start: NSDate?
        calendar.rangeOfUnit(NSCalendarUnit.WeekOfYear, startDate: &start, interval: nil, forDate: date)
        let end = NSDate(timeIntervalSince1970: start!.timeIntervalSince1970 + 604800)
        return (start!, end)
    }
    
    /// 将日期格式化为 1分钟 单位的日期
    class func unitDate(date: NSDate) -> NSDate {
        if date.timeIntervalSince1970 % 60 == 0 {
            return date
        } else {
            return NSDate(timeIntervalSince1970: date.timeIntervalSince1970 - date.timeIntervalSince1970 % 60 + 60)
        }
    }

    /// 把时间转换成合适的单位
    class func time(time: Double) -> String {
        let date = time / 60
        if date > 60 {
            return String(format: "%.1f 小时", date / 60)
        } else {
            return String(format: "%.0f 分钟", date)
        }
    }
    
}
