//
//  Log+CoreDataProperties.swift
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

extension Log {

    @NSManaged var id: String?
    @NSManaged var name: String?
    @NSManaged var start: Double
    @NSManaged var end: Double
    @NSManaged var duration: Double
    @NSManaged var note: String?
    @NSManaged var json: NSData?

}
