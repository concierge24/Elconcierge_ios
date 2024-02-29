//
//  OrderBillCell.swift
//  Clikat
//
//  Created by cblmacmini on 5/9/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

class OrderBillCell: ThemeTableCell {
    
    @IBOutlet weak var labelNetAmount: UILabel!
    @IBOutlet weak var labelHandlingFee: UILabel!
    @IBOutlet weak var labelDeliveryCharges: UILabel!
    @IBOutlet weak var labelPayableAMount: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var stackDiscount: UIStackView! {
        didSet {
            stackDiscount.isHidden = SKAppType.type.isJNJ
        }
    }

    @IBOutlet weak var tvRemarks: UITextView!
    
    var orderSummary : OrderSummary?{
        didSet{
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateUI(){
        labelNetAmount.text = orderSummary?.displayNetTotal
        labelHandlingFee.text = orderSummary?.handlingCharges
        labelDeliveryCharges.text = orderSummary?.deliveryCharges
        labelPayableAMount.text = orderSummary?.netPayableAmount
        lblDiscount.text = orderSummary?.discount?.addCurrencyLocale
    }

}
