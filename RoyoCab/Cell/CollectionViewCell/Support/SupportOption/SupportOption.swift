//
//  SupportOption.swift
//  Buraq24
//
//  Created by MANINDER on 03/09/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit

class SupportOption: UICollectionViewCell {
    
    
    //MARK:- Outlets
    @IBOutlet var imgViewSupport: UIImageView!
    @IBOutlet var lblSupportName: UILabel!
    
    
    //MARK:- Functions
    
    func configureCell(model : SupportCab) {
        
        if let imgURL = model.actualURL {
            imgViewSupport.sd_setImage(with: imgURL, placeholderImage: #imageLiteral(resourceName: "ic_user"), options: .refreshCached, progress: nil, completed: nil)
            //imgViewSupport.sd
        }
        
        lblSupportName.text = /model.name
    }
    
}
