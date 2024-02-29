//
//  ProductDetailFirstCell.swift
//  Clikat
//
//  Created by cbl73 on 5/6/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

class ProductDetailFirstCell: ThemeTableCell {

    var product : ProductF?{
        didSet{
            updateUI()
            stepper.associatedProduct = product
        }
    }
    
    @IBOutlet weak var labelOffer: UILabel!
    @IBOutlet weak var labelMeasuringUnit: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblPrice: UILabel! 
    @IBOutlet weak var stepper: GMStepper!

    
    private  func updateUI(){
    
        lblTitle?.text = product?.name
        
        lblPrice?.text = (Double(/product?.getDisplayPrice(quantity: product?.quantity?.toDouble()))).addCurrencyLocale
        
        labelMeasuringUnit?.text = product?.measuringUnit == "0" ? "" : product?.measuringUnit
        if let offer = product?.isOffer {
            labelOffer.isHidden = !offer
        }
        
        labelOffer?.text = (Double(/product?.offerPrice))?.addCurrencyLocale
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: labelOffer?.text ?? "")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        labelOffer?.attributedText = attributeString
        
        stepper.stepperValueListener = {
            [weak self] (value) in
            if let data = value as? Double {
                self?.lblPrice?.text = (Double(/self?.product?.getDisplayPrice(quantity: data))).addCurrencyLocale
            }
        }

        guard let value = Double(product?.quantity ?? "0") else { return }
        stepper.value = value
        
    }
    
}
