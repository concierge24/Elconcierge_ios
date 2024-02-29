//
//  LiveSupportChatCell.swift
//  Clikat
//
//  Created by cblmacmini on 5/28/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import Material

class LiveSupportChatCell: ThemeTableCell {

    
    @IBOutlet weak var labelBgView: View!
    @IBOutlet weak var labelMessage: UILabel!{
        didSet{
            labelMessage.preferredMaxLayoutWidth = ScreenSize.SCREEN_WIDTH - 64
        }
    }
    var message : Message?{
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

        // Configure the view for the selected state
    }
    func updateUI(){
        labelMessage.text = message?.message
    }
}
