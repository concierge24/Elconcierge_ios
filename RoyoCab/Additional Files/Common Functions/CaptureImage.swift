//
//  CaptureImage.swift
//  Untap
//
//  Created by Sierra 3 on 19/04/17.
//  Copyright © 2017 CB Neophyte. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import Permission

class CameraImage: NSObject {
  
  static var shared = CameraImage()
  var fromVC: UIViewController?
  var complete:((_ image: UIImage?) -> Void)?
  var completeVideoCallback:((_ videoUrl: URL?,_ videoData:Data?,_ thumbnail:UIImage?) -> Void)?
  var permission:Permission?
    var atView:NSObject?
    
 
    func captureImage(from vc: UIViewController, At view : NSObject ,mediaType:[String]?, captureOptions sources: [UIImagePickerController.SourceType], allowEditting crop: Bool, callBack: ((_ image: UIImage?) -> Void)?) {
    
    self.fromVC = vc
    self.complete = callBack
    self.completeVideoCallback = nil
    self.atView = view
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.allowsEditing = crop
    imagePicker.modalPresentationStyle = .popover
    imagePicker.popoverPresentationController?.sourceView = self.atView as? UIView
    if mediaType != nil{
      imagePicker.mediaTypes = mediaType ?? []
    }
        
    if sources.count > 1 {
      openActionSheet(with: imagePicker, sources: sources)
    }
    else {
      let source = sources[0]
      if source == .camera && cameraExists {
        imagePicker.sourceType = source
      }
      vc.present(imagePicker, animated: true, completion: nil)
    }
  }
  
    func captureVideo(from vc: UIViewController,mediaType:[String]?, captureOptions sources: [UIImagePickerController.SourceType], allowEditting crop: Bool, completeVideoCallback:((_ videoUrl: URL?,_ videoData:Data?,_ thumbnail:UIImage?) -> Void)?) {
    self.fromVC = vc
    self.completeVideoCallback = completeVideoCallback
    self.complete = nil
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.allowsEditing = crop
    if mediaType != nil{
      imagePicker.mediaTypes = mediaType ?? []
    }
    
    if sources.count > 1 {
      openActionSheet(with: imagePicker, sources: sources)
    }
    else {
      let source = sources[0]
      if source == .camera && cameraExists {
        imagePicker.sourceType = source
      }
      vc.present(imagePicker, animated: true, completion: nil)
    }
  }
  
    func openActionSheet(with imagePicker: UIImagePickerController, sources: [UIImagePickerController.SourceType]) {
    
    let actionSheet = UIAlertController(title: "dialog_select_your_choice".localizedString , message: nil, preferredStyle: .actionSheet)
    actionSheet.view.tintColor = UIColor.darkGray
    actionSheet.modalPresentationStyle = .popover
//    actionSheet.popoverPresentationController?.sourceView = self.fromVC?.view
    actionSheet.popoverPresentationController?.sourceView = self.atView as? UIView
    
    for source in sources {
      let action = UIAlertAction(title: source.name, style: .default, handler: { (action) in
        
        switch source{
        case .camera:
          
          CheckPermission.shared.type(.camera, completion: {
            imagePicker.sourceType = source
            self.fromVC?.present(imagePicker, animated: true, completion: nil)
          })
          
        case .photoLibrary:
          CheckPermission.shared.type(.photos, completion: {
            imagePicker.sourceType = source
            self.fromVC?.present(imagePicker, animated: true, completion: nil)
          })
        default:
          break
        }
        self.permission?.request { status in
          switch status {
          case .authorized:    print("authorized")
          case .denied:        print("denied")
          case .disabled:      print("disabled")
          case .notDetermined: print("not determined")
          }
        }
        
      })
      if source == .camera {
        if cameraExists{  actionSheet.addAction(action) }
      }
      else {
        actionSheet.addAction(action)
      }
    }
    let cancel = UIAlertAction(title: "cancel".localizedString , style: .cancel) { (action) in
    }
    if #available(iOS 10.0, *) {
      cancel.setValue(UIColor(displayP3Red: 0, green: 122/255, blue: 255/255, alpha: 1), forKey: "titleTextColor")
    } else {
      // Fallback on earlier versions
    }
    actionSheet.addAction(cancel)
    fromVC?.present(actionSheet, animated: true, completion: nil)
  }
}

extension CameraImage: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  var cameraExists: Bool {
    let front = UIImagePickerController.isCameraDeviceAvailable(.front)
    let rear = UIImagePickerController.isCameraDeviceAvailable(.rear)
    return front || rear
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    guard let callBack = complete else {
      picker.dismiss(animated: true, completion: nil)
      return
    }
    callBack(nil)
    picker.dismiss(animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    var image: UIImage? = nil
    
   /* guard let edittedImage = info[.editedImage] as? UIImage else {
        fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
    }
    
    guard let fullImage = info[.originalImage] as? UIImage else {
        fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
    } */
    
    if let edittedImage = info[.editedImage] as? UIImage {
      image = edittedImage
    }
    
    else if let fullImage = info[.originalImage] as? UIImage{
      image = fullImage
    }
    
    
    if complete == nil && completeVideoCallback == nil{
      picker.dismiss(animated: true, completion: nil)
      return
    }else if complete == nil{
     
        if let _ = completeVideoCallback {
       // let _  : URL = info[UIImagePickerControllerMediaURL] as! URL
       // let chosenVideo = info[UIImagePickerControllerMediaURL] as! URL
        //let videoData = try! Data(contentsOf: chosenVideo, options: [])
      }
    }else if completeVideoCallback == nil{
      if let callBack = complete {
        callBack(image)
      }
    }
    
    picker.dismiss(animated: true, completion: nil)
  }
}

extension UIImagePickerController.SourceType {
  
  var name: String {
    
    switch self {
    case .camera:
        
//        "dialog_camera"  = "من الكاميرا";
//        "dialog_gallery"  = "من الصور";
//        "dialog_select_your_choice"  = "حدد الخيار";
      return "dialog_camera".localizedString
      
    case .photoLibrary:
        return "dialog_gallery".localizedString

    case .savedPhotosAlbum:
        return "dialog_gallery".localizedString

    }
  }
}


