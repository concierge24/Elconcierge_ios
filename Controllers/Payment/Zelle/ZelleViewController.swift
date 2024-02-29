//
//  ZelleViewController.swift
//  Sneni
//
//  Created by Harminder on 31/03/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit

class ZelleViewController: UIViewController {
    
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var lblPaymentDetails: UILabel!{
        didSet{
            if let term = TerminologyKeys.paymentDetails.localizedValue() as? String, !term.isEmpty {
                self.lblPaymentDetails.text = term + "."
            }
        }
    }
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var imageReceipt: UIImageView!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var btnUploadReceipt: UIButton!{
        didSet{
            if let term = TerminologyKeys.choosePaymentReceipt.localizedValue() as? String, !term.isEmpty {
                self.btnUploadReceipt.setTitle(term, for: .normal)
            }else{
                self.btnUploadReceipt.setTitle("UPLOAD PAYMENT RECEIPT", for: .normal)
            }
        }
    }
    
    //MARK::- PROPERTIES
    var email = ""
    var phone = ""
    var selectedImage: ((_ image: String, _ image: UIImage) -> ())?
    
    //MARK::- VIEW CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        self.modalPresentationStyle = .currentContext

        if let term = TerminologyKeys.email.localizedValue() as? String, !term.isEmpty {
                           self.lblEmail?.text = "1. " + term  + " " + /email
        }else{
           lblEmail?.text = "Email : ".localized() + /email
        }
        if let term = TerminologyKeys.shareScreenshot.localizedValue() as? String, !term.isEmpty {
                           self.lblPhone?.text = "2. " + term
        }else{
            lblPhone?.text = "Phone Number : ".localized() + /phone
        }

    }
    
    //MARK::- FUNCTIONS
    
    func openImagePicker(){
        if UtilityFunctions.isCameraPermission() {
            UtilityFunctions.showActionSheet(withTitle: nil, subTitle: L10n.SelectPicture.string, vc: self, senders: [L10n.Camera.string,L10n.PhotoLibrary.string]) { (text, index) in
                
                CameraGalleryPickerBlock.sharedInstance.pickerImage(type: text as! String, presentInVc: self, pickedListner: { [weak self] (image) in
                    self?.imageReceipt.image = image
                    self?.upload(image: image)
                }) {
                    //Cancelled
                }
            }
        }else {
            UtilityFunctions.alertToEncourageCameraAccessWhenApplicationStarts(viewController: self)
        }
    }
    
    
    func upload(image: UIImage){
        
        APIManager.sharedInstance.opertationWithRequest(withApi: API.UploadReceipt(FormatAPIParameters.UploadReceipt.formatParameters()), image: image.resize(toWidth:300)) {
            [weak self] (response) in
            switch response {
            case .Success(let object):
                
                if let imageUrl = object as? String {
                    self?.selectedImage?(imageUrl, image)
                    self?.dismiss(animated: true, completion: nil)
                }
                
                
            default:
                break
            }
        }
    }
    
    //MARK::- ACTIONS
    @IBAction func btnACtionChooseReceipt(_ sender: UIButton) {
        openImagePicker()
    }
    
}
