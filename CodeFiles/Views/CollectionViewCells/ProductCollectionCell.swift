//
//  ProductCollectionCell.swift
//  Clikat
//
//  Created by cblmacmini on 4/29/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import Material

class ProductCollectionCell: ThemeCollectionViewCell {
    
    
    @IBOutlet weak var imgFav: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var stepper: GMStepper!
    
    var product : ProductF? {
        didSet {
            updateUI()
            stepper.associatedProduct = product
        }
    }
    
    private func updateUI() {
        
        defer {
            lblTitle?.text = product?.name
            
            product?.getPriceLabel(block: {
                [weak self] (value) in
                guard let self = self else { return }
                self.lblPrice?.text = value
                
            })
//            lblPrice?.text = UtilityFunctions.appendOptionalStrings(withArray: [L10n.AED.string ,product?.displayPrice])
             guard let value = Double(product?.quantity ?? "0") else { fatalError("Cart Quantity is nil") }
             stepper.value = value
        }
        imgFav.loadImage(thumbnail: product?.image, original: nil)
    }
    
}

//MARK: - ButtonActions

extension ProductCollectionCell {
    
    
    @IBAction func actionRemoveProduct(sender: UIButton) {
        
    }
    
    @IBAction func actionAddProduct(sender: UIButton) {
    
    }
}
