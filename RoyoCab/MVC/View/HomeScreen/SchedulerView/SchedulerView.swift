//
//  SchedulerView.swift
//  Buraq24
//
//  Created by MANINDER on 13/09/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit

class SchedulerView: UIView {
    
    //MARK:- Outlets
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet weak var buttonNext: UIButton!
    
    //MARK:- Properties
    var viewSuper : UIView?
    var heightPopUp : CGFloat = 296
    var delegate : BookRequestDelegate?
    var isGas : Bool = true
    var isAdded : Bool = false
    var request : ServiceRequest = ServiceRequest()
    
    var dateSelected: Date = Date() {
        didSet {
            lblDate.text = dateSelected.toLocalDateAcTOLocale()
            lblTime.text = dateSelected.toLocalTimeAcTOLocale()
        }
    }
    
    var minDate: Date = Date()
    
    //MARK:- Actions
    @IBAction func actionBtnNextPressed(_ sender: UIButton) {
        
        request.orderDateTime = dateSelected
        self.delegate?.didGetRequestDetailWithScheduling(request: request)
        minimizeSchedulerView()
    }
    
    @IBAction func actionBtnDateTime(_ sender: UIButton) {
        self.delegate?.didSelectSchedulingDate(date: dateSelected, minDate: minDate)
    }
    
    //MARK:- Functions
    
    func updateData(date : Date) {
        
        lblDate.text = date.toLocalDateAcTOLocale()
        lblTime.text = date.toLocalTimeAcTOLocale()
        
        //        lblDate.text = date.toLocalDate()
        //        lblTime.text = date.toLocalTime()
        
        request.orderDateTime = date
        dateSelected = date
    }
    
    func minimizeSchedulerView() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            
            self?.frame = CGRect(x: BookingPopUpFrames.XPopUp , y: /self?.viewSuper?.frame.origin.y + /self?.viewSuper?.frame.size.height , width: BookingPopUpFrames.WidthPopUp, height: /self?.heightPopUp)
            
            }, completion: { (done) in
        })
    }
    
    func maximizeSchedulerView() {
        
        heightPopUp = UIDevice.current.iPhoneX ? 296 + 34 : 296
        
        // - 10 - to hide bottom corner radius
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.frame = CGRect(x: 0, y: (/self?.viewSuper?.frame.origin.y + /self?.viewSuper?.frame.size.height) - /self?.heightPopUp + CGFloat(10), width: BookingPopUpFrames.WidthPopUp, height: /self?.heightPopUp)
            
            self?.layoutIfNeeded()
            self?.setupUI()
            
            }, completion: { (done) in
        })
    }
    
    func setupUI() {
        buttonNext.setButtonWithBackgroundColorThemeAndTitleColorBtnText()
        lblDate.setTextColorSecondary()
        lblTime.setTextColorSecondary()
    }

    
    func showSchedulerView(superView : UIView , moveType : MoveType ,requestPara : ServiceRequest ) {
        request = requestPara
        heightPopUp = superView.frame.size.width*75/100
        
        if !isAdded {
            
            viewSuper = superView
            
            self.frame = CGRect(x: BookingPopUpFrames.XPopUp, y: (superView.frame.origin.y + superView.frame.size.height) , width: BookingPopUpFrames.WidthPopUp,  height: heightPopUp)
            superView.addSubview(self)
            
            isAdded = true
            
        }
        if moveType == .Forward {
            self.setUpDateAndTime()
        }
        maximizeSchedulerView()
    }
    
    func setUpDateAndTime() {

        minDate = Date().addHours(hoursToAdd: 1)
        dateSelected = minDate
    }
}
