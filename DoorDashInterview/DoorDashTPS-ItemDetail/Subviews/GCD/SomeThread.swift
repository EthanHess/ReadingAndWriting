//
//  SomeThread.swift
//  DoorDashTPS-ItemDetail
//
//  Created by Ethan Hess on 1/11/23.
//  Copyright © 2023 Jeff Cosgriff. All rights reserved.
//

import UIKit

//An abstract data structure where process happen (are executed)
class SomeThread: UIView {
    
    var assiciatedRunLoop : SomeRunLoop?
    var associatedQueue : SomeQueue?
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
