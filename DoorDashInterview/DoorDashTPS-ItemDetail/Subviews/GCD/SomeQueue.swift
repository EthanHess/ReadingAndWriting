//
//  SomeQueue.swift
//  DoorDashTPS-ItemDetail
//
//  Created by Ethan Hess on 1/11/23.
//  Copyright © 2023 Jeff Cosgriff. All rights reserved.
//

import UIKit

enum QueueType {
    case serial
    case concurrent
}

class SomeQueue: UIView {
    
    var queueType : QueueType = .serial {
        didSet {
            //Update
        }
    }
    
    //Use "some" because w/o is already Swift keyword which will cause conflict
    weak var associatedThread : SomeThread?
    var tasks : [SomeTask] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    fileprivate func viewConfigure() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
