//
//  PickupDateCell.swift
//  Clikat
//
//  Created by cblmacmini on 5/21/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

class PickupDateCell: ThemeTableCell {

    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    
    var pickupDate : Date?{
        didSet{
            guard let date = pickupDate else { return }
            labelDate.text = UtilityFunctions.getDateFormatted(format: DateFormat.DateFormatUI, date: date)
            labelTime.text = UtilityFunctions.getTimeFormatted(format: DateFormat.TimeFormatUI, date: date)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
