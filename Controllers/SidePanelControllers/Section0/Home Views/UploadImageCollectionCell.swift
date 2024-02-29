//
//  UploadImageCollectionCell.swift
//  Sneni
//
//  Created by Daman on 26/03/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit
import EZSwiftExtensions

typealias ImagePickedBlock = (UIImage, String) -> ()
typealias ImageLimitBlock = () -> (Bool, Int)

class UploadImageCollectionCell: UICollectionViewCell {

    @IBOutlet var imgView: UIImageView!
    @IBOutlet var bthCross: UIButton!
    @IBOutlet var btnAdd: UIButton! {
        didSet {
            btnAdd.backgroundColor = SKAppType.type.color.withAlphaComponent(0.3)
        }
    }
    
    var imageDeleteBlock: EmptyBlock?
    var imagePickedBlock: ImagePickedBlock?
    var imageLimitBlock: ImageLimitBlock?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(_ obj: UploadImage) {
    
        if obj.isPlaceholder {
            bthCross.isHidden = true
            btnAdd.isHidden = false
            imgView.image = UIImage()
        }
        else {
            bthCross.isHidden = false
            btnAdd.isHidden = true
            if let img = obj.image {
                imgView.image = img
            }
            else if let url = obj.imageUrl {
                //load from url
                imgView?.loadImage(thumbnail: nil, original: url)
            }
        }
    }
    
    @IBAction func addImage(_ sender: Any) {
        if let (limitReached, maxCount) = imageLimitBlock?(), limitReached {
            SKToast.makeToast(String(format: "Cannot upload more than %@ images", "\(maxCount)"))
            return
        }
        openImagePicker()
    }
    
    @IBAction func deleteImage(_ sender: Any) {
        imageDeleteBlock?()
    }
    
    func openImagePicker(){
        guard let vc = ez.topMostVC else  { return }
        if UtilityFunctions.isCameraPermission() {
            UtilityFunctions.showActionSheet(withTitle: nil, subTitle: L10n.SelectPicture.string, vc: vc, senders: [L10n.Camera.string,L10n.PhotoLibrary.string]) { (text, index) in
                
                CameraGalleryPickerBlock.sharedInstance.pickerImage(type: text as! String, presentInVc: vc, pickedListner: { [weak self] (image) in
                   self?.uploadReceipt(image: image)
                }) {
                    //Cancelled
                }
            }
        }else {
            UtilityFunctions.alertToEncourageCameraAccessWhenApplicationStarts(viewController: vc)
        }
    }
    
    func uploadReceipt(image: UIImage) {
          APIManager.sharedInstance.opertationWithRequest(withApi: API.UploadReceipt(FormatAPIParameters.UploadReceipt.formatParameters()), image: image.resize(toWidth:300)) {
                     [weak self] (response) in
             switch response {
             case .Success(let object):
              if let imageUrl = object as? String {
                  self?.imagePickedBlock?(image, imageUrl)
              }
             default:
                 break
             }
         }
        
      }
      
}
