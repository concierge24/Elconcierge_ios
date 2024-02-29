//
//  ProductCategoryCell.swift
//  Sneni
//
//  Created by Apple on 22/06/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class ProductCategoryCell: UICollectionViewCell {

    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    
    var subCategory : SubCategory?{
        didSet{
            lblProductName?.text = subCategory?.name
            imgProduct?.loadImage(thumbnail: subCategory?.image, original: nil)

        }
    }
    
    var category : Categorie?{
          didSet{
              lblProductName?.text = category?.category_name
              imgProduct?.loadImage(thumbnail: category?.image, original: nil)

          }
      }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
