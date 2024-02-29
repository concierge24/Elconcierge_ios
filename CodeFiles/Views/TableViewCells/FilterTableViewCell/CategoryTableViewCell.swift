//
//  CategoryTableViewCell.swift
//  Sneni
//
//  Created by MAc_mini on 17/02/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class CategoryTableViewCell: ThemeTableCell {
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblCategoryName:UILabel!
    @IBOutlet weak var switchBtn:UISwitch!
    
    var sorted: Sorted? {
        didSet {
            lblTitle.text = sorted?.variantName
        }
    }
    
    var objFilter: FilterCategory = FilterCategory() {
        didSet {
            
            lblCategoryName.text = objFilter.catPath
            lblCategoryName.isHidden = (sorted?.type != TableViewSectionTypes.category || objFilter.catPath.isEmpty)
            
            switchBtn.isHidden = sorted?.type == TableViewSectionTypes.category
            accessoryType = sorted?.type == TableViewSectionTypes.category ? .disclosureIndicator : .none

            ///switchBtn
            var state = true
            if sorted?.type == TableViewSectionTypes.discount {
                state = objFilter.discount == 1
            } else if sorted?.type == TableViewSectionTypes.availability {
                state = objFilter.availablity == 1
            }
            switchBtn.setOn(state, animated: false)
            
        }
    }

    //MARK:- ======== Actions ========
    @IBAction func switchValueChanged (sender: UISwitch) {

        let selectedState = sender.isOn == true ? 1 : 0

        guard let filterVC = self.superview?.superview?.next as? FilterVC else {
            return
        }

        if sorted?.type == TableViewSectionTypes.discount {
            filterVC.objFilter.discount = selectedState
        } else if sorted?.type == TableViewSectionTypes.availability {
            filterVC.objFilter.availablity = selectedState
        }
        filterVC.tableView.reloadData()
    }
}
