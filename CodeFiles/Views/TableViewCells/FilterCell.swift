//
//  FilterCell.swift
//  Clikat
//
//  Created by Night Reaper on 18/05/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

class FilterCell: ThemeTableCell {

    @IBOutlet var viewBg: UIView!
   // let colorTheme = ColorTheme()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var isBgSelected : Bool = false {
        didSet{
            if (isBgSelected) {
               // viewBg.backgroundColor = Colors.MainColor.color()
              
                viewBg.backgroundColor = ViewThemeColor.shared.viewThemeColor
                textLabel?.textColor = UIColor.white
            }
            else {
                
                viewBg.backgroundColor = TableThemeColor.shared.cellThemeColor
               // textLabel?.textColor = ColorTheme.shared.textThemeColor
               // textLabel?.textColor = Colors.MainColor.color()
                
            }
        }
    }
   
}
