//
//  TermsAndConditionsController.swift
//  Clikat
//
//  Created by cblmacmini on 7/20/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
//enum AppInfo : String{
//    case TermsAndConditions = "http://35.155.155.254:3000/term"
//    case AboutUs = "http://35.155.155.254:3000/privacy"
//
//    func url() -> URL?{
//
//        return URL(string:"http://www.code-brew.com/")//self.rawValue)
//    }
//}

class TermsAndConditionsController: BaseViewController,WKNavigationDelegate {

    //MARK:- IBOutlet
    @IBOutlet weak var back_button: ThemeButton!{
        didSet {//Nitin
            back_button.isHidden = /*SKAppType.type == .gym ||*/ SKAppType.type == .food || SKAppType.type == .home || SKAppType.type == .carRental || SKAppType.type == .eCom ? false : true
            back_button.imageView?.mirrorTransform()
        }
    }
    @IBOutlet weak var menu_button: ThemeButton!{
        didSet {//Nitin
            menu_button.isHidden = /*SKAppType.type == .gym ||*/ SKAppType.type == .food || SKAppType.type == .home || SKAppType.type == .carRental || SKAppType.type == .eCom ? true : false
        }
    }
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var webview: WKWebView! {
        didSet{
            webview.navigationDelegate = self
        }
    }
    
    //MARK:- VAriables
    var htmlStr = "No data found"
    var titleStr: String = ""
    var urlStr: String = ""

    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        labelTitle.text = titleStr
        //guard let url = type.url() else { return }
        APIManager.sharedInstance.showLoader()

        if !urlStr.isEmpty {
            if let url = URL(string: urlStr) {
                let requestObj = URLRequest(url: url)
                webview.load(requestObj)
            }
        }
        else {
            webview.loadHTMLString(htmlStr, baseURL: nil)
        }
        webview.allowsBackForwardNavigationGestures = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back_buttonAction(_ sender: Any) {
        popVC()
    }
   
    @IBAction func actionMenu(sender: UIButton) {
        toggleSideMenuView()
    }
    
    //MARK:- WKNavigationDelegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        APIManager.sharedInstance.hideLoader()
    }
}
