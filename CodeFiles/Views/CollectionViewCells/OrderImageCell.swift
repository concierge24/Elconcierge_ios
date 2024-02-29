//
//  OrderImageCell.swift
//  Clikat
//
//  Created by cbl73 on 4/23/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import Material

class OrderImageCell: ThemeCollectionViewCell {

    
    var product : ProductF? {
        didSet{
            updateUI()
        }
    }
    
    @IBOutlet weak var imgOrder: UIImageView!

    
    private func updateUI(){
        imgOrder.loadImage(thumbnail: product?.image, original: nil)
    }
    

}
