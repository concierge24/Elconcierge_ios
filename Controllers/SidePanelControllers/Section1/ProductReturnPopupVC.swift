//
//  ProductReturnPopupVC.swift
//  Sneni
//
//  Created by Ankit Chhabra on 28/04/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit
import Material

class ProductReturnPopupVC: UIViewController {

    @IBOutlet weak var textView: TextView!
    @IBOutlet weak var btnSubmit: UIButton! {
        didSet {
            btnSubmit.setBackgroundColor(SKAppType.type.color, forState: .normal)
        }
    }
    @IBOutlet weak var btnCancel: UIButton!
    
    
    var orderPriceId : Int?
    var productId: String?
    var delegate: ReturnStatusProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionSubmit(_ sender: Any) {
        if textView.text!.trim().isEmpty {
            SKToast.makeToast("Please enter a reason".localized())
            return
        }
        
        let params = (FormatAPIParameters.returnProduct(order_price_id: /orderPriceId, product_id: /productId?.toInt(), reason: textView.text!.trim()).formatParameters())

        let objR = API.returnProduct(params)
        APIManager.sharedInstance.opertationWithRequest( withApi: objR) {
                [weak self] (response) in
                
                switch response {
                case .Success(_):
                    self?.dismissVC(completion: {
                        self?.delegate?.updateReturnStatus()
                    })
                default:
                    break
                }
            
        }
        
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        self.dismissVC(completion: nil)
    }

}
