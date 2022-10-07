//
//  GCDViewController.swift
//  DoorDashTPS-ItemDetail
//
//  Created by Ethan Hess on 10/7/22.
//  Copyright © 2022 Jeff Cosgriff. All rights reserved.
//

import UIKit

class GCDViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDataAndMeasureDifferencesDG()
        //fetchDataAndMeasureDifferencesOQ()
    }
    
    // var arrayClosure: ((_ array: [Int]) -> Void)
    
    //MARK: iterate through random fire closures to simulate async network calls to test different fetch methods and their timing / complexity.
    
    //Dispatch Group
    fileprivate func fetchDataAndMeasureDifferencesDG() {
        let array = [1, 2, 3, 4, 5]

        let dispatchGroup = DispatchGroup()
        
        let dgEnterTime = Date()
        for num in array {
            dispatchGroup.enter()
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(num / 2)) {
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            let dgLeaveTime = Date()
            let timeElapsed = TimeSpaceMeasurer.calculateTimeOfExecution(dgEnterTime, dgLeaveTime)
            print("DG Finished! \(timeElapsed)")
        }
    }
    
    //Operation Queue
//    fileprivate func fetchDataAndMeasureDifferencesOQ() {
//        let array = [1, 2, 3, 4, 5]
//
//        let operationQueue = OperationQueue()
//
//
//    }
    
    //Semaphore
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
