//
//  MyETokenCell.swift
//  Buraq24
//
//  Created by MANINDER on 27/10/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit

class MyETokenCell: UITableViewCell {
    
    
    //MARK:- Outlets
    
    @IBOutlet var imgViewBrandLogo: UIImageView!
    @IBOutlet var lblBrandName: UILabel!
    @IBOutlet var lblTotalTokens: UILabel!
    @IBOutlet var lblTokenValue: UILabel!
    @IBOutlet var lblTokenPrice: UILabel!
    @IBOutlet var lblPurchasedDate: UILabel!
    
    @IBOutlet var lblAvailableTokenCount: UILabel!
    
    @IBOutlet var lblUsedTokenCount: UILabel!
    
    //MARK:- Properties

    
    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
