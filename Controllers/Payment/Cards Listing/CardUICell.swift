//
//  CardUICell.swift
//  Sneni
//
//  Created by admin on 06/04/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit

class CardUICell: UITableViewCell {
    
    @IBOutlet weak var lblCardHolderText: UILabel?
    @IBOutlet weak var lblCardHolderName: UILabel?
    @IBOutlet weak var lblCardNumber: UILabel?
    @IBOutlet weak var lblExpDate: UILabel?
    @IBOutlet weak var btnDelete: UIButton?{
        didSet{
            if let color = AppSettings.shared.appThemeData?.theme_color {
                       let backcolor = UIColor(hexString: color)
                btnDelete?.backgroundColor = backcolor//header ?? UIColor.white
                   }
        }
    }
    
    var deleteCard: (() -> ())?
    var cardId: String?
    var gateway_unique_id: String?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func deleteCard(_sender : UIButton){
        hitDeleteCardApi()
    }
    
    func hitDeleteCardApi(){

        let params = (FormatAPIParameters.deleteCard(customer_paymentId: GDataSingleton.sharedInstance.customerPaymentId, card_id: /cardId, gateway_unique_id: gateway_unique_id ?? "squareup").formatParameters())

            let objR = API.deleteCard(params)
        APIManager.sharedInstance.opertationWithRequest( withApi: objR) {
                [weak self] (response) in

                switch response {
                case .Success(_):
                    self?.deleteCard!()
                default:
                    break
                }

        }
    }
    
}
