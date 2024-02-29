//
//  ReceiverAtchCell.swift
//  NequoreUser
//
//  Created by MAC_MINI_6 on 07/08/18.
//

import UIKit

class ReceiverAtchCell: BaseChatCell {

  @IBOutlet weak var lblAtchName: UILabel!
  
  override func setUpData() {
    super.setUpData()
    lblAtchName.text = /item?.attachement?.fileName
  }
}
