//
//  DrinkingWaterView.swift
//  Buraq24
//
//  Created by MANINDER on 31/08/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit

class DrinkingWaterView: UIView {

    //MARK:- Outlets
    
    @IBOutlet var collectionViewBrands: UICollectionView!
    @IBOutlet var lblQuantitySelected: UILabel!
    @IBOutlet var lblCapacitySelected: UILabel!
    
    @IBOutlet var lblCapacityLeft: UILabel!
    @IBOutlet var lblQuantityLeft: UILabel!
    
    @IBOutlet var btnCapacity: UIButton!
    @IBOutlet var btnQuantity: UIButton!
    //MARK:- Properties
    @IBOutlet weak var btnBookNow: UIButton!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var tfOther: UITextField!
    
    
    var request : ServiceRequest?
    var heightPopUp : CGFloat = 200
    var viewSuper : UIView?
     var delegate : BookRequestDelegate?
    
    var isAdded : Bool = false
    
    var collectionViewDataSource : CollectionViewDataSourceCab?
    var brands : [Brand] = [Brand]()
    
    var productId = 0
    
    var isOtherQuantity :Bool?{
        didSet{
            stackView.isHidden = /isOtherQuantity
            btnQuantity.isHidden =  /isOtherQuantity
            tfOther.isHidden = !(/isOtherQuantity)
            tfOther.text = ""
        }
    }
    
    //MARK:- Actions
    @IBAction func actionBtnSelectCapacity(_ sender: UIButton) {
      
        guard let brand = request?.selectedBrand else {return}
        guard let productNames = brand.productNames else{return}
         guard let products = brand.products else{return}
        
        var view : UIView = UIView()
        
        if  let languageCode = UserDefaultsManager.languageId{
            guard let intVal = Int(languageCode) else {return}
            
            switch intVal{
            case 1:
                 view = btnCapacity
            case 3, 5:
                view = lblCapacityLeft
            default :
                break;
            }
        }
        
        Utility.shared.showDropDown(anchorView: view, dataSource:  productNames, width: 200, handler: { [weak self] (index, strValu) in
            self?.request?.selectedProduct = products[index]
            self?.request?.productName = productNames[index]
             self?.lblCapacitySelected.text = strValu
            self?.lblQuantitySelected.text = "\(/self?.request?.selectedProduct?.min_quantity)"
            self?.isOtherQuantity = false
            self?.delegate?.didSelectBrandProduct(brand,products[index])
            self?.productId = /products[index].productBrandId
            
        })
    }
    
    @IBAction func actionBtnSelectQuantity(_ sender: UIButton) {
        
        var view : UIView = UIView()
        
        if  let languageCode = UserDefaultsManager.languageId{
            
            guard let intVal = Int(languageCode) else {return}
            switch intVal{
            case 1:
                view = btnQuantity
            case 3, 5:
                view = lblCapacityLeft
            default :
                break;
            }
        }
    
        let min:Int = /(self.request?.selectedProduct?.min_quantity)
        let max :Int = /(self.request?.selectedProduct?.max_quantity)
        
        var dataSource:[String] = Array(min...max).map{String($0)}
        dataSource.append("Other")

        
         Utility.shared.showDropDown(anchorView: view, dataSource: dataSource, width: 60, handler: { [weak self] (index, strValu) in
            
            if index == dataSource.count - 1{
                self?.isOtherQuantity = true
                self?.tfOther.becomeFirstResponder()
            }
            else{
            self?.lblQuantitySelected.text = strValu
            self?.request?.quantity = /Int(strValu)
            self?.delegate?.didSelectQuantity(count: Int(strValu)!)
            }
        })
    }
    
    @IBAction func actionBtnNextPressed(_ sender: Any) {
        
        if isOtherQuantity == true {
            if let val = self.tfOther.text{
                self.request?.quantity = /Int(val)
            }
        }
        else{
            self.request?.quantity = /Int(lblQuantitySelected.text!)
        }
        
        if self.request?.quantity != 0 , let _ = request?.selectedBrand ,let _ = self.request?.selectedProduct {
            
            guard var request = request else {return}
            
              request.requestType = .Present
            
             request.orderDateTime = Date()
            delegate?.didGetRequestDetails(request: request)
            minimizeDrinkingWaterView()
            
        }else{
            
            Alerts.shared.show(alert: "AppName".localizedString, message: "Please enter order details.".localizedString , type: .error )
        }
    }
    
    @IBAction func actionBtnSchedulePressed(_ sender: UIButton) {
        if isOtherQuantity == true {
            if let val = self.tfOther.text{
                self.request?.quantity = /Int(val)
            }
        }
        else{
            self.request?.quantity = /Int(lblQuantitySelected.text!)
        }
        
        if self.request?.quantity != 0 , let _ = request?.selectedBrand ,let _ = self.request?.selectedProduct {
            guard var request = request else {return}
           
            request.requestType = .Future
            delegate?.didGetRequestDetails(request: request)
            minimizeDrinkingWaterView()
            
        }else{
            Alerts.shared.show(alert: "AppName".localizedString, message: "alert.enterDetails".localizedString , type: .error )
        }
    }
    
    @IBAction func actionBtnBuyETokenPressed(_ sender: UIButton) {
        print()
        
     
        self.delegate?.didBuyEToken(brandId: /self.request?.selectedBrand?.categoryBrandId, brandProductId:self.productId )
    }
    
    //MARK:- Functions
    func minimizeDrinkingWaterView() {
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.frame = CGRect(x: BookingPopUpFrames.XPopUp , y: /self?.viewSuper?.frame.origin.y + /self?.viewSuper?.frame.size.height , width: BookingPopUpFrames.WidthPopUp, height: /self?.heightPopUp)
            }, completion: { (done) in
        })
    }
    
    func maximizeDrinkingWaterView() {
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.frame = CGRect(x: BookingPopUpFrames.XPopUp, y: (/self?.viewSuper?.frame.origin.y + /self?.viewSuper?.frame.size.height) - CGFloat(BookingPopUpFrames.PaddingX) - /self?.heightPopUp , width: BookingPopUpFrames.WidthPopUp, height: /self?.heightPopUp)
            }, completion: { (done) in
        })
    }
    
    func showDrinkingWaterServiceView(superView : UIView , moveType : MoveType ,requestPara : ServiceRequest ) {
        
         request = requestPara
        isOtherQuantity = false
        
        guard let brands = requestPara.serviceSelected?.brands else {return}
       self.brands = brands
        heightPopUp = superView.frame.size.width * 124/100
        if !isAdded {
            viewSuper = superView
            self.frame = CGRect(x: BookingPopUpFrames.XPopUp, y: (superView.frame.origin.y + superView.frame.size.height) , width: BookingPopUpFrames.WidthPopUp, height: heightPopUp)
            superView.addSubview(self)
          
            isAdded = true
        }
        
        if moveType == .Forward {
            request?.selectedBrand = brands[0]
            settingUpdatedData()
        }
        else{
            isOtherQuantity = false
            self.lblQuantitySelected.text =  "\(/self.request?.quantity)"

        }
        
          configureCollectionView()
        maximizeDrinkingWaterView()
    }
    
    private func configureCollectionView() {
        
       
 
        let configureCellBlock : ListCellConfigureBlockCab = { [weak self] (cell, item, indexPath) in
            if let cell = cell as? DrinkingWaterCell, let model = item as? Brand {
                guard let brand = self?.request?.selectedBrand else {return}
                cell.makeAsSelected(selected: model.categoryBrandId == brand.categoryBrandId, model: model)
           }
        }
        
        let didSelectBlock : DidSelectedRowCab = { [weak self] (indexPath, cell, item) in
            if let _ = cell as? DrinkingWaterCell, let model = item as? Brand{
                self?.request?.selectedBrand = model
                self?.settingUpdatedData()
                self?.collectionViewBrands.reloadData()
            }
        }
        
        brands = brands.filter {   if let intVal = ($0.products?.count)  {
            return intVal > 0
            }
            return false
        }
        
        collectionViewDataSource = CollectionViewDataSourceCab(items:  brands, collectionView: collectionViewBrands, cellIdentifier: R.reuseIdentifier.drinkingWaterCell.identifier, cellHeight: collectionViewBrands.frame.size.height, cellWidth: collectionViewBrands.frame.size.width/4, configureCellBlock: configureCellBlock, aRowSelectedListener: didSelectBlock)
        collectionViewBrands.delegate = collectionViewDataSource
        collectionViewBrands.dataSource = collectionViewDataSource
        collectionViewBrands.reloadData()
    }
    
    
    
    private func settingUpdatedData() {
        
        guard let products = request?.selectedBrand?.products else {return}
        guard let productNames = request?.selectedBrand?.productNames else {return}
        
        if products.count > 0 {
            request?.selectedProduct = products[0]
            request?.productName = productNames[0]
//            request?.quantity = /(self.request?.selectedProduct?.min_quantity)
        }
        
        print(/(self.request?.selectedProduct?.min_quantity))
        self.isOtherQuantity = false
        
        lblQuantitySelected.text = "\(/self.request?.selectedProduct?.min_quantity)"
        lblCapacitySelected.text = request?.productName
        self.productId = /products[0].productBrandId
        
        if Localize.currentLanguage() == Languages.English{
            
            if request?.serviceSelected?.serviceCategoryId == 2{
                btnBookNow.setTitle("Order Now", for: .normal)
            }
            else{
                btnBookNow.setTitle("Book Now", for: .normal)
            }
        }
    }
}
