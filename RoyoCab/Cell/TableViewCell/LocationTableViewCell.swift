//
//  LocationTableViewCell.swift
//  Trava
//
//  Created by Dhan Guru Nanak on 11/6/19.
//  Copyright © 2019 CodeBrewLabs. All rights reserved.
//

import UIKit
import GooglePlaces

class LocationTableViewCell: UITableViewCell {
    
    //MARK:- Outlets
    
    @IBOutlet weak var imageViewLocation: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func assignData(item :AddressCab ) {
        
        lblTitle.text = item.addressName
        lblSubtitle.text = item.address
    }
    
}
