//
//  ETokenPurchasedCell.swift
//  Buraq24
//
//  Created by MANINDER on 29/08/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit

class ETokenPurchasedCell: UICollectionViewCell {

    //MARK:- Outlets
    @IBOutlet var imgViewBrand: UIImageView!
    @IBOutlet var lblTokenLeft: UILabel!
    @IBOutlet var viewOuter: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func assignTokenData(model : ETokenPurchased , selected : Bool) {
     imgViewBrand.sd_setImage(with: model.brand?.imageURL, completed: nil)
        lblTokenLeft.text =  String(/model.quantityToken) + " token left"
        viewOuter.isHidden = !selected
    }
}
