//
//  SenderImgCell.swift
//  NequoreUser
//
//  Created by MAC_MINI_6 on 06/08/18.
//

import UIKit


protocol DelegateUploadItem: class {
    func uploadItem(index: Int)
}

class SenderImgCell: BaseChatCell {
    
    //MARK::- OUTELTS
    @IBOutlet weak var labelPropertyName: UILabel!
    @IBOutlet weak var imgPlay: UIImageView!
    @IBOutlet weak var btnUpload: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var indicatorUploading: UIActivityIndicatorView!
    @IBOutlet weak var viewVideoDim: UIImageView!
    
    //MARK::- PROPERTIES
    var delegate: DelegateUploadItem?
    
    
    //MARK::- VIEW CYCLE
    override func setUpData() {
        super.setUpData()
        labelPropertyName?.text = item?.type == .Property ? item?.message : ""
//        imgView.setImage(image: (item?.type ?? .Image) == .Image ? item?.image?.image : item?.video?.thumbnail)
        viewVideoDim.isHidden = (item?.type ?? .Image) == .Image
        viewVideoDim.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2)
        viewVideoDim.alpha = 0.3
        btnUpload?.isEnabled = false
        indicatorUploading.isHidden = true
        indicatorUploading.stopAnimating()
        if !(/item?.uploaded){
            if /item?.isFail{
                btnUpload.isEnabled = true
                imgPlay.isHidden = false
//                imgPlay.setImage(image: R.image.ic_upload())
                indicatorUploading.stopAnimating()
                indicatorUploading.isHidden = true
            }else{
                imgPlay.isHidden = true
                indicatorUploading.startAnimating()
                indicatorUploading.isHidden = false
            }
        }else{
            imgPlay.isHidden = (item?.type ?? .Image) == .Image
//            imgPlay.setImage(image: R.image.ic_play_video())
            indicatorUploading.isHidden = true
        }
        
        if item?.type == .Property{
            viewVideoDim.isHidden = false
            imgPlay.isHidden = true
        }
        
    }
    
    //MARK::- ACTION
    
    @IBAction func btnActionUpload(_ sender: UIButton) {
        delegate?.uploadItem(index: btnUpload.tag)
    }
}
