//
//  OrderSummaryCell.swift
//  Clikat
//
//  Created by cblmacmini on 5/9/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

class OrderSummaryCell: ThemeTableCell {

    @IBOutlet weak var labelProductName: UILabel!
    @IBOutlet weak var labelQuantity: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    
    var cart : Cart?{
        didSet{
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func updateUI(){
        guard let cartProduct = cart else { return }
        
        labelProductName.text = cartProduct.name
        labelQuantity.text = UtilityFunctions.appendOptionalStrings(withArray: ["x" , cartProduct.quantity])
        if let points = cart?.loyalty_points {
            labelPrice.text =  UtilityFunctions.appendOptionalStrings(withArray: [points,L10n.Points.string])
        }else {
            guard let price = cartProduct.getPrice(quantity: cartProduct.quantity?.toDouble())?.toDouble() else { return }
            
            labelPrice.text =  (price * (cart?.quantity?.toDouble() ?? 0.0)).addCurrencyLocale
        }
    }
}
