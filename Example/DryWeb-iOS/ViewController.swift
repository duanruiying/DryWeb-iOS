//
//  ViewController.swift
//  DryWeb-iOS
//
//  Created by duanruiying on 09/01/2019.
//  Copyright (c) 2019 duanruiying. All rights reserved.
//

import UIKit
import DryWeb_iOS

class ViewController: UIViewController {
    
    var webView: DryWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView = DryWebView.init(frame: self.view.bounds)
        self.webView.setProgressColor(.red)
        self.view.addSubview(self.webView)
        self.webView.loadUrlString("https://www.baidu.com/", timeoutInterval: 10)
    }
}
