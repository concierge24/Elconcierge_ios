//
//  ETokenOfferCell.swift
//  Buraq24
//
//  Created by MANINDER on 30/10/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit

class ETokenOfferCell: UITableViewCell {
    
    
    //MARK:- Outlets
    
    @IBOutlet var imgViewBrand: UIImageView!
    @IBOutlet var btnViewOffers: UIButton!
    @IBOutlet var lblBrandName: UILabel!
    
    //MARK:- Properties
    
    
    //MARK:- View Life Cycles
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- Actions
    @IBAction func actionBtnViewOffers(_ sender: UIButton) {
        
    }
    
    
}
