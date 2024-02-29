//
//  CheckListCell.swift
//  RoyoRide
//
//  Created by Rohit Prajapati on 18/05/20.
//  Copyright © 2020 CodeBrewLabs. All rights reserved.
//

import UIKit

class CheckListCell: UITableViewCell {

    @IBOutlet weak var lblItem: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var txfPrice: UITextField!
    @IBOutlet weak var lblCurrency: UILabel!
    @IBOutlet weak var lblTaxPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
