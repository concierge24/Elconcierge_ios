//
//  SponsorView.swift
//  Clikat
//
//  Created by cblmacmini on 6/12/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

class SponsorView: UIView {

    @IBOutlet weak var imageViewSponsor : UIImageView!
    
    var view: UIView!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    
    func xibSetup() {
        
        do {
            view = try loadViewFromNib(withIdentifier: CellIdentifiers.SponsorView)
            view.frame = bounds
            view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
            addSubview(view)
        }
        catch let exception{
            print(exception)
        }
    }
}
