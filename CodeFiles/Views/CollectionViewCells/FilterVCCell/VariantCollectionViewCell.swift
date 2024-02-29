//
//  VariantCollectionViewCell.swift
//  Sneni
//
//  Created by MAc_mini on 17/02/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class VariantCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var sizeLabel:UILabel!
    @IBOutlet weak var vwColor:UIView! {
        
        didSet{
              vwColor.roundView(withBorderColor: ViewThemeColor.shared.viewThemeColor, withBorderWidth: 2.0)
        }
        
    }
    
    var variantValue:VariantValue?
    
    var productVariantValue:ProductVariantValue?
    
    var isFilterVariant:Bool?
    
    var type : String?{
        didSet{
            
       
            
            if type == "Color" || type == "Colour"{
                
                vwColor.backgroundColor = isFilterVariant == true ?  UIColor.init(hexString: variantValue?.value ?? "") : UIColor.init(hexString: productVariantValue?.variantValue ?? "")
                sizeLabel.isHidden = true
                vwColor.isHidden = false
            }
            else{
                
                if type != "Brands"{
                    
                    sizeLabel.text = isFilterVariant == true ? variantValue?.value.capitalized : productVariantValue?.variantValue.capitalized
                    sizeLabel.isHidden = false
                    vwColor.isHidden = true
                }
                
              
            }
      
            
        }
    }
    
    
    var brand:Brands?{
        
        didSet{
            
             vwColor.isHidden = true
             sizeLabel.isHidden = false
             sizeLabel.text = brand?.name.capitalized
             sizeLabel.lineBreakMode = .byClipping
            
        }
        
    }
}
