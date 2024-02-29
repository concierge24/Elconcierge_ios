//
//  SelectBrandView.swift
//  Buraq24
//
//  Created by MANINDER on 04/10/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit

class SelectBrandView: UIView {

    
    //MARK:- Outlets
    
    @IBOutlet var collectionViewBrands: UICollectionView!
    @IBOutlet var constraintWidthCollection: NSLayoutConstraint!
    @IBOutlet weak var buttonContinue: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var promocodeStack: UIStackView!
    @IBOutlet weak var lblPromocode: UITextField!
    
    //MARK:- Properties
    
    lazy var brands : [Brand] = [Brand]()
    var drivers: [HomeDriver]?
    var collectionViewDataSource : CollectionViewDataSourceCab?
   
    
    var request : ServiceRequest?
    var delegate : BookRequestDelegate?
    
    var heightPopUp : CGFloat = 340 // 10 for hide bottom corner radius 290
    var isAdded : Bool = false
    var viewSuper : UIView?
    
    var estimatedDistanceInKm: Float?
    var estimatedTimeinMins: Int?
    
    var isAppliedPromo: Bool = false
    var couponID: Int?
    
    
    //MARK:- Actions
    @IBAction func actionBtnCancelPressed(_ sender: UIButton) {
        self.delegate?.didSelectNext(type: .BackFromFreightProduct)
        minimizeSelectBrandView()
    }
    
    @IBAction func btnRemovePromo(_ sender: Any) {
        self.isAppliedPromo = false
        self.promocodeStack.isHidden = true
    }
    
    @IBAction func actionBtnNextPressed(_ sender: UIButton) {
        
        let template = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
        switch template {
        case .Corsa:
            
            if isAppliedPromo {
                   guard let brand =  self.request?.selectedBrand else{return}
                   self.delegate?.didSelectedFreightBrand(brand: brand)
                   self.minimizeSelectBrandView()
               } else {
               
                   guard let vc = R.storyboard.bookService.promoCodeViewController() else {return}
                    vc.modalPresentationStyle = .overFullScreen
                    vc.promoCodeSelection = {[weak self](card) in
                       self?.isAppliedPromo = true
                       self?.promocodeStack.isHidden = false
                       self?.lblPromocode.text = card?.code
                       self?.buttonContinue.setTitle("Porceed", for: .normal)
                   }
                   (ez.topMostVC as? HomeVC)?.presentVC(vc)
               }
            
            break
            
        default:
            guard let brand =  self.request?.selectedBrand else{return}
            self.delegate?.didSelectedFreightBrand(brand: brand)
            minimizeSelectBrandView()
        }
                
    }
    
    
    
    //MARK:- Functions
    func minimizeSelectBrandView() {
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.frame = CGRect(x: BookingPopUpFrames.XPopUp , y: /self?.viewSuper?.frame.origin.y + /self?.viewSuper?.frame.size.height , width: BookingPopUpFrames.WidthPopUp, height: /self?.heightPopUp)
            }, completion: { (done) in
        })
    }
    
    func maximizeSelectBrandView() {
        
        let template = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
        switch template {
        case .Corsa:
            heightPopUp = UIDevice.current.iPhoneX ? 340 + 34 : 340
            break
            
        default:
             heightPopUp = UIDevice.current.iPhoneX ? 290 + 34 : 290
        }
        
               
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
           // Ankush self?.frame = CGRect(x: BookingPopUpFrames.XPopUp, y: (/self?.viewSuper?.frame.origin.y + /self?.viewSuper?.frame.size.height) - CGFloat(BookingPopUpFrames.PaddingX) - /self?.heightPopUp , width: BookingPopUpFrames.WidthPopUp, height: /self?.heightPopUp)
            
            // 10 - to hide corner radius from bottom
            self?.frame = CGRect(x: 0, y: (/self?.viewSuper?.frame.origin.y + /self?.viewSuper?.frame.size.height) - /self?.heightPopUp + CGFloat(10) , width: BookingPopUpFrames.WidthPopUp, height: /self?.heightPopUp)
            self?.layoutIfNeeded()
            self?.setupUI()
            
            }, completion: { (done) in
        })
    }

    
    func setupUI() {
        
        
        let template = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
              
        switch template {
        case .DeliverSome:
            lblTitle.text = "Select Package type".localizedString
            break
        case .GoMove:
            lblTitle.text = "Select Parcel type".localizedString
            break
            
        case .Corsa:
            lblTitle.text = "Select Vehicle type".localizedString
            buttonContinue.setTitle("Apply Promo Code".localizedString, for: .normal)
            break
            
        default:
            break
            
        }
        
        buttonContinue.setButtonWithBackgroundColorThemeAndTitleColorBtnText()

    }
    
    
    
    func showBrandView(superView : UIView , moveType : MoveType , requestPara : ServiceRequest, drivers: [HomeDriver]?) {
        
        self.drivers = drivers
        request = requestPara
        
        if self.drivers != nil {
            getEstimateDistanceAndTime()
        }
        
        guard var brandList = requestPara.serviceSelected?.brands else{return}
        
        brandList = brandList.filter { if let intVal = ($0.products?.count)  {
            return intVal > 0
            }
            return false
        }

        brands.removeAll()
        brands.append(contentsOf: brandList)
        
        self.frame = CGRect(x: BookingPopUpFrames.XPopUp, y: (superView.frame.origin.y + superView.frame.size.height) + 10 , width: BookingPopUpFrames.WidthPopUp, height: heightPopUp)
     
        if !isAdded {
            viewSuper = superView
            superView.addSubview(self)
            configureCollectionView()
            isAdded = true
        }
        
        if moveType == .Forward && brands.count > 0 {
            
            request?.selectedBrand = brands[0]
            self.collectionViewDataSource?.items = brands
            ez.runThisAfterDelay(seconds: 0.1, after: { [weak self] in
                self?.collectionViewBrands.reloadData()
            })
        }
        let count = CGFloat(brands.count)
        constraintWidthCollection.constant = getCollectionCellWidth(count: count) * count
        maximizeSelectBrandView()
    }
    
    private func getCollectionCellWidth(count: CGFloat) -> CGFloat {
        let count = 4//brands.count
//        if count > 4 {
//            count = 4
//        } else if count < 3 {
//            count = 3
//        }
        let widthCollection = BookingPopUpFrames.WidthPopUp-32.0
        return widthCollection/CGFloat(count)
    }
    
    private func configureCollectionView() {
        
        let configureCellBlock : ListCellConfigureBlockCab = {
            [weak self] (cell, item, indexPath) in
            
            if let cell = cell as? SelectBrandCell, let model = item as? Brand {
                
                guard let brand = self?.request?.selectedBrand else {return}
                cell.indexPath = indexPath
                cell.markAsSelected(selected: model.categoryBrandId == brand.categoryBrandId, model: model, drivers: self?.drivers, estimatedDistanceInKm: self?.estimatedDistanceInKm, estimatedTimeinMins: self?.estimatedTimeinMins, request: self?.request)
            }
        }
        
        let didSelectBlock : DidSelectedRowCab = {
            [weak self] (indexPath, cell, item) in
            
            if let _ = cell as? SelectBrandCell, let model = item as? Brand {
                self?.request?.selectedBrand = model
                self?.collectionViewBrands.reloadData()
            }
        }
        
        let widthColl = getCollectionCellWidth(count: CGFloat(brands.count))
//        let widthColl = collectionViewBrands.frame.size.width/3
        let heightColl = collectionViewBrands.frame.height///2.5
        
        collectionViewDataSource = CollectionViewDataSourceCab(
            items: brands,
            collectionView: collectionViewBrands,
            cellIdentifier: R.reuseIdentifier.selectBrandCell.identifier,
            cellHeight: heightColl,
            cellWidth: widthColl,
            configureCellBlock: configureCellBlock,
            aRowSelectedListener: didSelectBlock)
        
        collectionViewBrands.delegate = collectionViewDataSource
        collectionViewBrands.dataSource = collectionViewDataSource
        collectionViewBrands.reloadData()
        
    }
  
}


//MARK:- Direction API
extension SelectBrandView {
    func getEstimateDistanceAndTime() {
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(/request?.latitudeDest),\(/request?.longitudeDest)&destination=\(/request?.latitude),\(/request?.longitude)&sensor=true&mode=driving&key=\(/UDSingleton.shared.appSettings?.appSettings?.ios_google_key)"
        
        guard let url = URL(string: urlString) else {return}
        
        let task = session.dataTask(with: url, completionHandler: {[weak self] (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }else {
                do {
                    
                    if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
                        
                        ez.runThisInMainThread {
                            
                            guard let routes = json["routes"] as? NSArray else { return }
                            
                            if (routes.count > 0) {
                                let overview_polyline = routes[0] as? NSDictionary
                            
                                guard let legs  = overview_polyline , let legsJ = legs["legs"] as? NSArray , let lg = legsJ[0] as? NSDictionary else { return }
                                
                                guard  let distance = lg["distance"] as? NSDictionary  ,  let distanceLeftMeters =  distance.object(forKey: "value") as? Int, let time = lg["duration"] as? NSDictionary,  let timeInSeconds =  time.object(forKey: "value") as? Int else { return }
                                
                                self?.estimatedDistanceInKm = Float(Float(distanceLeftMeters)/1000)
                                self?.estimatedTimeinMins = Int(Float(timeInSeconds)/60)
                                self?.collectionViewBrands.reloadData()
                            }
                        }
                    }
                }catch {
                    print("error in JSONSerialization")
                }
            }
        })
        task.resume()
    }
}
