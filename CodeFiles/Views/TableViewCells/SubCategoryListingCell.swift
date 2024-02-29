//
//  SubCategoryListingCell.swift
//  Clikat
//
//  Created by cbl73 on 4/21/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import Material

class SubCategoryListingCell: ThemeTableCell {

    @IBOutlet weak var imageSubCategory: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
 
    
    var subCategory : SubCategory?{
        didSet{
            updateUI()
        }
    }
    
    var category : Categorie?{
        didSet{
              
              lblTitle?.text = category?.category_name
              lblDesc?.text = category?.desc
              imageSubCategory?.loadImage(thumbnail: category?.image, original: nil)
        }
    }
    
    private func updateUI(){
        
        defer {
            
            lblTitle?.text = subCategory?.name
            lblDesc?.text = subCategory?.subCategoryDesc
        }
        
        imageSubCategory?.loadImage(thumbnail: subCategory?.image, original: nil)

    }

}
