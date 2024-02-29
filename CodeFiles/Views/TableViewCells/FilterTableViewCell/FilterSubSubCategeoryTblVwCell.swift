//
//  FilterSubSubCategeoryTblVwCell.swift
//  Sneni
//
//  Created by MAc_mini on 22/02/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class FilterSubSubCategeoryTblVwCell: UITableViewCell {
    
    @IBOutlet weak var checkBoxButton:UIButton!
    @IBOutlet weak var lblTitle:UILabel!
    // @IBOutlet weak var lblDesc: UILabel!
    
    var isAllCategory:Bool = false
    
    var subCategory : SubCategory?{
        didSet{
//            updateUI()
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}


extension FilterSubSubCategeoryTblVwCell{
    
//    private func updateUI(){
//
//        defer {
//
//
//            checkBoxButton.isHidden = subCategory?.is_cub_category != "0"
//            checkBoxButton.isSelected = FilterCategory.shared.subCatIdArray.contains(/subCategory?.subCategoryId)
//
//            lblTitle?.text = subCategory?.name ?? ""
//
//            if FilterCategory.shared.categoryNameArray.contains(/subCategory?.name){
//                lblTitle?.textColor =  LabelThemeColor.shared.lblSelectedTitleClr
//            }
//        }
//    }
}

//extension FilterSubSubCategeoryTblVwCell{
//
//    @IBAction func checkBoxbtnClick(sender: UIButton) {
//
//        self.setSelectedCategoryDetail(sender: sender)
//
//    }
//
//
//    func setSelectedCategoryDetail(sender: UIButton)  {
//
//        if FilterCategory.shared.subCatIdArray.contains(/subCategory?.subCategoryId) {
//
//            let indexOf = FilterCategory.shared.subCatIdArray.index(where: {$0 == subCategory?.subCategoryId})
//            FilterCategory.shared.subCatIdArray.remove(at: /indexOf)
//
//            sender.isSelected = false
//
//            let indexOfName = FilterCategory.shared.categoryNameArray.index(where: {$0 == subCategory?.name})
//            FilterCategory.shared.categoryNameArray.remove(at: /indexOfName)
//
//        } else{
//
//            sender.isSelected = true
//            FilterCategory.shared.subCatIdArray.append(/subCategory?.subCategoryId)
////            sender.setImage(UIImage(asset: Asset.ic_checkbox_checked), for: .normal)
//            FilterCategory.shared.categoryNameArray.append(subCategory?.name ?? "")
//        }
//
//        if let vc = self.superview?.superview?.next as? FilterSubSubCategeoryVC {
//
//            if vc.subCatArray.contains(subCategory?.subCategoryId ?? "") {
//
//                let indexOf = vc.subCatArray.index(where: {$0 == subCategory?.subCategoryId})
//                vc.subCatArray.remove(at: /indexOf)
//
//            } else{
//                vc.subCatArray.append(subCategory?.subCategoryId ?? "")
//            }
//            vc.btnDone.isHidden = vc.subCatArray.isEmpty
//        }
//    }
//}
