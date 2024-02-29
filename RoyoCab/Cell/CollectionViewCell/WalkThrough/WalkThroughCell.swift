//
//  WalkThroughCell.swift
//  Buraq24
//
//  Created by MANINDER on 31/07/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit

class WalkThroughCell: UICollectionViewCell {
    
     //MARK:- OUTLETS
    @IBOutlet weak var imgViewMain: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!

    
    
    //MARK:- FUNCTIONS
    func configureCell(item : WalkThroughModel) {
        
        imgViewMain.image = item.image
        lblTitle.text = item.title
        lblDescription.text = item.subtitle
    }
}
