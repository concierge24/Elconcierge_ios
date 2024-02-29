//
//  chatImageLeftCell.swift
//  Buraq24Driver
//
//  Created by Apple on 08/08/19.
//  Copyright © 2019 OSX. All rights reserved.
//

import UIKit

class chatImageLeftCell: UITableViewCell {

    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imgeViewLeft: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewBg.setViewBackgroundColorHeader()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
