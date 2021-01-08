//
//  ViewController.swift
//  test
//
//  Created by YeQing on 2020/7/17.
//  Copyright © 2020 laoqingcai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: - property
    private var testView:ZHTestView {
        if let view = _testView { return view }
        let view = ZHTestView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        view.backgroundColor = .yellow
        view.center = self.view.center
        self.view.addSubview(view)
        _testView = view
        return view
    }
    private var _testView:ZHTestView?
    
    private lazy var test:ZHThreadTest = ZHThreadTest()
    private lazy var runtimeTest:ZHObjcRuntimeTest = ZHObjcRuntimeTest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func lockPerformanceAction(_ sender: Any) {
//        let lockTest = ZHLockTest()
//        lockTest.testPerformance()
        
//        let threadTest = ZHThreadTest()
//        threadTest.run()
        
//        runtimeTest.test()
//        ZHMutableArrayTest.testCircle()
//        sortTest()
        NSLog("abcd")
        self.testView.setNeedsDisplay()
//        self.testView.layoutIfNeeded()
    }

}



