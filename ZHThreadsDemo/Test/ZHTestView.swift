//
//  ZHTestView.swift
//  ZHThreadsDemo
//
//  Created by YeQing on 2020/12/30.
//  Copyright © 2020 mengdong. All rights reserved.
//  测试 view

import UIKit

public class ZHTestView: UIView {

    public override func layoutSubviews() {
        NSLog("ZHTestView layoutSubviews");
    }
    
    public override func draw(_ rect: CGRect) {
        NSLog("ZHTestView draw");
    }
}
