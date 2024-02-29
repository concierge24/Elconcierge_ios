//
//  CardTVC.swift
//  Buraq24
//
//  Created by Apple on 18/08/19.
//  Copyright © 2019 CodeBrewLabs. All rights reserved.
//

import UIKit

class CardTVC: UITableViewCell {

    @IBOutlet weak var lblCard: UILabel!
//    @IBOutlet weak var btnDeleteCell: UIButton!
    @IBOutlet weak var outerView: UIView!
    
    var completionHandler : (()  -> Void)?
    var cardId: String?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

