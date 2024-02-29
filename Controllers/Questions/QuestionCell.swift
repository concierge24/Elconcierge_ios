//
//  QuestionCell.swift
//  Sneni
//
//  Created by Daman on 02/04/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit

class QuestionCell: UITableViewCell {

    @IBOutlet var btnQuestion: UIButton! {
        didSet {
            btnQuestion.adjustImageAndTitleOffsetsForButton(space: 16)
        }
    }
    @IBOutlet var lblPrice: ThemeLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnQuestion.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(_ model: QuestionOption, multiSelect: Bool, productPrice: Double?) {
        btnQuestion.setTitle(model.optionLabel, for: .normal)
        lblPrice.text = model.displayValue(productPrice: productPrice)
        btnQuestion.isSelected = model.isSelected
        
        if multiSelect {
            
        }
        else {
            btnQuestion.setImage(UIImage(named: "ic_radio_icon"), for: .normal)
            btnQuestion.setImage(UIImage(named:"ic_radio_checked"), for: .selected)
        }
        
        btnQuestion.borderColor = UIColor.clear
        if model.isSelected {
            //btnQuestion.backgroundColor = SKAppType.type.color
            //btnQuestion.setTitleColor(UIColor.white, for: .normal)
            //btnQuestion.borderColor = SKAppType.type.color
        }
        else {
           // btnQuestion.backgroundColor = UIColor.groupTableViewBackground
            //btnQuestion.setTitleColor(UIColor.black, for: .normal)
            //btnQuestion.borderColor = UIColor.lightGray
        }
    }

}
