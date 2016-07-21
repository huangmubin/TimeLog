//
//  CoreData.swift
//  TimeLog
//
//  Created by 黄穆斌 on 16/7/11.
//  Copyright © 2016年 Myron. All rights reserved.
//

import UIKit
import CoreData

let ProjectName = "TimeLog"
class CoreData {
    
    static let context = CoreData()
    
    // MARK: - 常用方法 - 保存，删除，插入，查找
    
    /// 保存数据。
    class func save() {
        context.saveContext()
    }
    
    /// 删除数据。
    class func delete(data: NSManagedObject) {
        context.managedObjectContext.deleteObject(data)
    }
    
    /// 插入新数据
    class func insert(name: String) -> NSManagedObject {
        return NSEntityDescription.insertNewObjectForEntityForName(name, inManagedObjectContext: context.managedObjectContext)
    }
    
    /// 查找数据
    class func find(name: String, predicate: String, sorts: [(String, Bool)], type: NSFetchRequestResultType, limit: Int, offset: Int) -> AnyObject? {
        /**
         根据完整的条件进行数据返回。（完整版）
         - parameter name: 数据库名称
         - parameter predicate: 查询条件
         - parameter sorts: 排序条件
         - parameter type: 返回数据的类型 <br/>
         ManagedObjectResultType     : 数据库对象（默认）[NSManagedObject] <br/>
         ManagedObjectIDResultType   : 返回特殊的标记，而不是真实的对象，其实这个有点儿像 hashCode 的意思，类似于数据库的主键。 <br/>
         DictionaryResultType        : 把数据对象字典化 [[String:AnyObject]] <br/>
         CountResultType             : 数据数量 [Int]
         - parameter limit: 限制查询结果数目
         - parameter offset: 忽略查询结果的前几条
         - returns: 数据库对象。 实际上应该都是 NSArray?
         */
        
        // Request
        let request = NSFetchRequest(entityName: name)
        
        // Sort
        request.sortDescriptors = sorts.flatMap { return NSSortDescriptor(key: $0.0, ascending: $0.1) }
        
        // Predicate
        request.predicate = NSPredicate(format: predicate)
        
        // ResultType
        /*
         ManagedObjectResultType     : 数据库对象（默认）[NSManagedObject]
         ManagedObjectIDResultType   : 返回特殊的标记，而不是真实的对象，其实这个有点儿像 hashCode 的意思，类似于数据库的主键。
         DictionaryResultType        : 把数据对象字典化 [[String:AnyObject]]
         CountResultType             : 数据数量 [Int]
         */
        request.resultType = type
        
        // Limit
        request.fetchLimit = limit
        request.fetchOffset = offset
        
        return try? context.managedObjectContext.executeFetchRequest(request)
    }
    
    
    // MARK: - AppDelegate Code
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "Myron.TimeLog" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource(ProjectName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
}
