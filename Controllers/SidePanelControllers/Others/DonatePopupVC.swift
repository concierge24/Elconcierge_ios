//
//  DonatePopupVC.swift
//  Sneni
//
//  Created by Daman on 18/05/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit

class DonatePopupVC: CategoryFlowBaseViewController {

    @IBOutlet var btnAddress: ThemeButton!
    
    var completion: BoolBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }

    func setupView() {
        if let address = LocationSingleton.sharedInstance.searchedAddress, let addressId = address.id, !addressId.isEmpty {
            btnAddress.setTitle(address.formattedAddress, for: .normal)
        }
    }
    
    @IBAction func selectAddress(_ sender: Any) {
        //address is saved in LocationSingleton.sharedInstance.searchedAddress
        self.openAdressController { [weak self] (address) in
            self?.btnAddress.setTitle(address.formattedAddress, for: .normal)
        }
    }
    
    @IBAction func continueToDonate(_ sender: Any) {
        completion?(true)
    }
    
    @IBAction func skip(_ sender: Any) {
        completion?(false)
    }
    
}
