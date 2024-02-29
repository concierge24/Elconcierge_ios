//
//  BookingCell.swift
//  Buraq24
//
//  Created by MANINDER on 07/09/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit

class BookingCell: UICollectionViewCell {
    
    //MARK:- Outlets
    @IBOutlet var lblServicePrice: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblBookingStatus: UILabel!
    @IBOutlet var lblBookingId: UILabel!
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var labelBookingType: UILabel!
    @IBOutlet var imgViewMapTrack: UIImageView!
    
    //MARK:- Properties
    
    //MARK:- FUnctions
    
    
    override func awakeFromNib() {
        
        bgView.setViewBorderColorSecondary()
        labelBookingType.setTextColorTheme()
        lblBookingStatus.setTextColorSecondary()
    }
    
    func assignData(model : OrderCab) {
        
        guard let orderId = model.orderToken else {return}
        lblBookingId.text = "Id : " + orderId
        
        if model.orderStatus == .Scheduled || model.orderStatus == .DriverApprovalPending || model.orderStatus == .DriverApproval || model.orderStatus == .DriverSchCancelled || model.orderStatus == .DriverSchTimeOut  || model.orderStatus == .SystyemSchCancelled {
            
            lblBookingStatus.text = "Scheduled".localizedString
            lblBookingStatus.setTextColorTheme()
            labelBookingType.text = model.booking_type == "Package" ? "Booked through Packages" : ""
            
        } else if  model.orderStatus == .CustomerCancel || model.orderStatus == .DriverCancel {
            
            lblBookingStatus.text = "cancelled".localizedString
            lblBookingStatus.textColor = R.color.appRed()
            labelBookingType.text = model.booking_type == "Package" ? "Booked through Packages" : ""

            
        }else if model.orderStatus == .ServiceComplete {
            
            lblBookingStatus.text = "completed".localizedString
            lblBookingStatus.setTextColorTheme()
            labelBookingType.text = model.booking_type == "Package" ? "Booked through Packages" : ""


        } else if model.orderStatus == .SerHalfWayStop {
            
            lblBookingStatus.text = "HalfWayStop".localizedString
            lblBookingStatus.setTextColorTheme()
            labelBookingType.text = model.booking_type == "Package" ? "Booked through Packages" : ""


        } else if model.orderStatus == .ServiceBreakdown {
                
            lblBookingStatus.text = "breakdown".localizedString
            lblBookingStatus.setTextColorTheme()
            labelBookingType.text = model.booking_type == "Package" ? "Booked through Packages" : ""
        }
        else if model.orderStatus == .etokenCustomerConfirm{
            lblBookingStatus.text = "OrderStatus.Confirmed".localizedString
            lblBookingStatus.setTextColorTheme()
            labelBookingType.text = model.booking_type == "Package" ? "Booked through Packages" : ""


        }
        else if model.orderStatus == .Confirmed {
            
            lblBookingStatus.text = "OrderStatus.Confirmed".localizedString
            lblBookingStatus.setTextColorTheme()
            labelBookingType.text = model.booking_type == "Package" ? "Booked through Packages" : ""


        }
        else if model.orderStatus == .reached {
            
            lblBookingStatus.text = "OrderStatus.Reached".localizedString
            lblBookingStatus.setTextColorTheme()
            labelBookingType.text = model.booking_type == "Package" ? "Booked through Packages" : ""


        }
        else if model.orderStatus == .ServiceTimeout || model.orderStatus == .etokenTimeOut{
            lblBookingStatus.text = "etoken.Timeout".localizedString

        }
            
        else if model.orderStatus == .etokenCustomerPending{
            lblBookingStatus.text = "etoken.ApprovalPending".localizedString
        }
            
        else if model.orderStatus == .etokenSerCustCancel{
            lblBookingStatus.text = "etoken.Rejected".localizedString
        }
        else{
            lblBookingStatus.text  = model.orderStatus.rawValue
            lblBookingStatus.setTextColorTheme()
            labelBookingType.text = model.booking_type == "Package" ? "Booked through Packages" : ""


        }
        
        guard let lati = model.dropOffLatitude else{return}
        guard let long = model.dropOffLongitude else{return}
        
        if let orderDate = model.orderLocalDate{
        lblDate.text = orderDate.getBookingDateStr()
        }
        
        guard let payment = model.payment else{return}
        
        if model.organisationCouponUserId != 0{
            lblServicePrice.text = "etoken.eToken".localizedString + " · \(/model.payment?.productQuantity)"
        }
        else{
            lblServicePrice.text =  "cash".localizedString + " - " + (/UDSingleton.shared.appSettings?.appSettings?.currency) + " " +  (/payment.finalCharge).getTwoDecimalFloat() 
        }
        
        updateSemantic()
        
      let strURL = Utility.shared.setStaticPolyLineOnMap(pickUpLat: /model.pickUpLatitude, pickUpLng: /model.pickUpLongitude, dropLat: /model.dropOffLatitude, dropLng: /model.dropOffLongitude)
        
        let nsString  = NSString.init(string: strURL).addingPercentEscapes(using: String.Encoding.utf8.rawValue)!
        
        if let url = NSURL(string: nsString) {
            imgViewMapTrack.sd_setImage(with:url as URL, placeholderImage: nil, options: .refreshCached, progress: nil, completed: nil)
        }
    }
    
    private  func updateSemantic() {
        if  LanguageFile.shared.isLanguageRightSemantic() {
            lblBookingStatus.textAlignment = .left
            lblServicePrice.textAlignment = .left
            lblDate.textAlignment  = .right
            lblBookingId.textAlignment = .right
        }
    }
}
