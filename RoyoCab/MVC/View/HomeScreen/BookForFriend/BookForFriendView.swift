//
//  BookForFriendView.swift
//  Trava
//
//  Created by Apple on 27/11/19.
//  Copyright © 2019 CodeBrewLabs. All rights reserved.
//

import Foundation
import UIKit
import IBAnimatable

class BookForFriendView: UIView {
    
    //MARK:- Outlets
    //MARK:-
    
    @IBOutlet weak var textfieldPhoneNumber: UITextField!
    @IBOutlet weak var textfieldFullName: AnimatableTextField!
    
    @IBOutlet var imgViewCountryCode: UIImageView!
    @IBOutlet var lblCountryCode: UILabel!
    @IBOutlet weak var buttonContinue: UIButton!
    @IBOutlet weak var btnCountryCode: UIButton!
    
    
    var ISO: String?
    var viewSuper : UIView?
    
    //MARK:- Properties
    //MARK:-
    
    var isAdded : Bool = false
    var request : ServiceRequest = ServiceRequest()
    var frameHeight : CGFloat = 342
    var delegate : BookRequestDelegate?
    
    //MARK:- Actions
    //MARK:-
    
    @IBAction func actionBtnBookPressed(_ sender: UIButton) {
        
        validateFields()
        
      /*  //        if /request.serviceSelected?.serviceCategoryId != 1 {
        //           alertBoxOk(message:"work_in_progress".localizedString , title: "AppName".localizedString, ok: {
        //            })
        //            return
        //        }else{
        
        minimizeConfirmPickUPView()
        delegate?.didClickConfirmPickup()
        
        // Ankush self.delegate?.didSelectNext(type: .SubmitOrder)
        // } */
        
    }
    
    @IBAction func actionBtnCountryCode(_ sender: UIButton) {
        
        guard let countryPicker = R.storyboard.mainCab.countryCodeSearchViewController() else{return}
        countryPicker.delegate = self
        ez.topMostVC?.presentVC(countryPicker)
    }
    
    //MARK:- Functions
    //MARK:-
    
    func minimizeBookForFriendView() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.frame = CGRect(x: BookingPopUpFrames.XPopUp, y: /self?.viewSuper?.frame.origin.y + /self?.viewSuper?.frame.size.height , width: BookingPopUpFrames.WidthPopUp, height: /self?.frameHeight)
            
            }, completion: { (done) in
        })
    }
    
    func maximizeBookForFriendView() {
        
        
        btnCountryCode.setButtonWithTitleAndBorderColorSecondary()
        textfieldPhoneNumber.setBorderColorSecondary()
        textfieldPhoneNumber.addLeftTextPadding(10)
        textfieldPhoneNumber.addShadowToTextFieldColorSecondary()
        
        textfieldFullName.setBorderColorSecondary()
        textfieldFullName.addLeftTextPadding(10)
        textfieldFullName.addShadowToTextFieldColorSecondary()
        
        btnCountryCode.setButtonWithTitleAndBorderColorSecondary()
        
        
        frameHeight = UIDevice.current.iPhoneX ? 342 + 34 : 342
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            
            // Ankush   self?.frame = CGRect(x: BookingPopUpFrames.XPopUp, y: (/self?.viewSuper?.frame.origin.y + /self?.viewSuper?.frame.size.height) - CGFloat(BookingPopUpFrames.PaddingX) - /self?.frameHeight , width: BookingPopUpFrames.WidthPopUp, height: /self?.frameHeight)
            
            // 10 - for hide bottom corner radius
            self?.frame = CGRect(x: 0, y: (/self?.viewSuper?.frame.origin.y + /self?.viewSuper?.frame.size.height) - /self?.frameHeight + CGFloat(10) , width: BookingPopUpFrames.WidthPopUp, height: /self?.frameHeight)
            self?.layoutIfNeeded()
            self?.setupUI()
            self?.assignData()
            }, completion: { (done) in
                
        })
    }
    
    func clearTextfields() {
        
        textfieldFullName.text = ""
        textfieldPhoneNumber.text = ""
        
    }
    
    func setupUI() {
        buttonContinue.setButtonWithBackgroundColorThemeAndTitleColorBtnText()
    }
    
    func showBookForFriendView(superView : UIView, requestPara: ServiceRequest) {
        request = requestPara
        viewSuper = superView
        
        if !isAdded {
            
            // Ankush frameHeight =  superView.frame.size.width*70/100
            viewSuper = superView
            self.frame = CGRect(x: BookingPopUpFrames.XPopUp, y: (superView.frame.origin.y + superView.frame.size.height) , width: BookingPopUpFrames.WidthPopUp, height: frameHeight)
            superView.addSubview(self)
            isAdded = true
        }
        
        maximizeBookForFriendView()
    }
    
    func assignData() {
        
        lblCountryCode.text = UDSingleton.shared.appSettings?.appSettings?.default_country_code ?? DefaultCountry.countryCode.rawValue
        ISO = UDSingleton.shared.appSettings?.appSettings?.iso_code ?? DefaultCountry.ISO.rawValue
        debugPrint("\(/ISO?.lowercased()).png")
        imgViewCountryCode.image = UIImage(named: "\(/ISO?.lowercased()).png")
        
      /*  guard let user = UDSingleton.shared.userData?.userDetails?.user else{return}
        txtFieldFullName.text = user.name
        textFieldEmail.text = user.email
        textfieldPhoneNumber.text = String(/user.phoneNumber)
        
        lblCountryCode.text = user.countryCode
        ISO = user.iso
        
        imgViewCountryCode.image = UIImage(named: /ISO?.lowercased())
        
        if let urlImage = UDSingleton.shared.userData?.userDetails?.profilePic {
            imgViewUser.sd_setImage(with: URL(string : urlImage), placeholderImage: #imageLiteral(resourceName: "ic_user"), options: .refreshCached, progress: nil, completed: nil)
        } */
    }
    
    func validateFields() {
        
        if Validations.sharedInstance.validateUserName(userName: /textfieldFullName.text) && Validations.sharedInstance.validatePhoneNumber(phone: /textfieldPhoneNumber.text) {

            request.booking_type = "Friend"
            request.friend_name = /textfieldFullName.text
            request.friend_phone_number = /textfieldPhoneNumber.text
            request.friend_phone_code = /lblCountryCode.text
                
            delegate?.didClickContinueToBookforFriend(request: request)
        }
    }
}

//MARK: - Country Picker Delegates

extension BookForFriendView: CountryCodeSearchDelegate {
    
    func didTap(onCode detail: [AnyHashable : Any]!) {
        
        ISO = /(detail["code"] as? String)
        
        imgViewCountryCode.image = UIImage(named: /ISO?.lowercased())
        lblCountryCode.text = /(detail["dial_code"] as? String)
        
    }
    
    func didSuccessOnOtpVerification(){
        
    }
    
    
}
