//
//  PaymentWebviewVC.swift
//  Sneni
//
//  Created by Ankit Chhabra on 25/05/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit
import WebKit
import EZSwiftExtensions

class PaymentWebviewVC: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    //MARK: Properties

    var urlStr = String()
    var finalUrl = String()
    var gatewayUniqueId = String()
    
    var paymentSucccessBlock:((_ token:String ) -> ())?

    //MARK: Outlets
    @IBOutlet weak var webKit: WKWebView!
    
    @IBOutlet weak var btnBack: ThemeButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        HTTPCookieStorage.shared.cookieAcceptPolicy = .always
        let url: URL! = URL(string: urlStr)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpShouldHandleCookies = true
        
        
        webKit.navigationDelegate = self
        
        APIManager.sharedInstance.showLoader()
        webKit.load(urlRequest)
        
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        APIManager.sharedInstance.hideLoader()
        finalUrl = /webKit.url?.absoluteString
        print(finalUrl)
        if let text = webKit.url?.absoluteString {
            if text.range(of: "success") != nil {
                SKToast.makeToast("Payment Successful")
                btnBack.isUserInteractionEnabled = false
                ez.runThisAfterDelay(seconds: 1.0) {
                    if self.gatewayUniqueId == "sadded" {
                        self.paymentSucccessBlock?("")
                    }else {
                        let txnId = self.webKit.url?.getParam(queryParam: "paymentId")
                        self.paymentSucccessBlock?(/txnId)
                    }
                }
            } else if text.range(of: "failure") != nil || text.range(of: "error") != nil {
                SKToast.makeToast("Payment Failure")

//                alertBox(message: "Payment_Failure".localized, title: "Failure") {
//                    self.dismissVC()
//                }
            }
        }
    }
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let response = navigationResponse.response as? HTTPURLResponse,
            let url = navigationResponse.response.url else {
                decisionHandler(.cancel)
                return
        }
        
        if let headerFields = response.allHeaderFields as? [String: String] {
            let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: url)
            cookies.forEach { cookie in
                webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
            }
        }
        
        decisionHandler(.allow)
    }
    
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        APIManager.sharedInstance.hideLoader()
        self.popVC()
//        self.dismissVC()
    }
    
    private func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        APIManager.sharedInstance.hideLoader()
        SKToast.makeToast(error.description)

        //handleError(error: error)
    }
    
    private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        APIManager.sharedInstance.hideLoader()
        SKToast.makeToast(error.description)

        //handleError(error: error)
    }
    

    func handleError(error: NSError) {
        if let failingUrl = error.userInfo["NSErrorFailingURLStringKey"] as? String {
            if let url = NSURL(string: failingUrl) {
                //let didOpen = UIApplication.sharedApplication().openURL(url)
                //                if didOpen {
                //                    print("openURL succeeded")
                //                    return
                //                }
            }
        }
    }
    
}



extension WKWebView {
    class func clean() {
        guard #available(iOS 9.0, *) else {return}
        
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                #if DEBUG
                print("WKWebsiteDataStore record deleted:", record)
                #endif
            }
        }
    }
}



extension URL {
    func getParam(queryParam:String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParam })?.value
    }
}
