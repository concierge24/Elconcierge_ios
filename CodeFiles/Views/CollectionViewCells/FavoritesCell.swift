//
//  FavoritesCell.swift
//  Clikat
//
//  Created by Night Reaper on 26/04/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import Material

class FavoritesCell: ThemeCollectionViewCell {
    
    var supplier : Supplier?{
        didSet{
            updateUI()
        }
    }
    
    @IBOutlet var imgFav: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var viewBg: UIView!
    
    private func updateUI(){
        
        defer{
            lblTitle?.text = supplier?.name
            lblPrice?.text = supplier?.address
        }
        imgFav.loadImage(thumbnail: supplier?.logo, original: nil)
    }
    
}
