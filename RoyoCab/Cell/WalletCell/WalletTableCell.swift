//
//  WalletTableCell.swift
//  RoyoRide
//
//  Created by Rohit Prajapati on 08/06/20.
//  Copyright © 2020 CodeBrewLabs. All rights reserved.
//

import UIKit

class WalletTableCell: UITableViewCell {
    
    //MARK:- OUTLETS
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
