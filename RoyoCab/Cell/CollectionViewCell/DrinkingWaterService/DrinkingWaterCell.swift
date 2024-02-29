//
//  DrinkingWaterCell.swift
//  
//
//  Created by MANINDER on 06/08/18.
//

import UIKit

class DrinkingWaterCell: UICollectionViewCell {
    
     //MARK:- OUTLETS
    @IBOutlet var imgViewWaterBrand: UIImageView!
    
    
    //MARK:- Functions
    
    func makeAsSelected(selected : Bool , model : Brand) {
        
        selected == true ? imgViewWaterBrand.addBorder(width: 3, color: .colorDefaultSkyBlue) :  imgViewWaterBrand.addBorder(width: 0.6, color: .gray)
        imgViewWaterBrand.sd_setImage(with: model.imageURL, completed: nil)
    }
}
