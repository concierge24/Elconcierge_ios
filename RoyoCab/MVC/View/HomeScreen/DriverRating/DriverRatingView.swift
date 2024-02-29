//
//  DriverRatingView.swift
//  Buraq24
//
//  Created by MANINDER on 28/08/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit

protocol EtokenRatingDelegate {
    func didRatingSubmit(ratingValue : Int, comment : String)
    }


class DriverRatingView: UIView,UITextViewDelegate {
    
    //MARK:- Outlets
    @IBOutlet var imgViewDriver: UIImageView!
    @IBOutlet var lblDriverName: UILabel!
    @IBOutlet weak var buttonSkipNow: UIButton!
    
    @IBOutlet var btnRating1: UIButton!
    @IBOutlet var btnRating2: UIButton!
    @IBOutlet var btnRating3: UIButton!
    @IBOutlet var btnRating4: UIButton!
    @IBOutlet var btnRating5: UIButton!
    @IBOutlet var btnSubmit: UIButton!
    
    @IBOutlet var lblRate5: UILabel!
    @IBOutlet var lblRate4: UILabel!
    @IBOutlet var lblRate3: UILabel!
    @IBOutlet var lblRate2: UILabel!
    @IBOutlet var lblRate1: UILabel!
    @IBOutlet var txtViewComment: PlaceholderTextView!
    
    var strRatingComment : String?
    var ratingValue = -1
    
    //MARK:- Properties
    
    var viewSuper : UIView?
    var delegate : BookRequestDelegate?
     var delegateEtoken : EtokenRatingDelegate?
    var orderCurrent : OrderCab?
    var frameHeight : CGFloat = 381
    var isAdded : Bool = false
    var fromEtoken = false
    
    //MARK:- Actions
    
    @IBAction func actionBtnRatingPressed(_ sender: UIButton){
        
       ratingValue = sender.tag
        btnRating1.isSelected = sender == btnRating1
        btnRating2.isSelected = sender == btnRating2
        btnRating3.isSelected = sender == btnRating3
        btnRating4.isSelected = sender == btnRating4
        btnRating5.isSelected = sender == btnRating5
        
        
        lblRate1.isHidden = !btnRating1.isSelected
        lblRate2.isHidden = !btnRating2.isSelected
        lblRate3.isHidden = !btnRating3.isSelected
        lblRate4.isHidden = !btnRating4.isSelected
        lblRate5.isHidden = !btnRating5.isSelected
        ratingValue = sender.tag
    }
    
    @IBAction func actionBtnSubmitPressed(_ sender: UIButton) {
        if ratingValue == -1 {
            
            Alerts.shared.show(alert: "AppName".localizedString, message: "rating_validation_msg".localizedString , type: .error )

            //Toast.show(text: "rating_validation_msg".localizedString , type: .error)
        }else{
            self.endEditing(true)
            if fromEtoken{
                 self.delegateEtoken?.didRatingSubmit(ratingValue: ratingValue, comment: txtViewComment.text)
                fromEtoken = false
                
            }
            else{
                self.delegate?.didRatingSubmit(ratingValue: ratingValue, comment: txtViewComment.text)
            }
            
        }
    }
    
    @IBAction func buttonSkipRateClicked(_ sender: UIButton) {
           // Ankush need to handle cases
         self.delegate?.didSkipRating()
    }
    
    
    //MARK:- Functions
    
    func minimizeDriverRatingView() {
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.frame = CGRect(x: BookingPopUpFrames.XPopUp, y: /self?.viewSuper?.frame.origin.y + /self?.viewSuper?.frame.size.height , width: BookingPopUpFrames.WidthPopUp, height: /self?.frameHeight)
            }, completion: { (done) in
        })
    }
    
    func maximizeDriverRatingView() {
        
        frameHeight = UIDevice.current.iPhoneX ? 381 + 34 : 381
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
          // Ankush  self?.frame = CGRect(x: BookingPopUpFrames.XPopUp, y: (/self?.viewSuper?.frame.origin.y + /self?.viewSuper?.frame.size.height) - CGFloat(BookingPopUpFrames.PaddingX) - /self?.frameHeight , width: BookingPopUpFrames.WidthPopUp, height: /self?.frameHeight)
            
            self?.frame = CGRect(x: 0, y: (/self?.viewSuper?.frame.origin.y + /self?.viewSuper?.frame.size.height) - /self?.frameHeight + CGFloat(10) , width: BookingPopUpFrames.WidthPopUp, height: /self?.frameHeight)
            
            self?.layoutIfNeeded()
            self?.setupUI()
            
            }, completion: { (done) in
        })
    }
    
    func setupUI() {
        btnSubmit.setButtonWithBackgroundColorThemeAndTitleColorBtnText()
        buttonSkipNow.setButtonWithTitleColorTheme()
    }
    
    
    func showDriverRatingView(superView : UIView ,order : OrderCab? , showSkipButton: Bool = true) {
        orderCurrent = order
      
        buttonSkipNow.isHidden = !showSkipButton
        
        if !isAdded {
            
            
            let widthInt = Int(Float(imgViewDriver.frame.size.width/2))
            imgViewDriver.cornerRadius(radius: CGFloat(widthInt))
           // Ankush frameHeight =  superView.frame.size.width*110/100
            viewSuper = superView
            
            txtViewComment.placeholder = "add_comments_here".localizedString as NSString
            self.frame = CGRect(x: BookingPopUpFrames.XPopUp, y: (superView.frame.origin.y + superView.frame.size.height) , width: BookingPopUpFrames.WidthPopUp, height: frameHeight)
            superView.addSubview(self)
            
            isAdded = true
        }
        assignPopUpData()
        maximizeDriverRatingView()
    }
    
    func assignPopUpData() {
        txtViewComment.setAlignment()
        ratingValue = -1
       ( btnRating1.isSelected, btnRating2.isSelected , btnRating3.isSelected,btnRating4.isSelected, btnRating5.isSelected) = (false, false, false, false,false)
        txtViewComment.text = ""
          ( lblRate1.isHidden, lblRate2.isHidden , lblRate3.isHidden,lblRate4.isHidden, lblRate5.isHidden) = (true, true, true, true,true)
   
        guard let order = orderCurrent else {return}
        guard let driverDetail = order.driverAssigned else{return}
        lblDriverName.text = /driverDetail.driverName
        
        if let  driverimage = driverDetail.driverProfilePic {
            if let url = URL(string: driverimage) {
                imgViewDriver.sd_setImage(with: url , completed: nil)
            }else{
                imgViewDriver.image = #imageLiteral(resourceName: "ic_user")
            }
        }
    }
    
}

