//
//  ConfirmPickupView.swift
//  Trava
//
//  Created by Apple on 15/11/19.
//  Copyright © 2019 CodeBrewLabs. All rights reserved.
//

import Foundation
import UIKit

protocol ConfirmPickupViewDelegate: class {
    func didClickConfirmPickup()
}

class ConfirmPickupView: UIView {
    
    //MARK:- Outlets
    //MARK:-
   
    @IBOutlet weak var labelPickUpLocation: UILabel!
    @IBOutlet weak var buttonConfirmPickUp: UIButton?
    
    
    var viewSuper : UIView?
    
    //MARK:- Properties
    //MARK:-
    
    var isAdded : Bool = false
    var request : ServiceRequest = ServiceRequest()
    var frameHeight : CGFloat = 238
    weak var delegate : ConfirmPickupViewDelegate?
    
    //MARK:- Actions
    //MARK:-
    
     @IBAction func actionBtnBookPressed(_ sender: UIButton) {
        
        //        if /request.serviceSelected?.serviceCategoryId != 1 {
        //           alertBoxOk(message:"work_in_progress".localizedString , title: "AppName".localizedString, ok: {
        //            })
        //            return
        //        }else{
        
        minimizeConfirmPickUPView()
        delegate?.didClickConfirmPickup()
        
       // Ankush self.delegate?.didSelectNext(type: .SubmitOrder)
        // }
        
    }
    
    
    //MARK:- Functions
    //MARK:-
    
    func minimizeConfirmPickUPView() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.frame = CGRect(x: BookingPopUpFrames.XPopUp, y: /self?.viewSuper?.frame.origin.y + /self?.viewSuper?.frame.size.height , width: BookingPopUpFrames.WidthPopUp, height: /self?.frameHeight)
            
            }, completion: { (done) in
        })
    }
    
    func maximizeConfirmPickUPView() {
        
        frameHeight = UIDevice.current.iPhoneX ? 238 + 34 : 238
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            
            // Ankush   self?.frame = CGRect(x: BookingPopUpFrames.XPopUp, y: (/self?.viewSuper?.frame.origin.y + /self?.viewSuper?.frame.size.height) - CGFloat(BookingPopUpFrames.PaddingX) - /self?.frameHeight , width: BookingPopUpFrames.WidthPopUp, height: /self?.frameHeight)
            
            
            self?.frame = CGRect(x: 0, y: (/self?.viewSuper?.frame.origin.y + /self?.viewSuper?.frame.size.height) - /self?.frameHeight + CGFloat(10) , width: BookingPopUpFrames.WidthPopUp, height: /self?.frameHeight)
            
            self?.layoutIfNeeded()
            self?.setupUI()
            
            }, completion: { (done) in
                
        })
    }
    
    func setupUI() {
        buttonConfirmPickUp?.setButtonWithBackgroundColorThemeAndTitleColorBtnText()
    }
    
    func showConfirmPickUPView(superView : UIView) {
       // request = requestPara
        
        viewSuper = superView
        
        if !isAdded {
            
            // Ankush frameHeight =  superView.frame.size.width*70/100
            viewSuper = superView
            self.frame = CGRect(x: BookingPopUpFrames.XPopUp, y: (superView.frame.origin.y + superView.frame.size.height) , width: BookingPopUpFrames.WidthPopUp, height: frameHeight)
            superView.addSubview(self)
            isAdded = true
        }
        
        maximizeConfirmPickUPView()
    }
    
    func assignData(location: String?) {
        labelPickUpLocation.text = location
    }
    
}
