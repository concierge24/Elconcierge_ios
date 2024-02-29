//
//  CheckListCell.swift
//  RoyoRide
//
//  Created by Rohit Prajapati on 01/06/20.
//  Copyright © 2020 CodeBrewLabs. All rights reserved.
//

import UIKit

class CheckListOrderCell: UITableViewCell {
    
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var txfItemPrice: UITextField!
    @IBOutlet weak var lblTaxPrice: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblPriceSymbol: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        bgView.setViewBorderColorSecondary()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
