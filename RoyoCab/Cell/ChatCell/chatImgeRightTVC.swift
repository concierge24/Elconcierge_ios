//
//  chatImgeRightTVC.swift
//  Buraq24Driver
//
//  Created by Apple on 08/08/19.
//  Copyright © 2019 OSX. All rights reserved.
//

import UIKit

class chatImgeRightTVC: UITableViewCell {

    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imgeViewRight: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewBG.setViewBackgroundColorHeader()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
