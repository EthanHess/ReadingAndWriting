//
//  StoreController.swift
//  DoorDashTPS-ItemDetail
//
//  Created by Ethan Hess on 2/15/22.
//  Copyright © 2022 Jeff Cosgriff. All rights reserved.
//

import UIKit
import CoreData

//MARK: Core data, SQL, NSFileManager, Node.js server
class StoreController: NSObject {

    //MARK: FileManager

    static func writeToFileManager(_ image: UIImage, _ pathName: String, andCompletion: @escaping ((_ success: Bool) -> Void)) {
        let directoryPath =  try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let url : NSURL = directoryPath.appendingPathComponent(pathName) as NSURL
        
        if !FileManager.default.fileExists(atPath: url.path!) {
            do {
                try image.jpegData(compressionQuality: 1.0)!.write(to: url as URL)
                andCompletion(true)
            } catch let err {
                print("Error saving \(err)")
                andCompletion(false)
            }
        } else {
            print("File already exists at \(pathName)")
            andCompletion(false)
        }
    }
    
    static func fileExistsAtPath(_ pathName: String) -> Bool {
        guard let thePath = urlFromPath(pathName).path else {
            return false
        }
        return FileManager.default.fileExists(atPath: thePath)
    }
    
    static fileprivate func urlFromPath(_ pathName: String) -> NSURL {
        let directoryPath =  try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let url : NSURL = directoryPath.appendingPathComponent(pathName) as NSURL
        return url
    }
    
    //MARK: Core data
    
    //MARK: SQL
    
    //
}
