//
//  LaundrySupplierInfoCell.swift
//  Clikat
//
//  Created by cblmacmini on 6/10/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

class LaundrySupplierInfoCell: ThemeTableCell {

    var laundry : LaundryProductListing?{
        didSet{
            updateUI()
        }
    }
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelProduct: UILabel!{
        didSet{
            labelProduct.layer.cornerRadius = 4.0
        }
    }
    @IBOutlet weak var labelAddress: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
     }
    
    func updateUI(){
        
        labelName.text = laundry?.supplierName
        labelAddress.text = laundry?.supplierAddress
    }
}
