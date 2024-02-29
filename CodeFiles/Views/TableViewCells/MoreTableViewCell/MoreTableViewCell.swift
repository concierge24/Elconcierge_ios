//
//  MoreTableViewCell.swift
//  Sneni
//
//  Created by Apple on 21/08/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class MoreTableViewCell: UITableViewCell {

    @IBOutlet weak var titleIcon_imageView: UIImageView!
    @IBOutlet weak var title_label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
