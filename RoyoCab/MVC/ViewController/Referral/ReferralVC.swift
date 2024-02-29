//
//  ReferralVC.swift
//  Buraq24
//
//  Created by MANINDER on 07/09/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit

class ReferralVC: BaseVCCab {

    //MARK:- Outlets
    @IBOutlet weak var lblAppName: UILabel!
    @IBOutlet weak var lblShare: UILabel!
    @IBOutlet weak var btnShare: UIButton!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
         guard let referralCode = UDSingleton.shared.userData?.userDetails?.user?.referral_code else{return}
        btnShare.setButtonWithBackgroundColorSecondaryAndTitleColorBtnText()
        
        lblAppName.text = "Like \("AppName".localizedString)?"
        lblShare.text = "Share With your friend \nReferral Code: \(referralCode)"
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- Actions
    
    @IBAction func actionBtnSharePressed(_ sender: UIButton) {
        
         guard let referralCode = UDSingleton.shared.userData?.userDetails?.user?.referral_code else{return}
        
        let textToShare = "Install \("AppName".localizedString) Customer Application \nReferral Code: \(referralCode)"
        if let appUrl = NSURL(string: APIBasePath.AppStoreURL) {
            let objectsToShare = [textToShare, appUrl] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC, animated: true, completion: nil)
        }
    }

}
