//
//  SelectServiceView.swift
//  Buraq24
//
//  Created by MANINDER on 28/08/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit



class SelectServiceView: UIView, iCarouselDataSource, iCarouselDelegate {
    
    //MARK:- Outlets
    @IBOutlet var collectionViewServices: UICollectionView!
    @IBOutlet var lblSelectedService: UILabel?
    @IBOutlet var lblLocationName: UILabel!
    @IBOutlet var viewCrousal: iCarousel!
    @IBOutlet var btnNextService: UIButton!
    @IBOutlet weak var crousalHeightCOnstant: NSLayoutConstraint!
    @IBOutlet var imgViewLocationtype: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var btnSelectLocation: RoundShadowButton!
    @IBOutlet weak var lblSubTitle: UILabel!
    
    
    //MARK:- Properties
    var previousIndex : Int = -1
    
    var collectionViewDataSource : CollectionViewDataSourceCab?
    var services : [Service] = [Service]()
    var heightPopUp : CGFloat = 320
    var viewSuper : UIView?
    var request : ServiceRequest?
    var delegate : BookRequestDelegate?
    let reuseIdentifier = "ServiceCell"
  

    lazy var serviceLocal = [ServiceTypeCab]()
    
    var firstTime = false
    var isAdded : Bool = false
    
    
    override func awakeFromNib() {
        btnSelectLocation.setButtonWithBorderColorSecondary()
        btnSelectLocation.addShadowToViewColorSecondary()

        let template = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
        switch template {
        case .GoMove:
            btnSelectLocation.setTitle("ServiceView.Where_you_want_to_deliver".localizedString + ".", for: .normal)
            lblSelectedService?.isHidden = true
            break
            
        case .DeliverSome:
            print("Deliver Some")
            btnSelectLocation.setTitle("ServiceView.Where_you_want_to_deliver".localizedString + "?", for: .normal)
            lblSelectedService?.isHidden = true
            break
            
        case .Corsa:
            lblSelectedService?.isHidden = true
            break
            
        default:
            print("Defualt")
        }
    }
    
    
    //MARK:- Actions
    @IBAction func actionBtnSelectLocation(_ sender: UIButton) {
        
        let idCateGory = /request?.serviceSelected?.serviceCategoryId
        if idCateGory == 5  {
            Alerts.shared.show(alert: "AppName".localizedString, message: "coming_soon".localizedString , type: .error )
        }else{
            
            let template = AppTemplate(rawValue: /UDSingleton.shared.appTerminology?.key_value?.template?.toInt())
            
            switch template {
           
            case .Default?:
                self.delegate?.didSelectNext(type: .SelectLocation)
                
            case .Mover?:
                self.delegate?.didSelectNext(type: .SelectingFreightBrand)
                
            default:
                break
                
            }
            
            minimizeSelectServiceView()
        }
    }
    
    //MARK:- Functions
    /// Configure Service CollectionView
    func configureServiceCollectionView() {
        
        viewCrousal.delegate = self
        viewCrousal.dataSource = self
        viewCrousal.type = .linear
        //viewCrousal.isVertical = true
        viewCrousal.currentItemIndex = numberOfItems(in: viewCrousal)/2
        
        if   UIDevice.current.userInterfaceIdiom == .pad{
            self.crousalHeightCOnstant.constant = 120.0
        } else {
             self.crousalHeightCOnstant.constant = 100
        }
    }
    
    private func updateSelectedText(_ strText : String) {
        lblSelectedService?.text = strText
        print("lable3 : \(/lblSelectedService?.text)")
    }
    
    func minimizeSelectServiceView() {
        
        let heightPopUp = UIDevice.current.iPhoneX ? self.heightPopUp + 34 : self.heightPopUp
        
        UIView.animate(withDuration: 0.3, animations: {
            [weak self] in
            self?.frame = CGRect(x: 0 , y: /self?.viewSuper?.frame.origin.y + /self?.viewSuper?.frame.size.height  + 20, width: BookingPopUpFrames.WidthFull, height: heightPopUp)
            }, completion: { (done) in
        })
    }
    
    func maximizeSelectServiceView() {
        
        
        if services.count == 1 {
            lblSelectedService?.isHidden = true
            viewCrousal.isHidden = true
            self.backgroundColor = UIColor.clear
        } else {
            lblSelectedService?.isHidden = false
            viewCrousal.isHidden = false
            self.backgroundColor = UIColor.white
            collectionViewServices.isHidden = true
        }
        
//         let template = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
//           switch template {
//           case .DeliverSome:
//                viewCrousal.isHidden = true
//                self.backgroundColor = UIColor.clear
//                break
//
//           case .GoMove:
//                viewCrousal.isHidden = true
//                self.backgroundColor = UIColor.clear
//                break
//
//           case .Corsa:
//                viewCrousal.isHidden = true
//                self.backgroundColor = UIColor.clear
//                break
//
//           case .Delivery20:
//                viewCrousal.isHidden = false
//                self.backgroundColor = UIColor.white
//                collectionViewServices.isHidden = true
//                self.lblSelectedService?.isHidden = true
//
//            break
//
//           default:
//                viewCrousal.isHidden = false
//                self.backgroundColor = UIColor.white
//                collectionViewServices.isHidden = true
//
//
//           }
    //    lblSubTitle.setAlignment()
      //  btnSelectLocation.setAlignment()
        
        
        let heightPopUp = UIDevice.current.iPhoneX ? self.heightPopUp + 34 : self.heightPopUp
        UIView.animate(withDuration: 0.3, animations: {
            [weak self] in
            self?.frame = CGRect(x: 0, y: (/self?.viewSuper?.frame.origin.y + /self?.viewSuper?.frame.size.height) - heightPopUp + 10 , width: BookingPopUpFrames.WidthFull, height: heightPopUp)
            }, completion: {
                (done) in
        })
    }
    
    func showSelectServiceView(superView: UIView, moveType: MoveType, requestPara: ServiceRequest, service: [Service],fromPackage:Bool = false) {
        
        labelName.text = "Hi ".localizedString + /UDSingleton.shared.userData?.userDetails?.user?.name
        btnNextService.setImage(#imageLiteral(resourceName: "NextMaterial").setLocalizedImage(), for: .normal)
        request = requestPara
        
         if let index = GDataSingleton.sharedInstance.selectedServiceIndex {
                   if index == .ambulance {
                       guard let objS = service.filter({$0.serviceCategoryId == 10}).first else {return}
                       services = [objS]
                   }
                   //deepika 4
                   else if index == .pickup {
                       guard let objS = service.filter({$0.serviceCategoryId == 12}).first else {return}
                       services = [objS]
                   }  else if index == .cab {
                       guard let objS = service.filter({$0.serviceCategoryId == 11}).first else {return}
                       services = [objS]
                   }
               }
               else {
                   services = service
               }
        
       /* layer.cornerRadius = 13.0
        layer.backgroundColor = UIColor.white.cgColor
        layer.shadowOffset = CGSize.zero
        layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.16).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 21 */
            
        if !isAdded {
            viewSuper = superView
            self.frame = CGRect(x: 0, y: (superView.frame.origin.y + superView.frame.size.height) , width: BookingPopUpFrames.WidthFull, height: heightPopUp)
            superView.addSubview(self)
            if fromPackage{
                self.createPackageService()
            }else{
                self.createServices()
            }
            configureServiceCollectionView()
            isAdded = true
        }
        
        if firstTime == false {
           // lblSelectedService?.text = previousIndex == -1 ? /service[3].serviceName : /service[5].serviceName
            firstTime = true
        }
        
        print("lable1 : \(lblSelectedService?.text)")
        
        if  let languageCode = UserDefaultsManager.languageId{
            if languageCode == "3" ||  languageCode == "5" {
                
                lblLocationName.textAlignment = .right
            }else{
                lblLocationName.textAlignment = .left
            }
        }
        maximizeSelectServiceView()
    }
    
    func createPackageService(){
        serviceLocal.removeAll()
        var id = 0
        for service in services{
            id = service.serviceCategoryId ?? 0
        }
        switch id {
        case 4:
            if let objS = services.filter({$0.serviceCategoryId == 4}).first{
                  serviceLocal.append(ServiceTypeCab(serviceName: /objS.serviceName , serviceImageSelected: R.image.freightActive() ?? UIImage(), serviceImageUnSelected: R.image.freightActive() ?? UIImage(), objService: objS))
            }
            
            case 7:
                if let objS = services.filter({$0.serviceCategoryId == 7}).first {
                                     serviceLocal.append(ServiceTypeCab(serviceName: /objS.serviceName , serviceImageSelected: R.image.ic_car_1() ?? UIImage(), serviceImageUnSelected: R.image.ic_car_0() ?? UIImage(), objService: objS))
            }
            
            case 10:
                if let objS = services.filter({$0.serviceCategoryId == 10}).first {
                                     serviceLocal.append(ServiceTypeCab(serviceName: /objS.serviceName , serviceImageSelected: R.image.ambulanceOutline() ?? UIImage(), serviceImageUnSelected: R.image.ambulanceNormal() ?? UIImage(), objService: objS))
            }
          
        default:
            break
        }
    }
    
    
    func createServices() {
        
        serviceLocal.removeAll()
        
        
        for index in 1...services.count {
          
            print("Service Name 33",/services[index - 1].serviceName)
            
            switch /services[index - 1].serviceName {
            case "Ambulance":
                 serviceLocal.append(ServiceTypeCab(serviceName: /services[index - 1].serviceName , serviceImageSelected: R.image.ambulanceOutline() ?? UIImage(), serviceImageUnSelected: R.image.ambulanceNormal() ?? UIImage(), objService:  services[index - 1]))
                break
                
            case "Pickup Delivery":
                 serviceLocal.append(ServiceTypeCab(serviceName: /services[index - 1].serviceName , serviceImageSelected: R.image.towTruckActive() ?? UIImage(), serviceImageUnSelected: R.image.towTruck() ?? UIImage(), objService:  services[index - 1]))
                break
                
            case "Cab Booking":
                 serviceLocal.append(ServiceTypeCab(serviceName: /services[index - 1].serviceName , serviceImageSelected: R.image.ic_car_1() ?? UIImage(), serviceImageUnSelected: R.image.ic_car_0() ?? UIImage(), objService:  services[index - 1]))
                break
                
            default:
                print("Defual")
                 serviceLocal.append(ServiceTypeCab(serviceName: /services[index - 1].serviceName , serviceImageSelected: R.image.ic_car_1() ?? UIImage(), serviceImageUnSelected: R.image.ic_car_0() ?? UIImage(), objService:  services[index - 1]))
            }
            
            
            
//            serviceLocal.append(ServiceType(serviceName: /services[index - 1].serviceName , serviceImageSelected: R.image.ic_car_1() ?? UIImage(), serviceImageUnSelected: R.image.ic_car_0() ?? UIImage(), objService:  services[index - 1]))
            

          /*  switch index {
            case 1 :
                
                //                serviceLocal.append( ServiceType.init(serviceName: /services[index - 1].serviceName , serviceImageSelected: R.image.gasActive() ?? UIImage(), serviceImageUnSelected: R.image.gas() ?? UIImage()))
                break
            case 2:
                //                serviceLocal.append( ServiceType.init(serviceName: /services[index - 1].serviceName , serviceImageSelected: R.image.drinkingWaterActive() ?? UIImage(), serviceImageUnSelected: R.image.drinkingWater() ?? UIImage()))
                break
            case 3:
                //                serviceLocal.append( ServiceType.init(serviceName: /services[index - 1].serviceName , serviceImageSelected: R.image.waterTankerActive() ?? UIImage(), serviceImageUnSelected: R.image.waterTanker() ?? UIImage()))
                break
            case 4:
                
                guard let objS = services.filter({$0.serviceCategoryId == 4}).first else {return}
                serviceLocal.append(ServiceType(serviceName: /objS.serviceName , serviceImageSelected: R.image.towTruckActive() ?? UIImage(), serviceImageUnSelected: R.image.towTruck() ?? UIImage(), objService: objS))
                
                
                           //     serviceLocal.append( ServiceType.init(serviceName: /services[index - 1].serviceName , serviceImageSelected: R.image.freightActive() ?? UIImage(), serviceImageUnSelected: R.image.freight() ?? UIImage()))
                break
            case 5: break
//                let objS = services[3]
//                serviceLocal.append(ServiceType(serviceName: /objS.serviceName , serviceImageSelected: R.image.towTruckActive() ?? UIImage(), serviceImageUnSelected: R.image.towTruck() ?? UIImage(), objService: objS))
                
               
                
                
            case 6:
                // Change here for service
               // let objS = services[5]
                
                let template = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
                switch template {
                case .DeliverSome:
                    break
                    
                case .GoMove:
                    break
                    
                default:
                    guard let objS = services.filter({$0.serviceCategoryId == 7}).first else {return}
                                   serviceLocal.append(ServiceType(serviceName: /objS.serviceName , serviceImageSelected: R.image.ic_car_1() ?? UIImage(), serviceImageUnSelected: R.image.ic_car_0() ?? UIImage(), objService: objS))
                }
                
                
               
            case 7:
             // Change here for service
            // let objS = services[5]
                
                let template = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
                switch template {
                case .DeliverSome:
                    break
                    
                case .GoMove:
                    break
                    
                default:
                    guard let objS = services.filter({$0.serviceCategoryId == 10}).first else {return}
                    serviceLocal.append(ServiceType(serviceName: /objS.serviceName , serviceImageSelected: R.image.ambulanceOutline() ?? UIImage(), serviceImageUnSelected: R.image.ambulanceNormal() ?? UIImage(), objService: objS))
                    
                }
                
                
             
            default:
                break
            } */
        }
        
        
        collectionViewServices.reloadData()
    }
    
    
    func getServiceIndex(id:Int)->Int?{
        
        if let index = self.serviceLocal.firstIndex(where: {/$0.objService.serviceCategoryId == id}){
            viewCrousal.scrollToItem(at: index, animated: true)
            return index
        }
        return nil
    }
    
    //MARK:- iCrousal  Delegate & Data Source
    func numberOfItems(in carousel: iCarousel) -> Int {
        return self.serviceLocal.count//*10000
    }
    
    func carouselWillBeginScrollingAnimation(_ carousel: iCarousel) {
        if  let imageview = carousel.currentItemView as? UIImageView {
            let lcoalIndex = carousel.currentItemIndex % self.serviceLocal.count
            let localObj = self.serviceLocal[lcoalIndex]//(lblSelectedService.text == "Trucks") ? self.serviceLocal[0] : self.serviceLocal[1]
            imageview.image = localObj.serviceImageUnSelected
        }
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        
    }
    
    func carouselDidScroll(_ carousel: iCarousel) {
    }
    
    func carouselDidEndScrollingAnimation(_ carousel: iCarousel) {
        
        if let imageview = carousel.currentItemView as? UIImageView {
            let lcoalIndex = carousel.currentItemIndex % self.serviceLocal.count
            let localObj = self.serviceLocal[lcoalIndex]
            
            UIView.transition(with: imageview,
                              duration:0.6,
                              options: .transitionCrossDissolve,
                              animations: {
                                imageview.image = localObj.serviceImageSelected
                                imageview.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)},
                              completion: nil)
            
            if   previousIndex !=  carousel.currentItemIndex {
                carousel.reloadItem(at: previousIndex, animated: false)
            }
            
            previousIndex = carousel.currentItemIndex
            
            lblSelectedService?.text =  localObj.serviceName
            request?.serviceSelected = localObj.objService
            
            delegate?.didSelectServiceType(localObj.objService)
            
            let idCateGory = /localObj.objService.serviceCategoryId
            imgViewLocationtype.image = idCateGory > 3 ? #imageLiteral(resourceName: "PickUpIcon") : #imageLiteral(resourceName: "DropIcon")
        }
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        let template = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
        
        if /template?.rawValue == 6 {
            

            var containerView : UIView
            var itemView = UIImageView()
            itemView.contentMode = .center
            
            var lblTitle = UILabel()
            lblTitle.adjustsFontSizeToFitWidth = true
            lblTitle.minimumScaleFactor = 0.5
            lblTitle.textAlignment = .center
            lblTitle.font.withSize(10)
            
            //reuse view if available, otherwise create a new view
            
            let indexnew = index % self.serviceLocal.count
            let localObj = self.serviceLocal[indexnew]
            
            itemView.setCornerRadius(radius: 35)
            if let view = view as? UIView {
                containerView = view
                
                for subView in view.subviews{
                    
                    if subView.isKind(of: UIImageView.self){
                        
                        itemView = (subView as! UIImageView)
                        
                    }
                    else if subView.isKind(of: UIImageView.self){
                        
                        lblTitle = (subView as! UILabel)
                    }
                }
                
                
            } else {
                if   UIDevice.current.userInterfaceIdiom == .pad {
                    containerView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 130))
                    itemView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
                    lblTitle = UILabel(frame: CGRect(x: 0, y: 105, width: 100, height: 20))
                    containerView.addSubview(itemView)
                           containerView.addSubview(lblTitle)
                } else {
                    containerView = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 100))
                     itemView = UIImageView(frame: CGRect(x: 10, y: 0, width: 68, height: 68))
                     lblTitle = UILabel(frame: CGRect(x: 0, y: 75, width: 100, height: 20))
    //                    lblTitle.adjustsFontSizeToFitWidth = true
    //                    lblTitle.minimumScaleFactor = 0.5
                           lblTitle.textAlignment = .center
                           lblTitle.font.withSize(10)
                    containerView.addSubview(itemView)
                           containerView.addSubview(lblTitle)
                }
            }
            
            
            
            lblSelectedService?.text = localObj.serviceName
            lblTitle.text = localObj.serviceName
            lblTitle.textColor = UIColor.black
            print("Label3 :\(localObj.serviceName)")
            itemView.clipsToBounds = false
            itemView.layer.shadowColor = UIColor.lightGray.cgColor
            itemView.layer.shadowOpacity = 0.4
            itemView.layer.shadowOffset = CGSize.zero
            itemView.layer.shadowRadius = 5
            itemView.layer.shadowPath = UIBezierPath(roundedRect: itemView.bounds, cornerRadius: 35).cgPath
            itemView.image = localObj.serviceImageUnSelected
            
            return containerView
            
        } else {
            
            var itemView: UIImageView
            //reuse view if available, otherwise create a new view
            if let view = view as? UIImageView {
                itemView = view
            } else {
                if   UIDevice.current.userInterfaceIdiom == .pad {
                    itemView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
                } else {
                    itemView = UIImageView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
                }
            }
    
            let indexnew = index % self.serviceLocal.count
            let localObj = self.serviceLocal[indexnew]
    
            itemView.setCornerRadius(radius: 35)
    
            lblSelectedService?.text = localObj.serviceName
            print("Label3 :\(localObj.serviceName)")
            itemView.clipsToBounds = false
            itemView.layer.shadowColor = UIColor.lightGray.cgColor
            itemView.layer.shadowOpacity = 0.4
            itemView.layer.shadowOffset = CGSize.zero
            itemView.layer.shadowRadius = 5
            itemView.layer.shadowPath = UIBezierPath(roundedRect: itemView.bounds, cornerRadius: 35).cgPath
            itemView.image = localObj.serviceImageUnSelected
            return itemView
        }
        
    }

//    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
//
//        var itemView: UIImageView
//        //reuse view if available, otherwise create a new view
//        if let view = view as? UIImageView {
//            itemView = view
//        } else {
//            if   UIDevice.current.userInterfaceIdiom == .pad {
//                itemView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//            } else {
//                itemView = UIImageView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
//            }
//        }
//
//        let indexnew = index % self.serviceLocal.count
//        let localObj = self.serviceLocal[indexnew]
//
//        itemView.setCornerRadius(radius: 35)
//
//        lblSelectedService?.text = localObj.serviceName
//        print("Label3 :\(localObj.serviceName)")
//        itemView.clipsToBounds = false
//        itemView.layer.shadowColor = UIColor.lightGray.cgColor
//        itemView.layer.shadowOpacity = 0.4
//        itemView.layer.shadowOffset = CGSize.zero
//        itemView.layer.shadowRadius = 5
//        itemView.layer.shadowPath = UIBezierPath(roundedRect: itemView.bounds, cornerRadius: 35).cgPath
//        itemView.image = localObj.serviceImageUnSelected
//        return itemView
//    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            return value * 1.50
        }
        return value
    }

    func carousel(_ carousel: iCarousel, shouldSelectItemAt index: Int) -> Bool {
        return true
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
    }
}

extension SelectServiceView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return self.serviceLocal.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! ServiceCellCab

        let localObj = self.serviceLocal[indexPath.row]
        cell.imgViewService.image = localObj.serviceImageUnSelected
        cell.lblTitle.text = localObj.serviceName
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        collectionViewServices.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        let localObj = self.serviceLocal[indexPath.row]
        delegate?.didSelectServiceType(localObj.objService)

    }
    
    func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: nil, completion: { _ in
            if let currentFocused = (self.collectionViewServices?.collectionViewLayout as? FocusedContaining)?.currentInFocus {
                let indexPath = IndexPath(item: currentFocused, section: 0)
                self.collectionViewServices.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
            }
            self.collectionViewServices?.collectionViewLayout.invalidateLayout()
        })
    }
   


}

