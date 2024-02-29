//
//  TimeSlotCell.swift
//  Appt
//
//  Created by Agustin Mendoza Romo on 8/8/17.
//  Copyright © 2017 AgustinMendoza. All rights reserved.
//

import UIKit

class TimeSlotCell: UICollectionViewCell {
    
    //MARK:- ======== Outlets ========
    @IBOutlet weak var lblTitle: UILabel!
    
    //MARK:- ======== Variables ========
    var date: Date? {
        didSet {
            lblTitle.text = date?.toString(format: Formatters.HHMMA)
        }
    }
    var isSelect: Bool = false {
        didSet {
            backgroundColor = isSelect ? SKAppType.type.color : .white
            lblTitle.textColor = isSelect ? .white : SKAppType.type.elementColor
            self.layer.borderColor = (isSelect ? .white : SKAppType.type.grayTextColor).withAlphaComponent(0.5).cgColor
        }
    }
    
    //MARK:- ======== LifeCycle ========
    override func awakeFromNib() {
        super.awakeFromNib()
       // super.borderColor = SKAppType.type.color
    }
    
}
