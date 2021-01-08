//
//  ZHThreadTest.swift
//  ZHThreadsDemo
//
//  Created by YeQing on 2020/12/23.
//  Copyright © 2020 mengdong. All rights reserved.
//

import Foundation

public class ZHThreadTest {
    
    //MARK: - property
    private var timer = Timer(timeInterval: 1, repeats: true) { (timer) in
        NSLog("a");
    }
    private var pthread:pthread_t?
    private var thread1:Thread?
    private lazy var serialQueue:DispatchQueue = {
        return DispatchQueue(label: "queue1", qos: .default, attributes: DispatchQueue.Attributes.init(rawValue: 0), autoreleaseFrequency: .inherit, target: nil)
    }()
    private lazy var concurrentQueue:DispatchQueue = {
        return DispatchQueue(label: "queue2", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
    }()
    private var unfairlock:os_unfair_lock_t?
    private var semaphore:DispatchSemaphore?
    private var mutex:pthread_mutex_t?
    private var lock:NSLock?
    private var condition:NSCondition?
    private var conditionLock:NSConditionLock?
    private var recursiveLock:NSRecursiveLock?
    private var rwlock:pthread_rwlock_t?
    
    //MARK: - thread action
    @objc func test1() {
        NSLog("1");
        RunLoop.current.add(self.timer, forMode: .common)
//        RunLoop.current.add(NSMachPort(), forMode: .common)
        RunLoop.current.run()
        self.timer.fire()
    }
    @objc func test2() {
        NSLog("2");
    }

//        //MARK: - thread
//    public func run() {
//        self.thread1 = Thread(target: self, selector: #selector(test1), object: nil)
//        self.thread1?.start()
//        self.perform(#selector(test2), on: self.thread1!, with: nil, waitUntilDone: true);
//    }
    
        //MARK: - serial
//    public func run() {
//        for i in 1...1000 {
//            self.serialQueue?.sync {
//                sleep(2)
//                NSLog(Thread.current);
//            }
//            NSLog(i);
//        }
//     }
        
        //MARK: - concurrent
    public func run() {
        let queue = DispatchQueue.global(qos: .default)
        for i in 1...1000 {
            queue.async {
                sleep(2)
                NSLog("%d:", i, Thread.current.description)
            }
        }
//        NSLog("0")
//        DispatchQueue.global(qos: .default).async {
//            NSLog("001")
//        }
//        DispatchQueue.global(qos: .default).async {
//            for i in 1...10000000 {
//                var a:Int = 0;
//                a = a+1
//            }
////            Thread.sleep(until: Date().addingTimeInterval(10))
//            NSLog("1 "+Thread.current.description)
//        }
//        NSLog("00")
////        DispatchQueue.global(qos: .default).async {
////            sleep(2);
////            NSLog("1 "+Thread.current.description)
////        }
////        DispatchQueue.global(qos: .default).async(flags: .barrier, execute: { ()  in
////            sleep(2);
////            NSLog("2 "+Thread.current.description)
////        })
////        NSLog("21 ")
//////        DispatchQueue.global(qos: .default).sync(group: nil, qos: .default, flags: .barrier, execute: {
//////            sleep(2);
//////            NSLog("2 "+Thread.current.description);
//////        })
////        DispatchQueue.global(qos: .default).async {
////            NSLog("3 "+Thread.current.description)
////        }
}
        
        //MARK: - dispatch_async_apply
//    public func run() {
//        NSLog("start")
//        DispatchQueue.concurrentPerform(iterations: 10) { (index) in
//            sleep(2)
//            NSLog(index)
//        }
//        NSLog("end")
//}
        
        //MARK: - DispatchGroup
//    public func run() {
//        NSLog("start")
//        let group = DispatchGroup()
//        group.enter()
//        DispatchQueue.global(qos: .default).async {
//            sleep(3)
//            NSLog("1")
//            group.leave()
//        }
//        group.enter()
//        DispatchQueue.global(qos: .default).async {
//            sleep(3)
//            NSLog("2")
//            group.leave()
//        }
//        group.notify(queue: DispatchQueue.global(qos: .default)!) {
//            NSLog("3")
//        }
//        NSLog("end")
//}
        
        //MARK: - DispatchSemaphore
//    public func run() {
//        NSLog("start")
//        self.serialQueue?.async {
//            let semaphore = DispatchSemaphore(value: 1);
//            var i:Int = 100;
//            for _ in 1...10 {
//                semaphore.wait()
//                DispatchQueue.global(qos: .default).async {
//                    sleep(5)
//                    NSLog("1:\(i)"+Thread.current.description);
//                    i = i-1
//                    NSLog("2:\(i)"+Thread.current.description);
//                    semaphore.signal()
//                }
//            }
//            DispatchQueue.global(qos: .default).async(flags: .barrier, execute: { ()  in
//                NSLog("end:\(i)")
//            })
//        }
//        NSLog("end1")
//}
        
        //MARK: - Operation
//    public func run() {
//        NSLog("start")
//        let opq = OperationQueue()
//        opq.maxConcurrentOperationCount = 1;
//        let op = BlockOperation {
//            sleep(5)
//            NSLog("1:"+Thread.current.description);
//        }
//        op.addExecutionBlock {
//            sleep(5)
//            NSLog("2:"+Thread.current.description);
//        }
//        op.addExecutionBlock {
//            sleep(5)
//            NSLog("3:"+Thread.current.description);
//        }
//        op.start()
//        NSLog("end1")
//}
        
        //MARK: - pthread
//    public func run() {
//        NSLog("start")
//        test()
//        NSLog("end")
//}
}
