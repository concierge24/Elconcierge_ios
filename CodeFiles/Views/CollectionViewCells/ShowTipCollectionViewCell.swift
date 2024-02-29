//
//  ShowTipCollectionViewCell.swift
//  Sneni
//
//  Created by Apple on 10/02/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit

class ShowTipCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var labelTip: UILabel?
    @IBOutlet weak var viewTip: UIView?{
        didSet{
            viewTip?.cornerRadiusR = 8
            viewTip?.shadowRadius = 4.0
            viewTip?.shadowColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
            viewTip?.shadowOpacity = 0.2
        }
    }
    
}
