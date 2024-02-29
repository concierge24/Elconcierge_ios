//
//  HomeSectionHeader.swift
//  Clikat
//
//  Created by cblmacmini on 4/23/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class HomeSectionHeader: UIView {

    @IBOutlet weak var btnViewAll : UIButton!
    @IBOutlet weak var labelTitle: UILabel!
    {
        didSet
        {
            labelTitle.text = "Restaurants".localized()
        }
    }
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblLine: UILabel!
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
            view = try loadViewFromNib(withIdentifier: CellIdentifiers.HomeSectionHeader)
            view.frame = bounds
            view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
            addSubview(view)
        }
        catch let exception{
            print(exception)
        }
    }
    
    
    var isOffer: Bool = false {
        didSet {
            
            btnViewAll.isHidden = !isOffer
            
//            if isOffer {
//
//                btnViewAll.setTitleColor(.white, for: .normal)
//                labelTitle.textColor = .white
//                lblDetail.textColor = .white
//                backgroundColor = SKAppType.type.color
//            } else {
                backgroundColor = TableThemeColor.shared.lblSectionHeaderClr
                labelTitle.textColor = #colorLiteral(red:0.14, green:0.16, blue:0.19, alpha:1)
                lblDetail.textColor = #colorLiteral(red:0.42, green:0.44, blue:0.45, alpha:1)
                btnViewAll.setTitleColor(#colorLiteral(red:0.14, green:0.16, blue:0.19, alpha:1), for: .normal)

//            }
        }
    }
   
}


extension HomeSectionHeader {
    
    @IBAction func didTapViewAll(_ sender: UIButton) {

       
        let VC = ItemListingViewController.getVC(.main)
        VC.isOffers = true
        ez.topMostVC?.pushVC(VC)
        
    }
    
}
