//
//  LaundryServiceHeaderView.swift
//  Clikat
//
//  Created by cbl73 on 5/7/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

class LaundryServiceHeaderView: UIView {
    
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
        
        do{
            try view = loadViewFromNib(withIdentifier: CellIdentifiers.LaundryServiceHeaderView)
            view.frame = bounds
            view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
            addSubview(view)
        }
        catch let exception{
            print(exception)
        }
        
        
    }
    

}
