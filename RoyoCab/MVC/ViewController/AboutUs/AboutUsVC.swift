//
//  AboutUsVC.swift
//  Buraq24
//
//  Created by MANINDER on 22/09/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit

class AboutUsVC: BaseVCCab {
    
    //MARK:- Outlets
    @IBOutlet var lblVersion: UILabel!
    
    //MARK:- View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getAppVersion()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- Functions
    func getAppVersion() {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            lblVersion.text = "version".localizedString + " " +  version
        }
    }
    
}
