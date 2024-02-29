//
//  VariantView.swift
//  Sneni
//
//  Created by cbl41 on 3/17/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit

class VariantView: UIView {

    @IBOutlet weak var lblType: ThemeLabel!
    @IBOutlet weak var lblValue: ThemeLabel!
    @IBOutlet weak var viewColor: UIView!
    
    override init(frame: CGRect) {
           
           super.init(frame: frame)
           xibSetup()
       }
       
       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           xibSetup()
       }
       
       var view: UIView!
       
       func xibSetup() {
           view = loadViewFromNib()
           view.frame = bounds
           view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
           addSubview(view)
       }
       
       func loadViewFromNib() -> UIView {
           
           self.removeFromSuperview()
           let bundle = Bundle(for: type(of: self))
           let nib = UINib(nibName: CellIdentifiers.VariantView , bundle: bundle)
           let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
           return view
       }
       
    func configureVariant(_ variant: ProductVariantValue) {
        lblType.text = variant.variantName + ":"
        if variant.variantName.capitalizedFirst() == "Color" || variant.variantName.capitalizedFirst() == "Colour" {
            viewColor.isHidden = false
            lblValue.isHidden = true
            viewColor.backgroundColor = UIColor.init(hexString: variant.variantValue ?? "")
        }
        else {
            viewColor.isHidden = true
            lblValue.isHidden = false
            lblValue.text = variant.variantValue
        }
    }
}
