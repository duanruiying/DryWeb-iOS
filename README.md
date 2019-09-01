# DryWeb-iOS
iOS: web常用封装

## Prerequisites
* iOS 10.0+
* Swift 5.0+

## Installation
* pod 'DryWeb-iOS'

## Features
```
self.webView = DryWebView.init(frame: self.view.bounds)
self.webView.setProgressColor(.red)
self.view.addSubview(self.webView)
self.webView.loadUrlString("https://www.baidu.com/")
```
