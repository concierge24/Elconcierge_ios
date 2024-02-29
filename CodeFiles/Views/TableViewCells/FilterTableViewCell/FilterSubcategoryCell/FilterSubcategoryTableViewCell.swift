//
//  FilterSubcategoryTableViewCell.swift
//  Sneni
//
//  Created by MAc_mini on 18/02/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class FilterSubcategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var checkBoxButton:UIButton!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    
    var isSelect: Bool = false {
        didSet {
            checkBoxButton.isSelected = isSelect
        }
    }
    
    var subCategory : SubCategory? {
        didSet {
            isSelect = /subCategory?.isSelected
//            checkBoxButton.isHidden = subCategory?.is_cub_category == "1"
            
            lblTitle?.text = /subCategory?.name
            lblDesc?.text = /subCategory?.subCategoryDesc

            checkBoxButton.isUserInteractionEnabled = false
        }
    }
    
}

extension FilterSubcategoryTableViewCell{
    
    @IBAction func checkBoxbtnClick(sender: UIButton) {
        
//        if FilterCategory.shared.subCatIdArray.contains(/subCategory?.subCategoryId) {
//
//            let indexOf = FilterCategory.shared.subCatIdArray.index(where: {$0 == subCategory?.subCategoryId})
//            FilterCategory.shared.subCatIdArray.remove(at: /indexOf)
//
//            let indexOfName = FilterCategory.shared.categoryNameArray.index(where: {$0 == subCategory?.name})
//            FilterCategory.shared.categoryNameArray.remove(at: /indexOfName)
//            sender.isSelected = false
//
//        } else {
//
//            FilterCategory.shared.subCatIdArray.append(/subCategory?.subCategoryId)
//            FilterCategory.shared.categoryNameArray.append(/subCategory?.name)
//
//            sender.isSelected = true
//
//        }
    }
    
    
}
