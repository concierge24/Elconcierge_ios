//
//  SignupDeclarationVC.swift
//  Sneni
//
//  Created by admin on 14/09/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit

class SignupDeclarationVC: UIViewController {

    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var btnBack: BackButtonImage!
    
    @IBOutlet weak var lblSubTitle: ThemeLabel!
    @IBOutlet weak var lablTitle: ThemeLabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var onAgreeBlock : (() -> ())?
    override func viewDidLoad() {
        super.viewDidLoad()
        if AppSettings.shared.appThemeData?.is_dark_mode_enabled == "1" {
            if #available(iOS 13.0, *) {
                if UITraitCollection.current.userInterfaceStyle == .dark {
                    view.backgroundColor = .black
                    lblSubTitle.textColor = .white
                    lablTitle.textColor = .white
                    scrollView.backgroundColor = .black
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.dismissVC(completion: nil)
    }
    
    @IBAction func actionCheck(_ sender: Any) {
        btnCheck.isSelected = !btnCheck.isSelected
    }
    
    @IBAction func actionAgree(_ sender: Any) {
        if !btnCheck.isSelected {
            SKToast.makeToast("You must agree to the declaration before placing order.")
            return
        }
        
        self.dismissVC {
            self.onAgreeBlock?()
        }
        
    }
    
}
