//
//  WebViewController.swift
//  Course4Task1
//

//

import UIKit
import WebKit
import SafariServices

//Sets and runs WebView for repositories
class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var webView: WKWebView!
    var repositoryUrl = URL(string: "")
    
    override func loadView() {
        let scriptSource = "document.body.style.backgroundColor = \"#2E8B57\";"
        let script = WKUserScript(source: scriptSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        
        let contentController = WKUserContentController()
        contentController.addUserScript(script)
        
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.userContentController = contentController
        
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        view = webView
        webView.reload
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = repositoryUrl else { return }
        let request = URLRequest(url: url)
        webView.load(request)
        webView.allowsBackForwardNavigationGestures = true
    }
    
}
