//
//  LaundrySectionHeader.swift
//  Clikat
//
//  Created by cblmacmini on 8/3/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

class LaundrySectionHeader: UIView {
    
    var view: UIView!
    @IBOutlet weak var labelDetailSubCategory : UILabel!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        xibSetup()
        let tap = UITapGestureRecognizer(target: self, action: #selector(FloatingSupplierView.handleTap(sender:)))
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        
    }
    
    
    func xibSetup() {
        
        do {
            view = try loadViewFromNib(withIdentifier: CellIdentifiers.LaundrySectionHeader)
            view.frame = bounds
            view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
            addSubview(view)
        }
        catch let exception{
            print(exception)
        }
    }

}
