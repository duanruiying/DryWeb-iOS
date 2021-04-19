//
//  DryWebView.swift
//  DryWeb-iOS
//
//  Created by Ruiying Duan on 2019/9/1.
//

import UIKit
import WebKit

//MARK: - DryWebView
public class DryWebView: UIView {
    
    /// WKWebView
    public var webView: WKWebView!
    /// 进度条
    public var progressView: UIProgressView!
    /// 标题
    public var title: String = ""
    
    /// 构造
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.webViewInit()
        self.progressViewInit()
        self.addKVO()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.webViewInit()
        self.progressViewInit()
        self.addKVO()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.webViewInit()
        self.progressViewInit()
        self.addKVO()
    }
    
    /// 析构
    deinit {
        
        /// 释放代理
        self.webView.navigationDelegate = nil
        self.webView.uiDelegate = nil
        
        /// 移除KVO
        self.removeKVO()
    }
}

//MARK: - 初始化
extension DryWebView {
    
    /// WKWebView
    func webViewInit() {
        
        /// WKWebView配置
        let config: WKWebViewConfiguration = WKWebViewConfiguration()
        config.preferences.javaScriptEnabled = true
        config.preferences.javaScriptCanOpenWindowsAutomatically = false
        config.processPool = WKProcessPool()
        
        /// 添加WKWebView
        self.webView = WKWebView.init(frame: self.bounds, configuration: config)
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.webView!)
        self.addConstraint(NSLayoutConstraint.init(item: self, attribute: .top, relatedBy: .equal, toItem: self.webView, attribute: .top, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint.init(item: self, attribute: .bottom, relatedBy: .equal, toItem: self.webView, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint.init(item: self, attribute: .left, relatedBy: .equal, toItem: self.webView, attribute: .left, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint.init(item: self, attribute: .right, relatedBy: .equal, toItem: self.webView, attribute: .right, multiplier: 1.0, constant: 0.0))
    }
    
    /// 进度条
    func progressViewInit() {
        
        self.progressView = UIProgressView()
        self.progressView.progressViewStyle = .bar
        self.progressView.translatesAutoresizingMaskIntoConstraints = false
        self.progressView.tintColor = .blue
        self.addSubview(self.progressView)
        self.addConstraint(NSLayoutConstraint.init(item: self, attribute: .top, relatedBy: .equal, toItem: self.progressView, attribute: .top, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint.init(item: self, attribute: .left, relatedBy: .equal, toItem: self.progressView, attribute: .left, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint.init(item: self, attribute: .right, relatedBy: .equal, toItem: self.progressView, attribute: .right, multiplier: 1.0, constant: 0.0))
        self.progressView.addConstraint(NSLayoutConstraint.init(item: self.progressView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 1.0))
    }
}

//MARK: - KVO
extension DryWebView {
    
    /// Add KVO
    func addKVO() {
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
    }
    
    /// Remove KVO
    func removeKVO() {
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
        self.webView.removeObserver(self, forKeyPath: "title")
    }
    
    /// KVO
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let path = keyPath else {
            return
        }
        
        switch path {
        case "estimatedProgress":
            
            /// 获取进度值
            guard let progress = change?[NSKeyValueChangeKey.newKey] as? NSNumber else {
                return
            }
            
            /// 设置进度
            self.progressView.progress = Float(progress.floatValue)
            if self.progressView.progress == 1 {
                self.progressView.alpha = 0
                self.progressView.progress = 0
            } else if self.progressView.alpha == 0 {
                self.progressView.alpha = 1
            }
            
        case "title":
            
            /// 获取标题
            if let title = self.webView.title {
                self.title = title
            }
            
        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}

//MARK: - WKNavigationDelegate
extension DryWebView: WKNavigationDelegate {
    
    /// 准备加载
    open func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("准备加载")
    }
    
    /// 开始加载(过渡动画可在此方法中加载)
    open func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("开始加载")
    }
    
    /// 完成加载
    open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("完成加载")
    }
    
    /// 加载失败
    open func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
        print("加载失败")
        
        /// 判断是否用户取消加载
        if error._code == NSURLErrorCancelled {
            return
        }
    }
    
    /// 收到服务器重定向请求
    open func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    /// 在请求开始加载之前，决定是否跳转
    open func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    /// 在收到响应开始加载后，决定是否跳转
    open func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
}

//MARK: - WKUIDelegate
extension DryWebView: WKUIDelegate {
    
}

//MARK: - OpenAPI
extension DryWebView {
    
    /// 设置进度条颜色
    public func setProgressColor(_ color: UIColor) {
        self.progressView.tintColor = color
    }
    
    /// 加载URL
    public func loadUrlString(_ urlString: String, timeoutInterval: TimeInterval = 30) {
        
        guard let url = URL.init(string: urlString) else {
            return
        }
        
        let request: URLRequest = URLRequest.init(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: timeoutInterval)
        self.webView.load(request)
    }
    
    /// 刷新
    public func refresh() {
        self.webView.reload()
    }
    
    /// 上一步
    public func goBack() {
        
        if self.webView.canGoBack {
            self.webView.goBack()
        }
    }
    
    /// 下一步
    public func goForward() {
        
        if self.webView.canGoForward {
            self.webView.goForward()
        }
    }
    
    /// 停止加载
    public func stopLoading() {
        
        if self.webView.isLoading {
            self.webView.stopLoading()
        }
    }
}
