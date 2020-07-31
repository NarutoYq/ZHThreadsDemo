//
//  ViewController.swift
//  test
//
//  Created by YeQing on 2020/7/17.
//  Copyright © 2020 laoqingcai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private lazy var test:ThreadTest = {
        return ThreadTest()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func lockPerformanceAction(_ sender: Any) {
//        self.test.testLockPerformance()
        
        self.test.test_serial_queue()
    }
    

}

