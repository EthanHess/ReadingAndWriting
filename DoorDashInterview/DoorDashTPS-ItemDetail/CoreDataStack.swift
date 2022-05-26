//
//  CoreDataStack.swift
//  DoorDashTPS-ItemDetail
//
//  Created by Ethan Hess on 2/9/22.
//  Copyright © 2022 Jeff Cosgriff. All rights reserved.
//

import UIKit
import CoreData

class CoreDataStack: NSObject {
    
    //MARK: MOC
    lazy var managedObjectContext : NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        return moc
    }()
    
    override init() {
        super.init()
        
        setUpMOC()
    }
    
    fileprivate func setUpMOC() {
        //mainQueueConcurrencyType set in computed property
        self.managedObjectContext.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel())
        
        do {
            try self.managedObjectContext.persistentStoreCoordinator?.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.storeURL(), options: nil)
        } catch let err {
            print("Something failed in core data stack \(err.localizedDescription)")
        }
    }
    
    fileprivate func storeURL() -> URL? {
        let documentsDirectory = try? FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: true)
        return documentsDirectory?.appendingPathComponent("db.sqlite")
    }
    
    fileprivate func modelURL() -> URL {
        return Bundle.main.url(forResource: "Model", withExtension: "momd")!
    }
        
    fileprivate func managedObjectModel () -> NSManagedObjectModel {
        return NSManagedObjectModel(contentsOf: self.modelURL())!
    }
}
