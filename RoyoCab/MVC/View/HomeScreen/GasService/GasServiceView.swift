//
//  GasServiceView.swift
//  Buraq24
//
//  Created by MANINDER on 23/08/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit

class GasServiceView: UIView {
    
    //MARK:- IBOutlets
    
    @IBOutlet var lblCapacity: UILabel!
    @IBOutlet var lblQuantity: UILabel!
    @IBOutlet var btnSelectQuantity: UIButton!
    
    @IBOutlet var lblCapacityLeft: UILabel!
    @IBOutlet var lblQuantityLeft: UILabel!
    @IBOutlet weak var stackViewQuantity: UIStackView!
    @IBOutlet weak var tfOther: UITextField!
    
    //MARK:- Properties
    //MARK:-
    
    var viewSuper : UIView?
    var delegate : BookRequestDelegate?
    var isGas : Bool = true
    var isAdded : Bool = false
    lazy var request : ServiceRequest = ServiceRequest()
    var frameHeight : CGFloat = 240
    var defaultBrand : Brand?
    var isOtherQuantity :Bool?{
        didSet{
            stackViewQuantity.isHidden = /isOtherQuantity
            tfOther.isHidden = !(/isOtherQuantity)
            tfOther.text = ""
        }
    }
    
    //MARK:- Actions
    //MARK:-
    
    @IBAction func actionBtnSelectCapacityPressed(_ sender: UIButton) {
        
        guard let brand = defaultBrand else {return}
        guard let productNames = brand.productNames else {return}
        guard let products = brand.products else {return}
       
        var view : UIView = UIView()
        
        if  let languageCode = UserDefaultsManager.languageId{
            guard let intVal = Int(languageCode) else {return}
            
            switch intVal {
            case 1:
                view = btnSelectQuantity
            case 3, 5:
                view = lblCapacityLeft
            default :
                break;
            }
        }
        
        Utility.shared.showDropDown(anchorView: view  , dataSource:  productNames, width: 240, handler: { [weak self] (index, strValu) in
            self?.request.selectedProduct = products[index]
            self?.request.productName = productNames[index]
            self?.isOtherQuantity = false
            self?.lblCapacity.text = strValu
            self?.lblQuantity.text = "\(/(self?.request.selectedProduct?.min_quantity))"
            self?.request.quantity = /(self?.request.selectedProduct?.min_quantity)
            
        })
    }
    
    @IBAction func actionBtnSelectQuantityPressed(_ sender: UIButton) {
        
        var view : UIView = UIView()
        
        if  let languageCode = UserDefaultsManager.languageId{
            guard let intVal = Int(languageCode) else {return}
            
            switch intVal{
            case 1:
                view = btnSelectQuantity
            case 3, 5:
                view = lblCapacityLeft
            default :
                break;
            }
        }
        
        let min:Int = /(self.request.selectedProduct?.min_quantity)
        let max :Int = /(self.request.selectedProduct?.max_quantity)
        
        var dataSource:[String] = Array(min...max).map{String($0)}
        dataSource.append("Other")
        
            Utility.shared.showDropDown(anchorView: view, dataSource: dataSource, width: 60, handler: { [weak self] (index, strValu) in
                
                if index == dataSource.count - 1{
                    self?.isOtherQuantity = true
                    self?.btnSelectQuantity.isHidden = true
                    self?.tfOther.becomeFirstResponder()
                }
                else{
                    self?.lblQuantity.text = strValu
                    self?.request.quantity = /Int(strValu)
                    self?.delegate?.didSelectQuantity(count: Int(strValu)!)
                }
            })
    }
    
    @IBAction func actionBtnNextPressed(_ sender: UIButton) {
        if isOtherQuantity == true{
            if let val = self.tfOther.text{
                if /Int(val) < /(self.request.selectedProduct?.min_quantity){
                    Alerts.shared.show(alert: R.string.localizable.appName(), message: "Please enter minimum order quantity", type: .info)
                    return
                }
            self.request.quantity = /Int(val)
            }
        }
        
         request.requestType = .Present
        request.orderDateTime = Date()
        moveToNextPopUp()
    }
    
    @IBAction func actionBtnSchedulePressed(_ sender: UIButton) {
        
        if isOtherQuantity == true{
            if let val = self.tfOther.text{
                if /Int(val) < /(self.request.selectedProduct?.min_quantity){
                    Alerts.shared.show(alert: R.string.localizable.appName(), message: "Please enter minimum order quantity", type: .info)
                    return
                }
                self.request.quantity = /Int(val)
            }
        }
        
        request.requestType = .Future
       moveToNextPopUp()
    }
    
    func moveToNextPopUp() {
        
        if request.selectedBrand == nil || request.quantity == 0 {
            Alerts.shared.show(alert: "AppName".localizedString, message: "alert.enterDetails".localizedString , type: .error )
            return
        }
     
        delegate?.didGetRequestDetails(request: request)
        minimizeGasServiceView()
        
    }
    
    //MARK:- Functions
    //MARK:-
    
    func minimizeGasServiceView() {
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.frame = CGRect(x: BookingPopUpFrames.XPopUp, y: /self?.viewSuper?.frame.origin.y + /self?.viewSuper?.frame.size.height , width: BookingPopUpFrames.WidthPopUp, height: /self?.frameHeight)
            }, completion: { (done) in
        })
    }
    
    func maximizeGasServiceView() {
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.frame = CGRect(x: BookingPopUpFrames.XPopUp, y: (/self?.viewSuper?.frame.origin.y + /self?.viewSuper?.frame.size.height) - CGFloat(BookingPopUpFrames.PaddingX) - /self?.frameHeight , width: BookingPopUpFrames.WidthPopUp, height: /self?.frameHeight)
            }, completion: { (done) in
        })
    }
    
    func showGasServiceView(superView : UIView , moveType : MoveType ,requestPara : ServiceRequest ) {
        request = requestPara
        if !isAdded {
            self.setCornerRadius(radius: 10)
            frameHeight =  superView.frame.size.width*75/100
            viewSuper = superView
            self.frame = CGRect(x: BookingPopUpFrames.XPopUp, y: (superView.frame.origin.y + superView.frame.size.height) , width: BookingPopUpFrames.WidthPopUp, height: frameHeight)
            superView.addSubview(self)
            isAdded = true
        }
        setPopUpValues(moveType: moveType)
        maximizeGasServiceView()
    }
    
    func setPopUpValues(moveType : MoveType) {
        
        isOtherQuantity = false
        isGas =  /request.serviceSelected?.serviceCategoryId == 1
        if moveType == .Forward {
            
            guard let brands = request.serviceSelected?.brands else {return}
            
            if brands.count > 0  {
                
                defaultBrand = brands[0]
                request.selectedBrand = defaultBrand
                guard let products = defaultBrand?.products else {return}
                if products.count > 0 {
                    self.request.selectedProduct = products[0]
                    lblQuantity.text = "\(/(self.request.selectedProduct?.min_quantity))"
                    request.quantity = /(self.request.selectedProduct?.min_quantity)
                    lblCapacity.text = self.request.selectedProduct?.productName
                    request.productName = self.request.selectedProduct?.productName
                }else{
                    lblCapacity.text = "Select"
                }
            } else {
                 lblQuantity.text = "Select"
                  lblCapacity.text = "Select"
            }
        }
        else{
            isOtherQuantity = false
           lblQuantity.text =  "\(/(self.request.quantity))"
        }
        
    }
}


