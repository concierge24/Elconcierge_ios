//
//  CategorySelectionCell.swift
//  Clikat
//
//  Created by cblmacmini on 6/2/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import Material

class CategorySelectionCell: ThemeTableCell {

    
    @IBOutlet weak var labelCategoryTitle : UILabel!
    
    var category : Categorie?{
        didSet{
            labelCategoryTitle.text = category?.category_name
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
