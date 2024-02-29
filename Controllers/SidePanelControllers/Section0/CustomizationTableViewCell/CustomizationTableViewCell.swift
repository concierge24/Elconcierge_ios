//
//  CustomizationTableViewCell.swift
//  Sneni
//
//  Created by Apple on 26/09/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class CustomizationTableViewCell: UITableViewCell {
    
    //MARK:- IBOutlet
    @IBOutlet weak var sideImage: UIImageView!
    @IBOutlet weak var selection_button: UIButton!
    @IBOutlet weak var price_label: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var name_label: UILabel!
    @IBOutlet weak var quantity_label: UILabel!
    @IBOutlet weak var selection_view: UIView!
    
    var actionMinusBlock: (() -> Void)? = nil
    var actionPlusBlock: (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didTapButton(sender: UIButton) {
       
    }
    @IBAction func didTapMinusButton(sender: UIButton) {
        actionMinusBlock?()
    }
    @IBAction func didTapPlusButton(sender: UIButton) {
        actionPlusBlock?()
    }
}
