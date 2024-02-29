//
//  TermsAndConditionsVC.swift
//  Buraq24
//
//  Created by MANINDER on 25/09/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import WebKit


class TermsAndConditionsVC: BaseVCCab , WKNavigationDelegate  {
    
    //MARK:- Outlets
    @IBOutlet weak var webView: WKWebView!
    
    
    
    //MARK:- Properties
    var strWebLink : String?
    var strNavTitle : String?
    
    //MARK:- View life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadRequest()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- Functions
    func loadRequest() {
        if let strURL =  strWebLink , let strTitle =  strNavTitle {
            super.updateTitle(strTitle: strTitle)
            guard let url = URL(string : strURL) else{ return }
            webView.navigationDelegate = self
            webView.load(URLRequest(url: url))
        }
    }
    

//MARK:- WebView Delegates

    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        startAnimating( message: nil, messageFont: nil, type: .lineScalePulseOutRapid , color: UIColor.white , padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil)
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
         stopAnimating()
    }
  
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        stopAnimating()
    }
    
    
    
}
