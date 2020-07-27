//
//  ViewController.swift
//  test
//
//  Created by YeQing on 2020/7/17.
//  Copyright © 2020 laoqingcai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var test:ThreadTest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.test = ThreadTest()
        self.test?.run()
    }


    
    

}

