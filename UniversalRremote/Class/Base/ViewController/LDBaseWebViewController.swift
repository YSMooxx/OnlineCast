//
//  LDLDBaseWebViewController.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/7.
//

import UIKit
import WebKit

class LDBaseWebViewController:LDBaseViewController {
    
    lazy var funcNameArray:[String] = []
    
    lazy var webView: WKWebView = {
        
        let webConfiguration = WKWebViewConfiguration()
        
        webConfiguration.applicationNameForUserAgent = "iOS"
        
        let webView1:WKWebView = WKWebView(frame:CGRect(x: 0, y: navHeight, width: ScreenW, height: ScreenH - navHeight),configuration: webConfiguration)
        webView1.scrollView.showsVerticalScrollIndicator = false
        webView1.scrollView.showsHorizontalScrollIndicator = false
        webView1.allowsLinkPreview = false
        webView1.scrollView.backgroundColor = .white
        webView1.allowsBackForwardNavigationGestures = true
        webView1.backgroundColor = .white
        webView1.uiDelegate = self
        webView1.navigationDelegate = self
        webView1.scrollView.delegate = self
        if #available(iOS 11.0, *) {
            
            webView1.scrollView.contentInsetAdjustmentBehavior = .never
        }
        
        for name in funcNameArray {
            
            webView1.configuration.userContentController.add(self, name: name)
        }
        
       return webView1
    }()
    
    lazy var activityView:UIActivityIndicatorView = {
       
        let activityView = UIActivityIndicatorView()
        activityView.width = 24.RW()
        activityView.height = 24.RW()
        activityView.centerX = view.width / 2
        activityView.centerY = (view.height - navHeight) / 2
        activityView.color = .black
        activityView.hidesWhenStopped = true
        
        let  transform:CGAffineTransform  = CGAffineTransformMakeScale(24.RW() / 20,24.RW() / 20);
        activityView.transform = transform;
        
        
        
        activityView.startAnimating()
        
        return activityView
    }()
    
    func LoadWithUrl(url:String) {
        
        if url.count == 0 {
            
            return
        }
        
        let newUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        guard let URL1 = URL(string:newUrl) else { return }
        
        let request = URLRequest(url: URL1)
        
        webView.load(request)
    }
    
    override func addViews() {
        
        super.addViews()
        
        view.addSubview(webView)
        view.addSubview(activityView)
    }
}

extension LDBaseWebViewController:WKUIDelegate,WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        activityView.stopAnimating()
        webView.evaluateJavaScript("document.documentElement.style.webkitUserSelect='none';") { any1, error1 in}
        webView.evaluateJavaScript("document.documentElement.style.webkitTouchCallout='none';", completionHandler: nil)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
        activityView.stopAnimating()
        Print("网页加载失败：\(error.localizedDescription)")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
        activityView.stopAnimating()
        Print("网页加载失败：\(error.localizedDescription)")
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    
}

extension LDBaseWebViewController:WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        
    }
}

extension LDBaseWebViewController:UIScrollViewDelegate {
    
    
}

