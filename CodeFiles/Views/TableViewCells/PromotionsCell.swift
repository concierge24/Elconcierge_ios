//
//  PromotionsCell.swift
//  Clikat
//
//  Created by Night Reaper on 26/04/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import Material

class PromotionsCell: TableViewCell {


    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDetail: UILabel!
    @IBOutlet var imgView: UIImageView!

    
    var promotion : Promotion? {
        didSet{
            updateUI()
        }
    }
    
    private func updateUI(){
    
        defer {
            lblTitle?.text = promotion?.promotionName
            lblDetail?.text = (Double(/promotion?.promotionPrice))?.addCurrencyLocale
        }
//        guard let image = promotion?.promotionImage , let url = URL(string: image) else{
//            return
//        }
//        imgView?.yy_setImage(with: url, options: [.setImageWithFadeAnimation])
        imgView?.loadImage(thumbnail: promotion?.promotionImage, original: nil)

    }

}
