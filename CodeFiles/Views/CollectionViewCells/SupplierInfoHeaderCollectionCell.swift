//
//  SupplierInfoHeaderCollectionCell.swift
//  Clikat
//
//  Created by cblmacmini on 5/3/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

class SupplierInfoHeaderCollectionCell: ThemeCollectionViewCell {

    @IBOutlet weak var imageViewCover: UIImageView!{
        didSet {
            //imageViewCover?.backgroundColor = Colors.lightGrayBackgroundColor.color()
        }
    }
    @IBOutlet weak var imageViewBlur: UIImageView!
    @IBOutlet weak var btnPlay: UIButton!
    

}
