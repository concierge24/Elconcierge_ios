//
//  ServiceCell.swift
//  Buraq24
//
//  Created by MANINDER on 01/08/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit

class ServiceCellCab: UICollectionViewCell {
    
     //MARK:- OUTLETS
    @IBOutlet var imgViewService: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
     //MARK:- FUNCTIONS
    func configureCell(item : ServiceTypeCab , selected : Bool) {
        imgViewService.image = selected ? item.serviceImageSelected : item.serviceImageUnSelected
    }
    
}
