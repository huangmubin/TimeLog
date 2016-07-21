//
//  AppData.swift
//  TimeLog
//
//  Created by 黄穆斌 on 16/7/21.
//  Copyright © 2016年 MuBinHuang. All rights reserved.
//

import UIKit

private var Order: [String] = []

class AppData {

    
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
