//
//  ThemeTableCell.swift
//  Sneni
//
//  Created by MAc_mini on 25/01/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class ThemeTableCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = TableThemeColor.shared.cellThemeColor
    }
    
    
    
}
