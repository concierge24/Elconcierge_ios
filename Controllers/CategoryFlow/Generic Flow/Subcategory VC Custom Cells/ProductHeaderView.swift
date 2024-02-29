//
//  ProductHeaderView.swift
//  Sneni
//
//  Created by Apple on 22/06/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class ProductHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var lblHeaderView: UILabel! {
        didSet {
            lblHeaderView.text = L10n.ShopByType.string
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

