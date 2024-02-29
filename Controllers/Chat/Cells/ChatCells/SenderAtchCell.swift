//
//  SenderAtchCell.swift
//  NequoreUser
//
//  Created by MAC_MINI_6 on 07/08/18.
//

import UIKit

class SenderAtchCell: BaseChatCell {

  @IBOutlet weak var lblAtchName: UILabel!
  
  override func awakeFromNib() {
    lblAtchName.isUserInteractionEnabled = true
    lblAtchName.addTapGesture { (_) in
      UIApplication.topViewController()?.openSafariVC(/self.item?.attachement?.url)
    }
  }
  
  override func setUpData() {
    super.setUpData()
    lblAtchName.text = /item?.attachement?.fileName
  }
  
}
