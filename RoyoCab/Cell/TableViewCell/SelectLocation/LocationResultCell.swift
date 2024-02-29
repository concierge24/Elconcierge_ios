//
//  LocationResultCell.swift
//  Buraq24
//
//  Created by MANINDER on 04/08/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit
import GooglePlaces

class LocationResultCell: UITableViewCell {

    //MARK:- OUTLETS
    @IBOutlet var lblLocationName: UILabel!
    
    //MARK:- LifeCycle Function
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- FUNCTIONS
    
    func assignData(item :GMSAutocompletePrediction ) {
        print(item.attributedFullText)
        
        lblLocationName.text = item.attributedFullText.string
    }
}
