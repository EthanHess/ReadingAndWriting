//
//  LockVisualizer.swift
//  DoorDashTPS-ItemDetail
//
//  Created by Ethan Hess on 1/11/23.
//  Copyright © 2023 Jeff Cosgriff. All rights reserved.
//

import UIKit

class LockVisualizer: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        lockRender()
    }
    
    private func lockRender() {
        
        //TODO add UI elements to visualize this
        
        //One instance of person
        let person = Person()
        
        DispatchQueue.main.async {
            print("Main hit \(Thread.isMainThread)")
            person.setName("Daniel", lastName: "Jones")
        }
        let otherQueue = DispatchQueue(label: "bg_q", qos: .background)
        otherQueue.async {
            print("BG hit \(Thread.isMainThread)")
            person.setName("John", lastName: "Smith")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            print("PERSON FULL NAME \(person.fullName)")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class Person {
    
    //var lock = NSLock()
    
    private(set) var firstName = ""
    private(set) var lastName = ""
    
    var fullName : String {
        get {
            return "\(firstName) \(lastName)"
        }
    }
    
    func setName(_ firstName: String, lastName: String) {
        //lock.lock()
        self.firstName = firstName
        self.lastName = lastName
        //lock.unlock()
    }
}
