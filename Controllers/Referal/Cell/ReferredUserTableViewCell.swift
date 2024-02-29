//
//  ReferredUserTableViewCell.swift
//  Sneni
//
//  Created by Gagandeep Singh on 17/03/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit

class ReferredUserTableViewCell: UITableViewCell {

    //MARK::- OUTLETS
    @IBOutlet weak var labelUserName: ElementLabel!
    @IBOutlet weak var lblPrice: ElementLabel!
    @IBOutlet weak var imageUser: UIImageView!
    
    
    //MARK::- PROPERTIES
    var user : User?{
        didSet{
            labelUserName?.text = /user?.firstName + " " + /user?.last_name
            lblPrice?.text = Double(user?.receive_price ?? 0.0).addCurrencyLocale
            imageUser.loadImage(thumbnail: /user?.userImage, original: nil, placeHolder: Asset.ic_dummy_user.image)
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
