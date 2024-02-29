//
//  SideMenuCell.swift
//  Clikat
//
//  Created by Night Reaper on 15/04/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

class SideMenuCell: ThemeTableCell {
    
    @IBOutlet var imgIcon: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    
    var menuItem : GenericMenu?{
        didSet{
            updateUI()
        }
    }
    
    
    private func updateUI(){
        defer{
            lblTitle?.text = menuItem?.getTitle() ?? ""
            
            lblTitle.textColor = LabelThemeColor.shared.lblMenuTitleClr
        }
        
        guard let image = menuItem?.getImageName() else{
            return
        }
        imgIcon?.image = UIImage(asset: image)
        
        self.backgroundColor = UIColor.clear
    }
    
    
}

