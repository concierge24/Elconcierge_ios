//
//  BrandETokenCell.swift
//  Buraq24
//
//  Created by MANINDER on 02/11/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit
typealias  item = (_ item : Int) -> ()

class BrandETokenCell: UITableViewCell {
    
    //MARK:- Outlets
    @IBOutlet var lblTotalToken: UILabel!
    @IBOutlet var lblTokenValue: UILabel!
    @IBOutlet var lblTokenPrice: UILabel!
    
    @IBOutlet var btnBuyToken: UIButton!
    @IBOutlet var viewGredient: UIView!
    
        var callBackBtn : item?
    
 //MARK:- View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    //MARK:- Actions
    
    @IBAction func actionBtnBuy(_ sender: Any) {
        
          guard  let callback = callBackBtn else{return}
        callback(0)
    }
    
}
