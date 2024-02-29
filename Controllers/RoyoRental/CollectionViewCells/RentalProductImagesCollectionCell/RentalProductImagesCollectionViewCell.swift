//
//  RentalProductImagesCollectionViewCell.swift
//  Sneni
//
//  Created by Apple on 02/11/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class RentalProductImagesCollectionViewCell: UICollectionViewCell {

    //MARK:- IBOutlet
    @IBOutlet weak var productImage_imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let degrees: CGFloat = 2.0 //the value in degrees
        let radians: CGFloat = degrees * (.pi / 180)
        productImage_imageView.transform = CGAffineTransform(rotationAngle: radians)
       // productImage_imageView.transform = CGAffineTransform(translationX: -5, y: -5)

    }

}
