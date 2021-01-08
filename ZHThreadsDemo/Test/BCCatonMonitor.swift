//
//  BCCatonMonitor.swift
//  ZHThreadsDemo
//
//  Created by YeQing on 2021/1/7.
//  Copyright © 2021 mengdong. All rights reserved.
//  卡顿监控服务


/// 单次卡顿时长，毫秒
private let BCCatonSingleDuration:Int = 50

public class BCCatonMonitor {
    
    //MARK: - property
    /// 单例对象
    public static let shared:BCCatonMonitor = BCCatonMonitor()
    /// 状态 observer
    private var observer:CFRunLoopObserver?
    /// runloop 的当前活动状态
    private var currentActivity:CFRunLoopActivity?
    /// 锁
    private var lock:DispatchSemaphore?
    /// 检测耗时的队列
    private var queue:DispatchQueue?
    /// 连续卡顿次数
    private var cartonCount:Int = 0

    //MARK: - life cycle
    
    //MARK: - 开始监控
    /// 开始监控
    public func start() {
        if self.observer != nil {
            // 已经运行了
            return
        }
        var observerContext = CFRunLoopObserverContext(version: 0, info:unsafeBitCast(self, to: UnsafeMutableRawPointer.self), retain: nil, release: nil, copyDescription: nil)
        let tmpObserver = CFRunLoopObserverCreate(kCFAllocatorDefault, CFRunLoopActivity.allActivities.rawValue, true, 0, { (observer, activity, info) in
            BCCatonMonitor.observerCallBack(observer, activity, info)
        }, &observerContext)
        self.observer = tmpObserver
        CFRunLoopAddObserver(CFRunLoopGetMain(), tmpObserver, CFRunLoopMode.commonModes)
        self.lock = DispatchSemaphore(value: 0)
        self.queue = DispatchQueue(label: "com.zhihan.cartonmonitor", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        self.queue?.async { [weak self] in
            guard let self_ = self else {
                return
            }
            while (true) {
                // 假定连续5次超时50ms认为卡顿(当然也包含了单次超时250ms)
                //wait,如果信号量>0, 信号量 -1
                let result = self_.lock?.wait(timeout: DispatchTime.now() + .milliseconds(BCCatonSingleDuration))
                if result != DispatchTimeoutResult.success {
                    //kCFRunLoopBeforeSources 之后是处理 source0 和s ource1
                    //kCFRunLoopAfterWaiting 是处理 timer、main queue dispatch(async、timer) 、mach port 等等事件
                    if self_.currentActivity == CFRunLoopActivity.beforeSources || self_.currentActivity == CFRunLoopActivity.afterWaiting {
                        self_.cartonCount = self_.cartonCount + 1
                        if self_.cartonCount < 5 {
                            continue
                        }
                        //连续5次50ms的卡顿
                        #if DEBUG
                        NSLog("[apm] carton")
                        #endif
                    }
                }
                self_.cartonCount = 0
            }
        }
    }
    /// 停止监控
    public func stop() {
        guard let observer_ = self.observer else {
            // 已经停止运行了
            return
        }
        CFRunLoopRemoveObserver(CFRunLoopGetMain(), observer_, CFRunLoopMode.commonModes)
        self.observer = nil
        self.lock = nil
        self.queue = nil
    }
    
    //MARK: - 活动状态回调
    /// runloop 活动状态变更回调
    static func observerCallBack(_ observer:CFRunLoopObserver?, _ activity:CFRunLoopActivity, _ info:UnsafeMutableRawPointer?) -> Void {
//        NSLog("%d", activity.rawValue)
        let monitor = unsafeBitCast(info, to: BCCatonMonitor.self)
        monitor.currentActivity = activity
        monitor.lock?.signal()
    }
}
