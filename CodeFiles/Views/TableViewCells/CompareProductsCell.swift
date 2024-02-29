//
//  CompareProductsCell.swift
//  Clikat
//
//  Created by cblmacmini on 7/18/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import Material
class CompareProductsCell: ThemeTableCell {

    @IBOutlet weak var imageProduct : UIImageView!
    @IBOutlet weak var labelProductName : UILabel!
    @IBOutlet weak var labelProductDesc : UILabel!
    @IBOutlet weak var labelSKU : UILabel!
    
    var product : ProductF?{
        didSet{
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    
    
    func updateUI(){
        labelProductName?.text = product?.name
        labelProductDesc?.text = product?.supplierName
        
        product?.getPriceLabel(block: {
            [weak self] (txt) in
            guard let self = self else { return }
            self.labelSKU?.text = txt//product?.supplierName
        })
        
//        guard let image = product?.images?.first else{
//            return
//        }
//        imageProduct?.yy_setImage(with: URL(string: image), options: [.setImageWithFadeAnimation])
        imageProduct?.loadImage(thumbnail: product?.images?.first, original: nil)

    }
}
