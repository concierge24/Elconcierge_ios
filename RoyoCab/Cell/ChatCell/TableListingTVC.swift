//
//  TableListingTVC.swift
//  Buraq24
//
//  Created by Apple on 07/08/19.
//  Copyright © 2019 CodeBrewLabs. All rights reserved.
//

import UIKit

class TableListingTVC: UITableViewCell {

    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        

    }

}
