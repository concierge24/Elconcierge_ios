//
//  ReferalViewController.swift
//  Sneni
//
//  Created by Gagandeep Singh on 16/03/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit

class ReferalViewController: UIViewController {
    
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var lblTapToCopy: UILabel!
    @IBOutlet weak var viewReferalBorder: UIView!
    @IBOutlet weak var btnRefer: UIButton!
    @IBOutlet weak var lblReferal: ElementLabel!
    @IBOutlet weak var lblReferalText: ElementLabel!
    @IBOutlet weak var viewTapBg: UIView!
    
    //MARK::- PROPERIES
    
    
    
    //MARK::- VIEW CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    //MARK::- FUNCTIONS
    
    func updateUI(){
        lblTapToCopy.addTapGesture { (gesture) in
            let pasteboard = UIPasteboard.general
            pasteboard.string = /GDataSingleton.sharedInstance.loggedInUser?.referral_id
        }
        lblReferal?.text = /GDataSingleton.sharedInstance.loggedInUser?.referral_id
        viewTapBg.backgroundColor = SKAppType.type.color
        btnRefer.backgroundColor = SKAppType.type.color
        viewReferalBorder.layer.borderColor = SKAppType.type.color.cgColor
        lblReferalText.text = "Refer a friend and get \((/AgentCodeClass.shared.settingData?.referral_receive_price?.toDouble()).addCurrencyLocale) and your friend gets \((/AgentCodeClass.shared.settingData?.referral_given_price?.toDouble()).addCurrencyLocale) after successful completion of his first Order."
    }
    
    
    //MARK::- ACTIONS
    
    @IBAction func btnActionreferNow(_ sender: UIButton) {
        let meassage = "Use code \(/GDataSingleton.sharedInstance.loggedInUser?.referral_id) to get \(/AgentCodeClass.shared.settingData?.referral_given_price) as referral bonus here: "
        UtilityFunctions.shareContentOnSocialMedia(withViewController: UtilityFunctions.sharedAppDelegateInstance().window?.rootViewController, message: meassage)
    }
}
