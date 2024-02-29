//
//  ReceiverImgCell.swift
//  NequoreUser
//
//  Created by MAC_MINI_6 on 06/08/18.
//

import UIKit
 

class ReceiverImgCell: BaseChatCell {
    
    //MARK::- OUTLETS
    @IBOutlet weak var labelPropertyName: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var viewVideoDim: UIImageView!
    @IBOutlet weak var imgPlay: UIImageView!
    
    //MARK::- FUNCTIONS
    override func setUpData() {
        super.setUpData()
        labelPropertyName?.text = item?.type == .Property ? item?.message : ""
        viewVideoDim.isHidden = (item?.type ?? .Image) == .Image
        viewVideoDim.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2)
        viewVideoDim.alpha = 0.3
//        imgView.setImage(image: (item?.type ?? .Image) == .Image ? item?.image?.image : item?.video?.thumbnail)
        imgPlay.isHidden = (item?.type ?? .Image) == .Image
        if item?.type == .Property{
            viewVideoDim.isHidden = false
            imgPlay.isHidden = true
        }
    }
}
