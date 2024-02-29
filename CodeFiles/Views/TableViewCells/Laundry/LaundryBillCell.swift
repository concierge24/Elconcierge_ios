//
//  LaundryBillCell.swift
//  Clikat
//
//  Created by cblmacmini on 6/10/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

class LaundryBillCell: ThemeTableCell {

    @IBOutlet weak var labelNetTotal: UILabel!
    
    var laundryOrder : LaundryProductListing?{
        didSet{
            updateUI()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateUI(){
        
    }
}
