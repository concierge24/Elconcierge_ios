
//
//  SearchTableViewCell.swift
//  Sneni
//
//  Created by MAc_mini on 16/02/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class SearchTableViewCell: ThemeTableCell {
    
    @IBOutlet weak var lblSearchTitle: UILabel!
    
    var searchString : String!{
        didSet{
            updateUI()
        }
    }
   
    private func updateUI(){
       
     lblSearchTitle.text = searchString
        
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
