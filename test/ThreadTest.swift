//
//  ThreadTest.swift
//  test
//
//  Created by YeQing on 2020/7/17.
//  Copyright © 2020 laoqingcai. All rights reserved.
//

import Foundation

public class ThreadTest: NSObject {
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
    private var spinlock:OSSpinLock?
    private var unfairlock:os_unfair_lock_t?
    private var semaphore:DispatchSemaphore?
    private var mutex:pthread_mutex_t?
    private var lock:NSLock?
    private var condition:NSCondition?
    private var conditionLock:NSConditionLock?
    private var recursiveLock:NSRecursiveLock?
    
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

        //MARK: - thread
//    public func run() {
//        self.thread1 = Thread(target: self, selector: #selector(test1), object: nil)
//        self.thread1?.start()
//        self.perform(#selector(test2), on: self.thread1!, with: nil, waitUntilDone: true);
//}
    
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
//    public func run() {
////        for i in 1...1000 {
////            self.concurrentQueue.async {
////                sleep(2)
////                NSLog(Thread.current);
////            }
////            NSLog(i);
////        }
//        NSLog("0")
//        self.concurrentQueue.async {
//            NSLog("001")
//        }
//        self.concurrentQueue.async {
//            for i in 1...10000000 {
//                var a:Int = 0;
//                a = a+1
//            }
////            Thread.sleep(until: Date().addingTimeInterval(10))
//            NSLog("1 "+Thread.current.description)
//        }
//        NSLog("00")
////        self.concurrentQueue.async {
////            sleep(2);
////            NSLog("1 "+Thread.current.description)
////        }
////        self.concurrentQueue.async(flags: .barrier, execute: { ()  in
////            sleep(2);
////            NSLog("2 "+Thread.current.description)
////        })
////        NSLog("21 ")
//////        self.concurrentQueue.sync(group: nil, qos: .default, flags: .barrier, execute: {
//////            sleep(2);
//////            NSLog("2 "+Thread.current.description);
//////        })
////        self.concurrentQueue.async {
////            NSLog("3 "+Thread.current.description)
////        }
//}
        
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
//        self.concurrentQueue.async {
//            sleep(3)
//            NSLog("1")
//            group.leave()
//        }
//        group.enter()
//        self.concurrentQueue.async {
//            sleep(3)
//            NSLog("2")
//            group.leave()
//        }
//        group.notify(queue: self.concurrentQueue!) {
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
//                self.concurrentQueue.async {
//                    sleep(5)
//                    NSLog("1:\(i)"+Thread.current.description);
//                    i = i-1
//                    NSLog("2:\(i)"+Thread.current.description);
//                    semaphore.signal()
//                }
//            }
//            self.concurrentQueue.async(flags: .barrier, execute: { ()  in
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
        
        //MARK: - OSSpinLock
//    public func run() {
//        NSLog("start")
//        spinlock = OSSpinLock()
//        for i in 1...10 {
//            self.concurrentQueue.async {
////                OSSpinLockLock(&(self.spinlock!))
////                if (OSSpinLockTry(&(self.spinlock!))) {
//                    sleep(2)
//                    NSLog("\(i):"+Thread.current.description);
//                    OSSpinLockUnlock(&(self.spinlock!))
////                }
//            }
//        }
//        NSLog("end")
//}
        
        //MARK: - os_unfair_lock
//        public func run() {
//        NSLog("start")
//        unfairlock = .allocate(capacity: 1)
//        unfairlock?.initialize(to: os_unfair_lock())
//        for i in 1...10 {
//            self.concurrentQueue.async {
////                os_unfair_lock_lock(self.unfairlock!)
//                if (os_unfair_lock_trylock(self.unfairlock!)) {
//                    sleep(2)
//                    NSLog("\(i):"+Thread.current.description);
//                    os_unfair_lock_unlock(self.unfairlock!)
//                }
//            }
//        }
//        NSLog("end")
//}
        
        //MARK: - Semaphore
//    public func run() {
//        NSLog("start")
//        semaphore = DispatchSemaphore(value: 1)
//        for i in 1...10 {
//            self.concurrentQueue.async {
//                self.semaphore?.wait()
//                sleep(2)
//                NSLog("\(i):"+Thread.current.description);
//                self.semaphore?.signal()
//            }
//        }
//        NSLog("end")
//}
        
        //MARK: - pthread_mutex_t
//    public func run() {
//        NSLog("start")
//        mutex = pthread_mutex_t()
//        pthread_mutex_init(&(self.mutex!), nil)
//        for i in 1...10 {
//            self.concurrentQueue.async {
//                if( pthread_mutex_lock(&(self.mutex!)) == 0) {
//                    sleep(2)
//                    NSLog("\(i):"+Thread.current.description);
//                    pthread_mutex_unlock(&(self.mutex!))
//                }
//            }
//        }
//        NSLog("end")
//}
       
        //MARK: - pthread_mutex_t
//    public func run() {
//        NSLog("start")
//        mutex = pthread_mutex_t()
//        var attr = pthread_mutexattr_t()
//        pthread_mutexattr_init(&attr)
//        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE)
//        pthread_mutex_init(&(self.mutex!), &attr)
//        for i in 1...10 {
//            self.concurrentQueue.async {
//                pthread_mutex_lock(&(self.mutex!))
//                sleep(2)
//                pthread_mutex_lock(&(self.mutex!))
//                NSLog("\(i):"+Thread.current.description);
//                pthread_mutex_unlock(&(self.mutex!))
//                pthread_mutex_unlock(&(self.mutex!))
//            }
//        }
//        NSLog("end")
//}
        
        //MARK: - NSLock
//public func run() {
//        NSLog("start")
//        self.lock = NSLock()
//        for i in 1...10 {
//            self.concurrentQueue.async {
//                self.lock?.lock(before: Date().advanced(by: 100))
//                sleep(5)
//                NSLog("\(i):"+Thread.current.description);
//                self.lock?.unlock()
//            }
//        }
//        NSLog("end")
//}
        
    //MARK: - NSCondition
//    var i = 0;
//    public func run() {
//        NSLog("start")
//        self.condition = NSCondition()
//        self.concurrentQueue.async {
//            self.condition?.lock()
//            while(self.i == 0) {
//                self.condition?.wait()
//            }
//            NSLog("1:"+Thread.current.description);
//            self.condition?.unlock()
//        }
//        self.concurrentQueue.async {
//            self.condition?.lock()
//            while(self.i == 0) {
//                self.condition?.wait()
//            }
//            NSLog("2:"+Thread.current.description);
//            self.condition?.unlock()
//        }
//        self.concurrentQueue.async {
//            self.condition?.lock()
//            sleep(5)
//            self.i += 1
////            self.condition?.signal()
//            self.condition?.broadcast()
//            NSLog("3:"+Thread.current.description);
//            self.condition?.unlock()
//        }
//        NSLog("end")
//    }
    
//        //MARK: - NSConditionLock
//        public func run() {
//            NSLog("start")
//            self.conditionLock = NSConditionLock()
//            self.concurrentQueue.async {
//                self.conditionLock?.lock(whenCondition: 1)
//                NSLog("1:"+Thread.current.description);
//                self.conditionLock?.unlock(withCondition: 2)
//            }
//            self.concurrentQueue.async {
//                self.conditionLock?.lock(whenCondition: 2)
//                NSLog("2:"+Thread.current.description);
//                self.conditionLock?.unlock(withCondition: 2)
//            }
//            self.concurrentQueue.async {
//                self.conditionLock?.lock()
//                sleep(5)
//                NSLog("3:"+Thread.current.description);
//                self.conditionLock?.unlock(withCondition: 1)
//            }
//            NSLog("end")
//        }
    
//    //MARK: - NSRecursiveLock
//    public func run() {
//        NSLog("start")
//        self.recursiveLock = NSRecursiveLock()
//        self.concurrentQueue.async {
//            self.recursiveLock?.lock()
//            sleep(3)
//            self.recursiveLock?.lock()
//            NSLog("1:"+Thread.current.description);
//            self.recursiveLock?.unlock()
//            self.recursiveLock?.unlock()
//        }
//        self.concurrentQueue.async {
//            self.recursiveLock?.lock()
//            sleep(3)
//            NSLog("2:"+Thread.current.description);
//            self.recursiveLock?.unlock()
//        }
//        NSLog("end")
//    }
    
    //MARK: - objc_sync
    var syncObj:NSObject = NSObject()
    public func run() {
        NSLog("start")
        NSLog("a:\(CFGetRetainCount(self.syncObj))")
        self.concurrentQueue.async {
            NSLog("b:\(CFGetRetainCount(self.syncObj))")
            objc_sync_enter(self)
            NSLog("b1:\(CFGetRetainCount(self.syncObj))")
            sleep(3)
            NSLog("1:"+Thread.current.description)
            objc_sync_exit(self)
            NSLog("b2:\(CFGetRetainCount(self.syncObj))")
        }
        self.concurrentQueue.async {
            NSLog("c:\(CFGetRetainCount(self.syncObj))")
            objc_sync_enter(self)
            sleep(3)
            NSLog("2:"+Thread.current.description)
            objc_sync_exit(self)
            NSLog("c1:\(CFGetRetainCount(self.syncObj))")
        }
        NSLog("end")
    }
}

