//
//  FareBreakdownViewController.swift
//  Trava
//
//  Created by Apple on 15/11/19.
//  Copyright © 2019 CodeBrewLabs. All rights reserved.
//

import UIKit

class FareBreakdownViewController: UIViewController {

    //MARK:- Outlet
    
    @IBOutlet weak var labelValueBaseFare: UILabel!
    @IBOutlet weak var labelValueMinimumFare: UILabel!
    @IBOutlet weak var labelValuePerMinute: UILabel!
    @IBOutlet weak var labelValuePerKm: UILabel!
    
    // MARK:- Properties
    var product: ProductCab?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }
}

// MARK: - Actions
extension FareBreakdownViewController {
    
    func initialSetup() {
        
        labelValueBaseFare.text = (/UDSingleton.shared.appSettings?.appSettings?.currency) + " " + String(/product?.alphaPrice)
        labelValueMinimumFare.text = (/UDSingleton.shared.appSettings?.appSettings?.currency) + " " + String(/product?.actualPrice)
        labelValuePerMinute.text = (/UDSingleton.shared.appSettings?.appSettings?.currency) + " " + String(/product?.price_per_hr)
        labelValuePerKm.text = (/UDSingleton.shared.appSettings?.appSettings?.currency) + " " + String(/product?.pricePerDistance)
    }
    
}

// MARK: - Actions
extension FareBreakdownViewController {
    
    @IBAction func actionButtonCancel(_ sender: Any) {
        
        dismissVC(completion: nil)
    }
    
}
