//
//  AddAddressTableViewCell.swift
//  Sneni
//
//  Created by Apple on 29/08/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class AddAddressTableViewCell: UITableViewCell {

    @IBOutlet weak var title_label: ThemeLabel!
    @IBOutlet weak var sideImage_imageView: UIImageView!{
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
