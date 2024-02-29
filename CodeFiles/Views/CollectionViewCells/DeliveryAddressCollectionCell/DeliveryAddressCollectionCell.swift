//
//  DeliveryAddressCollectionCell.swift
//  Clikat
//
//  Created by cblmacmini on 5/19/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

class DeliveryAddressCollectionCell: ThemeCollectionViewCell {

    @IBOutlet weak var viewBg : UIView!
    @IBOutlet weak var labelAdresseeName: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var imageViewSelected: UIImageView!
    
    var address : Address?{
        didSet{
           updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        isSelected = false
    }
    
    func updateUI(){
        guard let currentAddress = address else { return }
        if currentAddress.name ?? "" == "" {
            labelAdresseeName.text = currentAddress.area ?? ""
        } else {
            labelAdresseeName?.text = currentAddress.name
        }
        
        labelAddress.text = currentAddress.address ?? ""
        //labelAddress?.text = currentAddress.addressString
    }
}
