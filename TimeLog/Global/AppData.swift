//
//  AppData.swift
//  TimeLog
//
//  Created by 黄穆斌 on 16/7/21.
//  Copyright © 2016年 MuBinHuang. All rights reserved.
//

import UIKit
import CoreData

private var Order: [String] = []

class AppData {

    // MARK: - Insert
    
    class func insertPlan() -> Plan {
        let plan = CoreData.insert("Plan") as! Plan
        plan.createTime = NSDate().timeIntervalSince1970
        plan.id = String(format: "%.4f", plan.createTime)
        return plan
    }
    
    // MARK: - Delete
    
    class func delete(data: NSManagedObject) {
        if let plan = data as? Plan {
            let loglist = logs(plan.id!)
            for log in loglist {
                CoreData.delete(log)
            }
        }
        CoreData.delete(data)
        CoreData.save()
    }
    
    // MARK: - Find
    
    class func plans() -> [Plan] {
        if let datas = CoreData.find("Plan", predicate: "id != ''", sorts: [], type: .ManagedObjectResultType, limit: 0, offset: 0) as? [Plan] {
            var plans = [Plan]()
            for o in Order {
                let index = datas.indexOf({ $0.id == o })!
                plans.append(datas[index])
            }
            return plans
        }
        return []
    }
    
    class func logs(id: String) -> [Log] {
        if let datas = CoreData.find("Log", predicate: "id == '\(id)'", sorts: [("start", true)], type: .ManagedObjectResultType, limit: 0, offset: 0) as? [Log] {
            return datas
        }
        return []
    }
    
    // MARK: - Order
    
    /// 保存顺序
    class func orderSave() {
        NSUserDefaults.standardUserDefaults().setObject(Order, forKey: "Order")
    }
    
    /// 读取顺序
    class func orderRead() {
        Order = (NSUserDefaults.standardUserDefaults().objectForKey("Order") as? [String]) ?? []
    }
    
}
