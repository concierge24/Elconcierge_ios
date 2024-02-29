//
//  RentalPaymentSummaryViewController.swift
//  Sneni
//
//  Created by Apple on 14/11/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class RentalPaymentSummaryViewController: UIViewController {

    //MARK:- IBOutlet
    @IBOutlet weak var topView: UIView! {
        didSet{
            topView.backgroundColor = SKAppType.type.color
        }
    }
    @IBOutlet weak var palceOrder_button: ThemeButton! {
        didSet{
            palceOrder_button.backgroundColor = SKAppType.type.color
        }
    }
    @IBOutlet weak var pickupTime_label: UILabel!
    @IBOutlet weak var pickupAddress_label: UILabel!
    @IBOutlet weak var remarks_textView: ThemeTextView!
    @IBOutlet weak var totalPrice_label: UILabel!
    @IBOutlet weak var paymentType_label: UILabel!
    @IBOutlet weak var choosePaymentMethod_button: UIButton!
    
    //MARK:- Variables
    var parameters = Dictionary<String,Any>()
    var orderSummary : OrderSummary? {
        didSet{
            pickupAddress_label.text = parameters["pickupAddress"] as? String ?? ""
            totalPrice_label.text = parameters["carPrice"] as? String ?? ""
        }
    }
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func back_buttonAction(_ sender: Any) {
        self.dismissVC(completion: nil)
    }
    
}
