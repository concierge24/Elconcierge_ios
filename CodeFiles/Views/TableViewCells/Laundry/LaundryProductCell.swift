//
//  LaundryProductCell.swift
//  Clikat
//
//  Created by cblmacmini on 6/10/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

class LaundryProductCell: ThemeTableCell {

    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var labelProductName: UILabel!
    @IBOutlet weak var stepper: GMStepper!{
        didSet{
            stepper.label.textColor = UIColor.black.withAlphaComponent(0.25)
        }
    }
    @IBOutlet weak var labelPrice: UILabel!
    private func updatePrice(product : Cart?)
    {
        product?.getPriceLabel(block: {
            [weak self] (value) in
            guard let self = self else { return }
            self.labelPrice?.text = value
            self.labelPrice.isHidden = false
        })
    }
    
    var product : ProductF?{
        didSet{
            product?.category = "2"
            labelProductName?.text = product?.name
            stepper.associatedProduct = product
            stepper.value = product?.quantity?.toDouble() ?? 0
//            guard let price = Double(product?.price ?? "0") else { return }
//            labelPrice.text = UtilityFunctions.appendOptionalStrings(withArray: [product?.price])
            updatePrice(product: product)
            
//            if (product?.price?.toInt() ?? 0) <= 0 {
//                stepper.isHidden = true
//                labelPrice.isHidden = true
//            }
//            guard let image = product?.image,let url = URL(string:image) else { return }
//            imageProduct.yy_setImage(with: url, options: .setImageWithFadeAnimation)
            imageProduct.loadImage(thumbnail: product?.image, original: nil)

        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
