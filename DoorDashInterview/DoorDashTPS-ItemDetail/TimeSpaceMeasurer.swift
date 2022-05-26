//
//  TimeSpaceMeasurer.swift
//  DoorDashTPS-ItemDetail
//
//  Created by Ethan Hess on 2/9/22.
//  Copyright © 2022 Jeff Cosgriff. All rights reserved.
//

import UIKit

//MARK: TODO measure differences between DispatchGroup, OperationQueue, Locks
class TimeSpaceMeasurer: NSObject {
    
    static func calculateTimeOfExecution(_ startDateMiliseconds: Date, _ endDateMiliseconds: Date) -> TimeInterval {
        return endDateMiliseconds.timeIntervalSince(startDateMiliseconds)
    }
    
    //MARK: TODO space functions
}
