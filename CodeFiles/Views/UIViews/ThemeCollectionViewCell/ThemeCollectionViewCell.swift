//
//  ThemeCollectionViewCell.swift
//  Sneni
//
//  Created by MAc_mini on 25/01/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class ThemeCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = CollectionThemeColor.shared.cellThemeColor
    }
    
}
