//
//  SenderTxtCell.swift
//  NequoreUser
//
//  Created by MAC_MINI_6 on 04/08/18.
//

import UIKit

class SenderTxtCell: BaseChatCell {
    
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var viewBg: UIView!{
        didSet{
            viewBg?.backgroundColor = SKAppType.type.color
        }
    }
    @IBOutlet weak var viewBgS: UIView!{
        didSet{
            viewBgS?.backgroundColor = SKAppType.type.color
        }
    }

    override func setUpData() {
        super.setUpData()
        lblMessage.text = /item?.message
        self.updateConstraints()
        self.layoutIfNeeded()
        //    self.reloadInputViews()
    }
    
}
