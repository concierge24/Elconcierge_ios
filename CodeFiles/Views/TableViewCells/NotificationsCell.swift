//
//  NotificationsCell.swift
//  Clikat
//
//  Created by Night Reaper on 26/04/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import Material

class NotificationsCell: ThemeTableCell {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var imgView: UIImageView!
    
    var notification : NotificationClass?{
        didSet{
        updateUI()
        }
    }
    
    func updateUI(){
        lblTitle.text = notification?.message
        
        imgView.loadImage(thumbnail: notification?.image, original: nil)
    }
}
