//
//  GCDVisualizer.swift
//  DoorDashTPS-ItemDetail
//
//  Created by Ethan Hess on 1/10/23.
//  Copyright © 2023 Jeff Cosgriff. All rights reserved.
//

import UIKit

//MARK: visualizing threadpools + concurrency

//From Wikipedia

//In computer programming, a thread pool is a software design pattern for achieving concurrency of execution in a computer program. Often also called a replicated workers or worker-crew model, a thread pool maintains multiple threads waiting for tasks to be allocated for concurrent execution by the supervising program.

class GCDVisualizer: UIView {
    
    //'lazy' cannot be used on a computed property since we want to postpone initialization (the whole point of lazy)
    
    //lazy has to be var becaue the value will change when it's mutated (used) unlike a constant that could be initialized on class init
    
    //() initializes, without it's just a computed property
    lazy var mainThreadPool : MainThreadPool = {
        let pool = MainThreadPool()
        return pool
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    fileprivate func configureSubviews() {
        
    }
    
    fileprivate func concurrencyTest() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
