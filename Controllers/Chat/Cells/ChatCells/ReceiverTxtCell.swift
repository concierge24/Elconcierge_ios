//
//  ReceiverTxtCell.swift
//  NequoreUser
//
//  Created by MAC_MINI_6 on 04/08/18.
//

import UIKit

class ReceiverTxtCell: BaseChatCell {
  
  @IBOutlet weak var lblMessage: UILabel!
  
  override func setUpData() {
    super.setUpData()
    lblMessage.text = /item?.message
  }
    
}
