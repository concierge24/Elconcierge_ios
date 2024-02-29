//
//  LoyalityPointsCell.swift
//  Clikat
//
//  Created by Night Reaper on 19/05/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

class LoyalityPointsCell: ThemeCollectionViewCell {

    var loyalityPoints : LoyalityPoints? {
        didSet{
            updateUI()
        }
    }
    
    
    @IBOutlet var imgTick: UIImageView!
    @IBOutlet var imgProduct: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblPrice: UILabel!
   
    @IBOutlet weak var labelSupplierName: UILabel!
    
    private func updateUI() {
        
        defer{
            lblTitle?.text = loyalityPoints?.name
            lblPrice?.text = UtilityFunctions.appendOptionalStrings(withArray: [loyalityPoints?.loyalty_points , L10n.Points.string])
            labelSupplierName?.text = loyalityPoints?.supplierName
        }
        imgProduct.loadImage(thumbnail: loyalityPoints?.image, original: nil)
    }

}
