//
//  PriceRangeTableViewCell.swift
//  Sneni
//
//  Created by MAc_mini on 17/02/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

protocol priceRangeChanges {
    func getPriceValues(upperValue: Int, lowerValue:Int)
}


class PriceRangeTableViewCell: ThemeTableCell {
    
    @IBOutlet weak var rangeLabelLbl:UILabel!
    
    @IBOutlet weak var slider: RangeSlider? {
        didSet{
             slider?.thumbTintColor = ButtonThemeColor.shared.btnThemeColor
             slider?.trackHighlightTintColor = ButtonThemeColor.shared.btnThemeColor
             slider?.thumbBorderColor = ButtonThemeColor.shared.btnThemeColor
        }
    }
    
    //MARK:- ======== Variables ========
    var delegate :priceRangeChanges?
    var objFilter: FilterCategory = FilterCategory() {
        didSet {
            
            slider?.maximumValue  = objFilter.maxPriceLimit.toDouble
            slider?.minimumValue = objFilter.minPriceLimit.toDouble
            slider?.upperValue = objFilter.maxPrice.toDouble
            slider?.lowerValue = objFilter.minPrice.toDouble
            
            rangeLabelLbl.text = "\(Double(Int(/slider?.lowerValue)).addCurrencyLocale) - \(Double(Int(/slider?.upperValue)).addCurrencyLocale)"

        }
    }
}

extension PriceRangeTableViewCell {
    
    @IBAction func rangeSliderValueChanged(_ rangeSlider: RangeSlider){
        
        rangeLabelLbl.text = "\(Double(Int(rangeSlider.lowerValue)).addCurrencyLocale) - \(Double(Int(rangeSlider.upperValue)).addCurrencyLocale)"
        delegate?.getPriceValues(upperValue: Int(rangeSlider.upperValue), lowerValue: Int(rangeSlider.lowerValue))

    }
}
