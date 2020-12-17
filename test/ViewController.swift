//
//  ViewController.swift
//  test
//
//  Created by YeQing on 2020/7/17.
//  Copyright © 2020 laoqingcai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private lazy var test:ThreadTest = ThreadTest()
    private lazy var octest:OCTest = OCTest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    static var timer:Timer?
    @IBAction func lockPerformanceAction(_ sender: Any) {
        self.octest.test()
//        ZHMutableArrayTest.testCircle()
        sortTest()
    }

}



