//
//  GCDViewController.swift
//  DoorDashTPS-ItemDetail
//
//  Created by Ethan Hess on 10/7/22.
//  Copyright © 2022 Jeff Cosgriff. All rights reserved.
//

import UIKit

class GCDViewController: UIViewController {
    
//    let dataFetcher : DataFetcher
//
//    //MARK: Dependency injection
//    init(dataFetcher: DataFetcher) {
//        self.dataFetcher = dataFetcher
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDataAndMeasureDifferencesDG()
        fetchDataAndMeasureDifferencesSEM()
        view.backgroundColor = .white
        //fetchDataAndMeasureDifferencesOQ()
        
//        _ = genericFunc(someVal: "Hey!")
//        _ = genericFunc(someVal: 10)
        
        gcdSetup()
    }
    
    fileprivate func gcdSetup() {
        let lv = LockVisualizer() //TODO add to screen inside GCDVisualizer
        //view.addSubview(lv)
    }
    
    fileprivate func genericFunc<T>(someVal: T) -> T {
        return someVal
    }
    
    // var arrayClosure: ((_ array: [Int]) -> Void)
    
    //MARK: iterate through random fire closures to simulate async network calls to test different fetch methods and their timing / complexity.
    
    //AsyncSequence (replacing Dispatch Group)
    
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
//        let operationQueue = OperationQueue()
//
//        //TODO imp.
//    }
    
    
    //Semaphore (more to protect a shared resource vs. group where tasks are independent)
    fileprivate func fetchDataAndMeasureDifferencesSEM() {
        let array = [1, 2, 3, 4, 5]
        let dispatchQueue = DispatchQueue(label: "peopleFetch")
        let dispatchSemaphore = DispatchSemaphore(value: 0)
        
        let semEnterTime = Date()
        dispatchQueue.async { //prevent freezing, will freeze on main queue
            for num in array {
                dispatchQueue.asyncAfter(deadline: .now() + Double(num / 2)) {
                    dispatchSemaphore.signal()
                }
                dispatchSemaphore.wait()
            }
        }
        let semEndTime = Date()
        let timeElapsed = TimeSpaceMeasurer.calculateTimeOfExecution(semEnterTime, semEndTime)
        print("SEM Finished! \(timeElapsed)")
    }
    
    
    //MARK: Networking
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//Operation subclass (is abstract, need to subclass instead of use directly)
class DataOperation: Operation {
    typealias SuccessCompletion = (_ success: Result<Bool, Error>) -> Void
    var theHandler : (SuccessCompletion)? //If reference to self needed, weakify to avoid retain cycle
    
//    func launchOperation() {
//        if let theHandler = theHandler {
//            theHandler(.success(true))
//        }
//    }
}
