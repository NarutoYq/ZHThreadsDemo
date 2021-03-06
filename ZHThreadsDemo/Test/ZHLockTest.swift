//
//  ZHLockTest.swift
//  ZHThreadsDemo
//
//  Created by YeQing on 2020/12/23.
//  Copyright © 2020 mengdong. All rights reserved.
//  lock  test

import Foundation

public class ZHLockTest {
    
    //MARK: - property
    private lazy var serialQueue:DispatchQueue = {
        return DispatchQueue(label: "test.serial.queue", qos: .default, attributes: DispatchQueue.Attributes.init(rawValue: 0), autoreleaseFrequency: .inherit, target: nil)
    }()
    private var unfairlock:os_unfair_lock_t?
    private var semaphore:DispatchSemaphore?
    private var mutex:pthread_mutex_t?
    private var lock:NSLock?
    private var condition:NSCondition?
    private var conditionLock:NSConditionLock?
    private var recursiveLock:NSRecursiveLock?
    private var rwlock:pthread_rwlock_t?
    
    //MARK: - OSSpinLock
    private var spinlock:OSSpinLock?
    public func test_spinlock() {
        NSLog("start")
        spinlock = OSSpinLock()
        //thread1
        DispatchQueue.global(qos: .default).async {
            NSLog("1-1:"+Thread.current.description);
            OSSpinLockLock(&(self.spinlock!))
            NSLog("1-2:"+Thread.current.description);
            sleep(3)
            OSSpinLockUnlock(&(self.spinlock!))
            NSLog("1-3:"+Thread.current.description);
        }
        //thread2
        DispatchQueue.global(qos: .default).async {
            NSLog("2-1:"+Thread.current.description);
            OSSpinLockLock(&(self.spinlock!))
            NSLog("2-2:"+Thread.current.description);
            sleep(3)
            OSSpinLockUnlock(&(self.spinlock!))
            NSLog("2-3:"+Thread.current.description);
        }
        //thread3
        DispatchQueue.global(qos: .default).async {
            NSLog("3-1:"+Thread.current.description);
            if (OSSpinLockTry(&(self.spinlock!))) {
                NSLog("3-2:"+Thread.current.description);
                sleep(3)
                OSSpinLockUnlock(&(self.spinlock!))
            }
            NSLog("3-3:"+Thread.current.description);
        }
        NSLog("end")
    }
        
    //MARK: - os_unfair_lock
    public func test_unfair_lock() {
        NSLog("start")
        unfairlock = .allocate(capacity: 1)
        unfairlock?.initialize(to: os_unfair_lock())
        for i in 1...2 {
            DispatchQueue.global(qos: .default).async {
                os_unfair_lock_lock(self.unfairlock!)
                sleep(2)
                NSLog("\(i):"+Thread.current.description);
                os_unfair_lock_unlock(self.unfairlock!)
            }
        }
        //trylock
        DispatchQueue.global(qos: .default).async {
            if (os_unfair_lock_trylock(self.unfairlock!)) {
                sleep(2)
                NSLog("3:"+Thread.current.description);
                os_unfair_lock_unlock(self.unfairlock!)
            }
        }
        NSLog("end")
    }
        
    //MARK: - Semaphore
    public func test_semaphore() {
        NSLog("start")
        semaphore = DispatchSemaphore(value: 2)
        for i in 1...4 {
            DispatchQueue.global(qos: .default).async {
                self.semaphore?.wait()
                sleep(2)
                NSLog("\(i):"+Thread.current.description);
                self.semaphore?.signal()
            }
        }
        NSLog("end")
    }

    //MARK: - serial queue
    public func test_serial_queue() {
        NSLog("start")
        for i in 1...4 {
            DispatchQueue.global(qos: .default).async {
                self.serialQueue.async {
                    sleep(2)
                    NSLog("\(i):"+Thread.current.description);
                }
            }
        }
        NSLog("end")
    }
        
    //MARK: - pthread_mutex
    public func test_pthread_mutex() {
        NSLog("start")
        mutex = pthread_mutex_t()
        pthread_mutex_init(&(self.mutex!), nil)
        for i in 1...2 {
            DispatchQueue.global(qos: .default).async {
                pthread_mutex_lock(&(self.mutex!))
                sleep(2)
                NSLog("\(i):"+Thread.current.description);
                pthread_mutex_unlock(&(self.mutex!))
            }
        }
        DispatchQueue.global(qos: .default).async {
            let retCode = pthread_mutex_trylock(&(self.mutex!))
            if( retCode == 0) {
                sleep(2)
                NSLog("3:"+Thread.current.description);
                pthread_mutex_unlock(&(self.mutex!))
            }
            NSLog("3-1:"+Thread.current.description);
        }
        NSLog("end")
    }
       
    //MARK: - pthread_mutex_recursive
    public func test_pthread_mutex_recursive() {
        NSLog("start")
        mutex = pthread_mutex_t()
        var attr = pthread_mutexattr_t()
        pthread_mutexattr_init(&attr)
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE)
        pthread_mutex_init(&(self.mutex!), &attr)
        for i in 1...2 {
            DispatchQueue.global(qos: .default).async {
                pthread_mutex_lock(&(self.mutex!))
                sleep(2)
                NSLog("\(i):"+Thread.current.description);
                pthread_mutex_unlock(&(self.mutex!))
            }
        }
        //trylock
        DispatchQueue.global(qos: .default).async {
            let retCode = pthread_mutex_trylock(&(self.mutex!))
            if( retCode == 0) {
                sleep(2)
                NSLog("3:"+Thread.current.description);
                pthread_mutex_unlock(&(self.mutex!))
            }
            NSLog("3-1:"+Thread.current.description);
        }
        NSLog("end")
    }
        
    //MARK: - NSLock
    public func test_lock() {
        NSLog("start")
        self.lock = NSLock()
        for i in 1...5 {
            DispatchQueue.global(qos: .default).async {
                self.lock?.lock(before: Date().advanced(by: 100))
                sleep(5)
                NSLog("\(i):"+Thread.current.description);
                self.lock?.unlock()
            }
        }
        NSLog("end")
    }
        
    //MARK: - NSCondition
    var i = 0;
    public func test_condition() {
        NSLog("start")
        self.condition = NSCondition()
        DispatchQueue.global(qos: .default).async {
            self.condition?.lock()
            while(self.i == 0) {
                self.condition?.wait()
            }
            NSLog("1:"+Thread.current.description);
            self.condition?.unlock()
        }
        DispatchQueue.global(qos: .default).async {
            self.condition?.lock()
            while(self.i == 0) {
                self.condition?.wait()
            }
            NSLog("2:"+Thread.current.description);
            self.condition?.unlock()
        }
        DispatchQueue.global(qos: .default).async {
            self.condition?.lock()
            sleep(3)
            self.i += 1
            self.condition?.signal()
    //            self.condition?.broadcast()
            NSLog("3:"+Thread.current.description);
            self.condition?.unlock()
        }
        NSLog("end")
    }

    //MARK: - NSConditionLock
    public func test_conditionlock() {
        NSLog("start")
        //初始化锁，设置 cond = 3
        self.conditionLock = NSConditionLock(condition: 3)
        DispatchQueue.global(qos: .default).async {
            //获取锁，等待 cond == 1
            self.conditionLock?.lock(whenCondition: 1)
            NSLog("1:"+Thread.current.description);
            self.conditionLock?.unlock(withCondition: 2)
        }
        DispatchQueue.global(qos: .default).async {
            //获取锁，等待 cond == 4，最多等待10秒
            self.conditionLock?.lock(whenCondition: 4, before: Date().advanced(by: 15))
            NSLog("2:"+Thread.current.description);
            self.conditionLock?.unlock(withCondition: 2)
        }
        DispatchQueue.global(qos: .default).async {
            //获取锁，等待 cond == 3
            self.conditionLock?.lock(whenCondition:3)
            sleep(5)
            NSLog("3:"+Thread.current.description);
            self.conditionLock?.unlock(withCondition: 1)
        }
        NSLog("end")
    }

    //MARK: - NSRecursiveLock
    public func test_recursivelock() {
        NSLog("start")
        self.recursiveLock = NSRecursiveLock()
        DispatchQueue.global(qos: .default).async {
            self.recursiveLock?.lock()
            sleep(3)
            self.recursiveLock?.lock()
            NSLog("1:"+Thread.current.description);
            self.recursiveLock?.unlock()
            self.recursiveLock?.unlock()
        }
        DispatchQueue.global(qos: .default).async {
            self.recursiveLock?.lock()
            sleep(3)
            NSLog("2:"+Thread.current.description);
            self.recursiveLock?.unlock()
        }
        NSLog("end")
    }

    //MARK: - objc_sync
    var syncObj:NSObject = NSObject()
    public func test_object_sync() {
        NSLog("start")
        NSLog("a:\(CFGetRetainCount(self.syncObj))")
        DispatchQueue.global(qos: .default).async {
            objc_sync_enter(self.syncObj)
            sleep(3)
            NSLog("1:"+Thread.current.description)
            objc_sync_exit(self.syncObj)
        }
        DispatchQueue.global(qos: .default).async {
            objc_sync_enter(self.syncObj)
            sleep(3)
            NSLog("2:"+Thread.current.description)
            objc_sync_exit(self.syncObj)
        }
        NSLog("end")
    }

    //MARK: - pthread_rwlock_t
    public func test_pthread_rwlock() {
        NSLog("start")
        self.rwlock = pthread_rwlock_t()
        pthread_rwlock_init(&(self.rwlock!), nil)
        DispatchQueue.global(qos: .default).async {
            pthread_rwlock_rdlock(&(self.rwlock!))
            sleep(3)
            NSLog("read1:"+Thread.current.description)
            pthread_rwlock_unlock(&(self.rwlock!))
        }
        DispatchQueue.global(qos: .default).async {
            pthread_rwlock_rdlock(&(self.rwlock!))
            sleep(3)
            NSLog("read2:"+Thread.current.description)
            pthread_rwlock_unlock(&(self.rwlock!))
        }
        DispatchQueue.global(qos: .default).async {
            pthread_rwlock_wrlock(&(self.rwlock!))
            sleep(3)
            NSLog("write1:"+Thread.current.description)
            pthread_rwlock_unlock(&(self.rwlock!))
        }
        DispatchQueue.global(qos: .default).async {
            pthread_rwlock_wrlock(&(self.rwlock!))
            sleep(3)
            NSLog("write2:"+Thread.current.description)
            pthread_rwlock_unlock(&(self.rwlock!))
        }
        DispatchQueue.global(qos: .default).async {
            pthread_rwlock_rdlock(&(self.rwlock!))
            sleep(3)
            NSLog("read3:"+Thread.current.description)
            pthread_rwlock_unlock(&(self.rwlock!))
        }
        DispatchQueue.global(qos: .default).async {
            pthread_rwlock_wrlock(&(self.rwlock!))
            sleep(3)
            NSLog("write3:"+Thread.current.description)
            pthread_rwlock_unlock(&(self.rwlock!))
        }
        NSLog("end")
    }
    
    //MARK: - 锁性能对比
    /// 性能测试
    public func testPerformance() {
        let looppCount:Int = 100000
        var begin:TimeInterval = 0
        var end:TimeInterval = 0
        //spinlock
        begin = CFAbsoluteTimeGetCurrent()
        spinlock = OSSpinLock()
        for _ in 1...looppCount {
            OSSpinLockLock(&(self.spinlock!))
            OSSpinLockUnlock(&(self.spinlock!))
        }
        end = CFAbsoluteTimeGetCurrent()
        NSLog("spinlock:\((end-begin)*1000)")
        //dispatch_semaphore
        begin = CFAbsoluteTimeGetCurrent()
        semaphore = DispatchSemaphore(value: 1)
        for _ in 1...looppCount {
            self.semaphore?.wait()
            self.semaphore?.signal()
        }
        end = CFAbsoluteTimeGetCurrent()
        NSLog("semaphore:\((end-begin)*1000)")
        //os_unfair_lock
        begin = CFAbsoluteTimeGetCurrent()
        unfairlock = .allocate(capacity: 1)
        unfairlock?.initialize(to: os_unfair_lock())
        for _ in 1...looppCount {
            os_unfair_lock_lock(self.unfairlock!)
            os_unfair_lock_unlock(self.unfairlock!)
        }
        end = CFAbsoluteTimeGetCurrent()
        NSLog("unfair_lock:\((end-begin)*1000)")
        //pthread_mutex
        begin = CFAbsoluteTimeGetCurrent()
        mutex = pthread_mutex_t()
        pthread_mutex_init(&(self.mutex!), nil)
        for _ in 1...looppCount {
            pthread_mutex_lock(&(self.mutex!))
            pthread_mutex_unlock(&(self.mutex!))
        }
        end = CFAbsoluteTimeGetCurrent()
        NSLog("pthread_mutex:\((end-begin)*1000)")
        //NSLock
        begin = CFAbsoluteTimeGetCurrent()
        self.lock = NSLock()
        for _ in 1...looppCount {
            self.lock?.lock()
            self.lock?.unlock()
        }
        end = CFAbsoluteTimeGetCurrent()
        NSLog("nslock:\((end-begin)*1000)")
        //NSCondiation
        begin = CFAbsoluteTimeGetCurrent()
        self.condition = NSCondition()
        for _ in 1...looppCount {
            self.condition?.lock()
            self.condition?.unlock()
        }
        end = CFAbsoluteTimeGetCurrent()
        NSLog("condition:\((end-begin)*1000)")
        //NSCondiationLock
        begin = CFAbsoluteTimeGetCurrent()
        self.conditionLock = NSConditionLock(condition: 1)
        for _ in 1...looppCount {
            self.conditionLock?.lock(whenCondition:1)
            self.conditionLock?.unlock(withCondition: 1)
        }
        end = CFAbsoluteTimeGetCurrent()
        NSLog("conditionlock:\((end-begin)*1000)")
        //NSRecursiveLock
        begin = CFAbsoluteTimeGetCurrent()
        self.recursiveLock = NSRecursiveLock()
        for _ in 1...looppCount {
            self.recursiveLock?.lock()
            self.recursiveLock?.unlock()
        }
        end = CFAbsoluteTimeGetCurrent()
        NSLog("recursiveLock:\((end-begin)*1000)")
        //object_sync
        begin = CFAbsoluteTimeGetCurrent()
        let syncObj:NSObject = NSObject()
        for _ in 1...looppCount {
            objc_sync_enter(syncObj)
            objc_sync_exit(syncObj)
        }
        end = CFAbsoluteTimeGetCurrent()
        NSLog("object_sync:\((end-begin)*1000)")
        //pthread_rwlock_t
        begin = CFAbsoluteTimeGetCurrent()
        self.rwlock = pthread_rwlock_t()
        pthread_rwlock_init(&(self.rwlock!), nil)
        for _ in 1...looppCount {
            pthread_rwlock_rdlock(&(self.rwlock!))
            pthread_rwlock_unlock(&(self.rwlock!))
        }
        end = CFAbsoluteTimeGetCurrent()
        NSLog("pthread_rwlock_t:\((end-begin)*1000)")
        //dispatch sync
        begin = CFAbsoluteTimeGetCurrent()
        let serialQueue = DispatchQueue(label: "test")
        for _ in 1...looppCount {
            serialQueue.sync {
                
            }
        }
        end = CFAbsoluteTimeGetCurrent()
        NSLog("serial queue sync:\((end-begin)*1000)")
    }
}
