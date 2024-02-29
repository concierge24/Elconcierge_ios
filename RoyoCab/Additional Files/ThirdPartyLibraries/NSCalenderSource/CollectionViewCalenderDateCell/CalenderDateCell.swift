//
//  CalenderDateCell.swift
//  SNCalenderView
//
//  Created by OSX on 05/06/18.
//  Copyright © 2018 OSX. All rights reserved.
//

import UIKit

class CalenderDateCell: UICollectionViewCell {
    
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblDate: UILabel!

    func configureCollectionViewCell(day :  String? , date : String?) {
      
      if (day == "Sat") || (day == "Sun"){
        self.lblDay.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        self.lblDate.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
      }
      
        lblDay.text = day
        lblDate.text = date
        
    } 

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
