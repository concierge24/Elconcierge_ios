//
//  ConfirmBookingVC.swift
//  RoyoRide
//
//  Created by Prashant on 03/06/20.
//  Copyright © 2020 CodeBrewLabs. All rights reserved.
//

import UIKit

class ConfirmBookingVC: UIViewController {

    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    
    
    typealias ConfirmationStatus = (_ status:Bool)->()
    
    var confirmationStatus:ConfirmationStatus?
    
    override func viewDidLoad() {
        super.viewDidLoad()

         btnYes.setButtonWithBackgroundColorThemeAndTitleColorBtnText()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        
        if let confirmationStatus = confirmationStatus{
            let status = sender.tag == 1
            confirmationStatus(status)
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
