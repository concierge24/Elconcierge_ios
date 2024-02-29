//
//  BaseChatCell.swift
//  NequoreUser
//
//  Created by MAC_MINI_6 on 04/08/18.
//

import UIKit

class BaseChatCell: UITableViewCell {
  
  @IBOutlet weak var lblTime: UILabel!
    
  var item: MessageChat? {
    didSet {
      setUpData()
    }
  }
  
  func setUpData() {
    lblTime?.text = item?.time
  }
  
}
