//
//  BaseVCCab.swift
//  Buraq24
//
//  Created by MANINDER on 29/08/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//
public protocol ControllerSetup:class {
    func initialSetup()
    func setupUI()
}

import UIKit

class BaseVCCab: UIViewController {
    
    //MARK:- Outlet
    @IBOutlet weak var btnNextAccessoryView: UIButton!
    @IBOutlet var btnBack: UIButton?
    @IBOutlet var lblTitle: UILabel?

    @IBOutlet weak var viewBaseNavigation: UIView?
    @IBOutlet weak var viewStatusBar: UIView?
    
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imgBack = R.image.ic_back_arrow_black()
        
        let template = AppTemplate(rawValue: (UDSingleton.shared.appSettings?.appSettings?.app_template?.toInt() ?? 0) )
        switch template {
        case .Moby?:
            //btnBack?.setImage(R.image.back(), for: .normal)
            btnBack?.setButtonWithTintColorHeaderText()
            
        case .DeliverSome?:
            //btnBack?.setImage(R.image.back(), for: .normal)
            btnBack?.setButtonWithTintColorHeaderText()
            lblTitle?.text = "My Deliveries"
            
        case .GoMove?:
            //btnBack?.setImage(R.image.ic_back_arrow_white(), for: .normal)
            btnBack?.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            lblTitle?.text = "Edit Profile"
            
        default:
            btnBack?.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            //btnBack?.setImage(imgBack?.setLocalizedImage(), for: .normal)
        }
        
        lblTitle?.setTextColorHeaderText()
        viewBaseNavigation?.setViewBackgroundColorHeader()
        viewStatusBar?.setViewBackgroundColorHeader()
    }

        override var preferredStatusBarStyle: UIStatusBarStyle {
            
            let template = AppTemplate(rawValue: (UDSingleton.shared.appSettings?.appSettings?.app_template?.toInt() ?? 0) )
            switch template {
            case .Moby?:
                return .lightContent
                
            default:
                return .default
            }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
     //MARK:- Actions
    
    @IBAction func actionBtnBackPressed(_ sender: UIButton) {
        self.popVC()
    }
    
    
    //MARK:- Functions

    func updateTitle(strTitle : String) {
        lblTitle?.text = strTitle
    }
   
}
