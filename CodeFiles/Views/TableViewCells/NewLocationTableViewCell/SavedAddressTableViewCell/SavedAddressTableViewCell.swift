//
//  SavedAddressTableViewCell.swift
//  Sneni
//
//  Created by Apple on 29/08/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class SavedAddressTableViewCell: UITableViewCell {

    //MARK:- IBOutlet
    @IBOutlet weak var more_button: UIButton!
    @IBOutlet weak var address_label: UILabel!
    @IBOutlet weak var addressType_label: UILabel!
    @IBOutlet weak var sideImage_imageView: UIImageView! {
        didSet{
            sideImage_imageView.tintColor = SKAppType.type.color
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
