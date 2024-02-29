//
//  RentalSupplierListingTableViewCell.swift
//  Sneni
//
//  Created by Apple on 01/11/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class RentalSupplierListingTableViewCell: UITableViewCell {

    @IBOutlet weak var favourite_button: UIButton!
    //MARK:- IBOutlet
    @IBOutlet weak var carName_label: UILabel!
    @IBOutlet weak var supplierName_label: UILabel!
    @IBOutlet weak var address_label: UILabel!
    @IBOutlet weak var rating_label: UILabel!
    @IBOutlet weak var productImage_imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
