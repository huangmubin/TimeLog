//
//  Plan+CoreDataProperties.swift
//  TimeLog
//
//  Created by 黄穆斌 on 16/7/21.
//  Copyright © 2016年 MuBinHuang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Plan {

    @NSManaged var image: String?
    @NSManaged var time: Double
    @NSManaged var id: String?
    @NSManaged var day: Double
    @NSManaged var createTime: Double
    @NSManaged var name: String?
    @NSManaged var goal: Double
    @NSManaged var note: String?
    @NSManaged var json: NSData?

}
