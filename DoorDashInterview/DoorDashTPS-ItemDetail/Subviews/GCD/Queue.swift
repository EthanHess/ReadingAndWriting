//
//  Queue.swift
//  DoorDashTPS-ItemDetail
//
//  Created by Ethan Hess on 1/10/23.
//  Copyright © 2023 Jeff Cosgriff. All rights reserved.
//

import UIKit

//Associated with a thread, a queue lines up tasks to be executed on a thread
//Queues can be serial or concurrent
//Serial = one task at a time (fifo)
//Concurrent = multiple tasks in no particular order
//In iOS, the main queue is serial and (obviously) associated with the main thread, only use predominately for UI related tasks (nothing expensive / intense)

enum QueueType {
    case serial
    case concurrent
}

class Queue: UIView {
    
    var queueType : QueueType = .serial {
        didSet {
            //Update
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    fileprivate func viewConfigure() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
