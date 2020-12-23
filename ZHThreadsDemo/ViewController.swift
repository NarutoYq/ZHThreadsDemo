//
//  ViewController.swift
//  test
//
//  Created by YeQing on 2020/7/17.
//  Copyright © 2020 laoqingcai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private lazy var test:ZHThreadTest = ZHThreadTest()
    private lazy var runtimeTest:ZHObjcRuntimeTest = ZHObjcRuntimeTest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    static var timer:Timer?
    @IBAction func lockPerformanceAction(_ sender: Any) {
//        runtimeTest.test()
//        ZHMutableArrayTest.testCircle()
//        sortTest()
        let lockTest = ZHLockTest()
        lockTest.testPerformance()
    }

}



