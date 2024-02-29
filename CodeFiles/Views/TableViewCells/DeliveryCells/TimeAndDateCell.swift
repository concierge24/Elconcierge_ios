//
//  TimeAndDateCell.swift
//  Clikat
//
//  Created by cblmacmini on 5/19/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import RMDateSelectionViewController

class TimeAndDateCell: ThemeTableCell {

    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var btnTime: UIButton!
    
    var selectedDate : Date?{
        didSet{
            updateUI()
        }
    }
  
    @IBAction func actionPickDate(sender: UIButton) {
        
    }

    @IBAction func actionPickTime(sender: UIButton) {
        
    }
    
    func updateUI(){
        guard let date = selectedDate else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd EEEE"
        btnDate.setTitle(dateFormatter.string(from: date), for: .normal)
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h : mm a"
        btnTime.setTitle(timeFormatter.string(from: date), for: .normal)
    }
}
