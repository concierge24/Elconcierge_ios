//
//  FilterTableViewSortedCell.swift
//  Sneni
//
//  Created by MAc_mini on 16/02/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

protocol FilterTblVwSortedDelegate: class {
    func selectedSortType(index:Int)
}

class FilterTableViewSortedCell: ThemeTableCell {
    
    @IBOutlet weak var radioButton:UIButton!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblSubTitle:UILabel?

    weak var delegate: FilterTblVwSortedDelegate?
    
    var sorted:Sorted? {
        didSet {
            
            radioButton.isSelected = sorted?.id == 1
            lblTitle.text = sorted?.variantName
            lblSubTitle?.text = sorted?.subName

        }
    }
}

extension FilterTableViewSortedCell {
    
    @IBAction func radiobtnClick(sender:UIButton) {
        delegate?.selectedSortType(index: self.tag)
    }
}
