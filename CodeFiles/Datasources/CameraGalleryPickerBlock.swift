//
//  CameraGalleryPickerBlock.swift
//  Naseeb
//
//  Created by Night Reaper on 30/09/15.
//  Copyright (c) 2015 Gagan. All rights reserved.
//

import UIKit

class CameraGalleryPickerBlock: NSObject , UIImagePickerControllerDelegate , UINavigationControllerDelegate{
   
    typealias onPicked = (UIImage) -> ()
    typealias onCanceled = () -> ()
    
    
    var pickedListner : onPicked?
    var canceledListner : onCanceled?
    
    static let sharedInstance = CameraGalleryPickerBlock()
    
    override init(){
        super.init()
        
    }
    
    deinit{
        
    }
    
    
    func pickerImage(type : String , presentInVc : UIViewController , pickedListner : @escaping onPicked , canceledListner : @escaping onCanceled) {
       
        self.pickedListner = pickedListner
        self.canceledListner = canceledListner
        
        let picker : UIImagePickerController = UIImagePickerController()
        
        if type == CameraMode.Camera && !(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            SKToast.makeToast("Device has no camera.")
        }
        else{
            picker.sourceType = type == CameraMode.Camera ? .camera : .photoLibrary
            picker.delegate = self
            picker.allowsEditing = false
            presentInVc.present(picker, animated: true, completion: nil)
        }
                
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        if let listener = canceledListner{
            listener()
        }
    }
    
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image : UIImage = info[.originalImage] as? UIImage , let listener = pickedListner{
            listener(image)
        }
    }
    
}
