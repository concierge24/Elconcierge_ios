//
//  NewInvoiceView.swift
//  Trava
//
//  Created by Apple on 16/11/19.
//  Copyright © 2019 CodeBrewLabs. All rights reserved.
//

import Foundation

class NewInvoiceView: UIView {
    
    //MARK:- IBOutlets
    //MARK:-
    
    @IBOutlet weak var labelTotalBill: UILabel!
    @IBOutlet weak var constraintHeightbottomview: NSLayoutConstraint!
    
    @IBOutlet weak var buttonDone: UIButton!
    //MARK:- Properties
    //MARK:-
    
    var viewSuper : UIView?
    var delegate : BookRequestDelegate?
    var isAdded : Bool = false
    var orderDone : OrderCab?
    var frameHeight : CGFloat = UIScreen.main.bounds.height
    
    
    //MARK:- Actions
    //MARK:-
    @IBAction func buttonDoneClicked(_ sender: Any) {
        
        self.delegate?.didSelectNext(type: .DoneInvoice)
    }
    
    @IBAction func buttonInfoClicked(_ sender: Any) {
        delegate?.didClickInvoiceInfoButton()
    }
    
    //MARK:- Functions
    //MARK:-
    
    func minimizeNewInvoiceView() {
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.frame = CGRect(x: BookingPopUpFrames.XPopUp, y: /self?.viewSuper?.frame.origin.y + /self?.viewSuper?.frame.size.height , width: BookingPopUpFrames.WidthPopUp, height: /self?.frameHeight)
            }, completion: { (done) in
        })
    }
    
    func maximizeNewInvoiceView() {
        
        constraintHeightbottomview.constant = UIDevice.current.iPhoneX ? 100 + 34 : 100
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.frame = CGRect(x: 0, y: 0 , width: BookingPopUpFrames.WidthPopUp, height: /self?.frameHeight)
            
            self?.layoutIfNeeded()
            self?.setupUI()
            
            }, completion: { (done) in
        })
    }
    
    func setupUI() {
        buttonDone.setButtonWithBackgroundColorThemeAndTitleColorBtnText()
        
        
        let template = AppTemplate(rawValue: (UDSingleton.shared.appSettings?.appSettings?.app_template?.toInt() ?? 0) )
        switch template{
            
        case .Moby?:
            self.setViewBackgroundColorHeader()

        default:
            self.setViewBackgroundColorTheme()            
        }
        
    }
    
    func showNewInvoiceView(superView : UIView ,order : OrderCab ) {
        orderDone = order
        if !isAdded {
            //            frameHeight =  superView.frame.size.width*76/100
            viewSuper = superView
            self.frame = CGRect(x: BookingPopUpFrames.XPopUp, y: (superView.frame.origin.y + superView.frame.size.height) , width: BookingPopUpFrames.WidthPopUp, height: frameHeight)
            superView.addSubview(self)
            isAdded = true
        }
        
        assignPopUpData()
        maximizeNewInvoiceView()
    }
    
    
    func assignPopUpData() {
        
        guard let currentOrd = orderDone else{return}
        
        guard let service = UDSingleton.shared.getService(categoryId: currentOrd.serviceId) else {return}
      // Ankush  lblBrandProductName.text = /service.serviceName
        guard let payment = currentOrd.payment else{return}
        labelTotalBill.text =  (/UDSingleton.shared.appSettings?.appSettings?.currency) + " " + (/payment.finalCharge).getTwoDecimalFloat()
        
        
      /*  if /service.serviceCategoryId == 2 || /service.serviceCategoryId == 4 {
            lblBrandProductName.text = /currentOrd.orderProductDetail?.productBrandName
        }else{
            lblBrandProductName.text = /service.serviceName
        }
        
        
        let orderDetail  = /service.serviceCategoryId > 3 ? (/currentOrd.orderProductDetail?.productName)   : (/currentOrd.orderProductDetail?.productName + " × " +  String(/payment.productQuantity))
        
        lblOrderDetails.text = orderDetail
        //        lblBaseFairValue.text =  (/payment.initalCharge).getTwoDecimalFloat() + " " + "currency".localizedString
        //        lblTaxValue.text = (/payment.adminCharge).getTwoDecimalFloat() + " " + "currency".localizedString
        //        lblFinalAmount.text =  (/payment.finalCharge).getTwoDecimalFloat() + " " + "currency".localizedString
        
        var total : Double = 0.0
        
        if let initalCharge = Double(/payment.initalCharge) {
            total =  initalCharge
        }
        
        if let adminCharge = Double(/payment.adminCharge) {
            total =  total + adminCharge
        }
        
        lblBaseFairValue.text =  "\(total)".getTwoDecimalFloat() + " " + "currency".localizedString
        lblTaxValue.text = "0.0".getTwoDecimalFloat() + " " + "currency".localizedString
        lblFinalAmount.text =  (/payment.finalCharge).getTwoDecimalFloat() + " " + "currency".localizedString
        lblOthersPrice.text = "0.0".getTwoDecimalFloat() + " " + "currency".localizedString
        
        */
    }
}
