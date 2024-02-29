//
//  HomeExtensions.swift
//  Buraq24
//
//  Created by MANINDER on 13/08/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import Foundation
import UIKit
import GooglePlaces
import GoogleMaps
import SideMenu
import Alamofire
import ObjectMapper

enum MenuType : String {
    case Left = "Left"
    case Right = "Right"
}


struct PolylineCab{
    static var points = ""
}

struct BookingPopUpFrames {
    
    static var navigationBarHeight : CGFloat {
        return  UIDevice.current.iPhoneX ? CGFloat(88) : CGFloat(64)
    }
    static var statusBarHeight : CGFloat {
        return  UIDevice.current.iPhoneX ? CGFloat(44) : CGFloat(20)
    }
    
    static  var navigationTopPadding = CGFloat(10)
    static let WidthPopUp = UIScreen.main.bounds.size.width // Ankush UIScreen.main.bounds.size.width*94/100
    static let XPopUp = UIScreen.main.bounds.size.width*3/100
    static let WidthFull = UIScreen.main.bounds.size.width
    static let PaddingX = 13
    static let WidthSideMenu =  Int(Float(ez.screenWidth/1.5))
    static let WidthHalfSideMenu =  Int(Float(ez.screenWidth/1.5)/2)
    
    static var paddingX : CGFloat {
        return  UIDevice.current.iPhoneX ? CGFloat(110) : CGFloat(95)
    }
    
    static var paddingXDropOffLocation : CGFloat {
        return  UIDevice.current.iPhoneX ? CGFloat(155) : CGFloat(135)
    }
    static var paddingXPickUpLocation : CGFloat {
        return  UIDevice.current.iPhoneX ? CGFloat(215) : CGFloat(200)
    }
}

extension HomeVC : DateSelectedlDelegate {
    
    func showSchedular(date: Date, minDate: Date) {
        
        guard let schedularVC = R.storyboard.bookService.schedulerVC() else { return }
        schedularVC.minDate = minDate
        schedularVC.view.backgroundColor = UIColor.colorDarkGrayPopUp
        schedularVC.modalPresentationStyle = .overCurrentContext
        schedularVC.modalTransitionStyle = .crossDissolve
        schedularVC.previousSeletectedDate = date
        schedularVC.delegateDate = self
        presentVC(schedularVC, true)
        
    }
    
    func didSelectedDate(date: Date) {
        viewScheduler.updateData(date: date)
        serviceRequest.orderDateTime = date
    }
}

//MARK:- RequestCancelDelegate
extension HomeVC : RequestCancelDelegate {
    
    func setUpSideMenuPanels() {
        
        guard let menuListVC =  R.storyboard.bookService.menuViewController() else {return}
        guard let supportListVC =  R.storyboard.bookService.rightMenuViewController() else {return}
        if let languageCode = UserDefaultsManager.languageId {
            switch languageCode {
            case "3" , "5" :
                setUpLeftSideMenu(controller: supportListVC)
                setUpRightSideMenu(controller: menuListVC)
            default:
                
                setUpLeftSideMenu(controller: menuListVC)
                setUpRightSideMenu(controller: supportListVC)
            }
        }
    }
    
    func setUpLeftSideMenu(controller : UIViewController) {
        
        //        SideMenuManager.default.menuWidth = CGFloat(BookingPopUpFrames.WidthSideMenu)
        //        SideMenuManager.default.menuPresentMode = .menuSlideIn
        //        SideMenuManager.default.menuFadeStatusBar = false
        //        menuLeftNavigationController = UISideMenuNavigationController(rootViewController: controller)
        //
        //        menuLeftNavigationController?.navigationBar.isHidden = true
        //        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        
        menuLeftNavigationController = SideMenuNavigationController(rootViewController: controller)
        menuLeftNavigationController?.leftSide = true
        menuLeftNavigationController?.menuWidth = CGFloat(BookingPopUpFrames.WidthSideMenu)
        menuLeftNavigationController?.presentationStyle = .menuSlideIn
        menuLeftNavigationController?.navigationBar.isHidden = true
        // (Optional) Prevent status bar area from turning black when menu appears:
        menuLeftNavigationController?.statusBarEndAlpha = 0
        SideMenuManager.default.leftMenuNavigationController = menuLeftNavigationController
        
    }
    
    func presentMenu(type : MenuType) {
        
        if type == .Left{
            if let languageCode = UserDefaultsManager.languageId {
                
                guard let navRight = menuRightNavigationController else {return}
                
                guard let navLeft = menuLeftNavigationController else {return}
                
                if languageCode == "3" ||  languageCode == "5" {
                    
                    type == .Left ? self.present(navRight, animated: true, completion: nil) : self.present(navLeft, animated: true, completion: nil)
                }else {
                    
                    type == .Left ? self.present(navLeft, animated: true, completion: nil) : self.present(navRight, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    func setUpRightSideMenu(controller : UIViewController) {
        
        //   guard let width = BookingPopUpFrames.WidthSideMenu else{return}
        
        //        SideMenuManager.default.menuWidth = CGFloat(BookingPopUpFrames.WidthSideMenu)
        //        SideMenuManager.default.menuPresentMode = .menuSlideIn
        //        SideMenuManager.default.menuFadeStatusBar = false
        //        menuRightNavigationController = UISideMenuNavigationController(rootViewController: controller)
        //        menuRightNavigationController?.navigationBar.isHidden = true
        //        SideMenuManager.default.menuRightNavigationController = menuRightNavigationController
        
        menuRightNavigationController = SideMenuNavigationController(rootViewController: controller)
        menuRightNavigationController?.leftSide = false
        menuRightNavigationController?.menuWidth = CGFloat(BookingPopUpFrames.WidthSideMenu)
        menuRightNavigationController?.presentationStyle = .menuSlideIn
        menuRightNavigationController?.navigationBar.isHidden = true
        // (Optional) Prevent status bar area from turning black when menu appears:
        menuRightNavigationController?.statusBarEndAlpha = 0
        SideMenuManager.default.rightMenuNavigationController = menuRightNavigationController
    }
    
    func showCancellationFormVC() {
        
        guard let orderId = currentOrder?.orderId else{return}
        guard let formCancelation = R.storyboard.bookService.cancellationVC() else { return }
        
       // formCancelation.view.backgroundColor = UIColor.colorDarkGrayPopUp
        formCancelation.modalPresentationStyle = .overCurrentContext
        formCancelation.modalTransitionStyle = .crossDissolve
        formCancelation.orderId = orderId
        formCancelation.delegateCancellation = self
        presentVC(formCancelation, true)
    }
    
    func didSuccessOnCancelRequest() {
        viewDriverAccepted.minimizeDriverView()
        (ez.topMostVC as? OngoingRideDetailsViewController)?.dismissVC(completion: nil)
        moveToNormalMode()
        
        // To move to Home in case of Package
        if /isFromPackage {
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func didSuccessOnHalfWayStopped() {
        viewDriverAccepted.minimizeDriverView()
        showProcessingView(moveType: .Forward, isHalfWayStop: true)
    }
    
    func didSuccessOnVehicleBreakdown() {
        viewDriverAccepted.minimizeDriverView()
        showProcessingView(moveType: .Forward, isVehicleBreakdown: true)
    }
    
    func checkCancellationPopUp() {
        
        if let topVC =  ez.topMostVC {
            if (topVC  is CancellationVC) {
                guard let order = currentOrder else{return}
                NotificationCenter.default.post(name: Notification.Name(rawValue: LocalNotifications.DismissCancelPopUp.rawValue), object: order)
            }
        }
    }
    
    func showWorkingProgressVC() {
        
        guard let formProgressVC = R.storyboard.mainCab.workProgressVC() else{return}
        formProgressVC.view.backgroundColor = UIColor.colorDarkGrayPopUp
        formProgressVC.modalPresentationStyle = .overCurrentContext
        formProgressVC.modalTransitionStyle = .crossDissolve
        presentVC(formProgressVC, true)
    }
}

//MARK:- EditLocationViewControllerDelegate
extension HomeVC: EditLocationViewControllerDelegate {
    
    func ongoingRideLocationEdited(order: OrderCab?) {
        
        viewDriverAccepted.orderCurrent = order
        currentOrder = order
        
        
        let source = CLLocationCoordinate2D(latitude: CLLocationDegrees(/currentOrder?.driverAssigned?.driverLatitude) , longitude: CLLocationDegrees(/currentOrder?.driverAssigned?.driverLongitude))
        let destination = CLLocationCoordinate2D(latitude: CLLocationDegrees(/currentOrder?.dropOffLatitude) , longitude: CLLocationDegrees(/currentOrder?.dropOffLongitude))
        
        let stops = currentOrder?.orderStatus == .Ongoing ? currentOrder?.ride_stops : nil
        currentOrder?.orderStatus == .Ongoing ? getPolylineRoute(source: source , destination: destination, stops: stops, model: nil) : debugPrint("Order not ongoing yet")
    }
}

//MARK:- Show  Moving Drivers on Map
//MARK:-

extension HomeVC {
    
    func addForgroundObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(HomeVC.getUpdatedStatus), name: Notification.Name(rawValue: LocalNotifications.AppInForground.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeVC.appTimedOut), name: Notification.Name(rawValue: UserInactivity.ApplicationDidTimoutNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(internetReachablity), name: Notification.Name(rawValue: LocalNotifications.InternetConnected.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(internetNotReachable), name: Notification.Name(rawValue: LocalNotifications.InternetDisconnected.rawValue), object: nil)
    }
    
    @objc  func getUpdatedStatus() {
        
        if  let service = serviceRequest.serviceSelected {
            getLocalDriverForParticularService(service: service)
        }
        
        checkForLocationPermissoion()
    }
    
    @objc  func appTimedOut() {
        print("timeed out")
    }
    
    @objc  func internetReachablity(){
        getUpdatedData()
        
    }
    @objc  func internetNotReachable(){
        
        Alerts.shared.show(alert: "Validation.InternetNotWorking".localizedString, message: "AppName".localizedString, type: .error)
        
    }
    
    // sandeep kumar to add road api
    
    @objc func getNearByDrivers() {
        
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        
        guard let point = mapView.center as? CGPoint else {return}
        let coordinate = mapView.projection.coordinate(for: point)
        
        let dictParam : [String : Any] = [EmitterParams.EmitterType.rawValue :  CommonEventType.CustomerHomeMap.rawValue ,
                                          EmitterParams.AccessToken.rawValue : token ,
                                          EmitterParams.Latitude.rawValue :  /coordinate.latitude  ,
                                          EmitterParams.Longitude.rawValue : /coordinate.longitude,
                                          EmitterParams.CategoryId.rawValue : currentService,
                                          EmitterParams.Distance.rawValue : 50 ]
        
        SocketIOManagerCab.shared.emitMapLocation(dictParam) { [weak self](response) in
            
            print("drivers updatimg")
            
            if let list = response as? DriverList {
                
                if let drivers = list.drivers {
                
                    self?.drivers = drivers
                    
                    if drivers.isEmpty{
                        self?.showMovingDrivers(newResponse: [])
                    }
                        
                    else  if ApplicationTimeout.isTimedOut{
                        self?.showMovingDrivers(newResponse: drivers)
                    }
                    else{
                        self?.getNearestRoadForEachDriver(drivers)
                    }
                }
            }
        }
    }
    
    func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
    func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }
    
    func degreeBearing(fromCoordinate fromLoc: CLLocationCoordinate2D, toCoordinate toLoc: CLLocationCoordinate2D) -> Float {
        
        let fLat: Float = /Float(degreesToRadians(degrees: fromLoc.latitude))
        let fLng: Float = /Float(degreesToRadians(degrees: fromLoc.longitude))
        let tLat: Float = /Float(degreesToRadians(degrees: toLoc.latitude))
        let tLng: Float = /Float(degreesToRadians(degrees: toLoc.longitude))
        let degree: Double = radiansToDegrees(radians: /Double(atan2(sin(tLng - fLng) * cos(tLat), cos(fLat) * sin(tLat) - sin(fLat) * cos(tLat) * cos(tLng - fLng))))
        if degree >= 0 {
            return Float(degree)
        } else {
            return Float(360 + degree)
        }
    }
    
    func getNearestRoadForEachDriver(_ drivers: [HomeDriver]?) {
        var latLngArray = [String]()
        drivers?.forEach{
            latLngArray.append("\($0.latitude ?? 0.0),\($0.longitude ?? 0.0)")
            //            latLngArray.append("\(($0.latitude ?? 0.0)  + 0.0001 ),\(($0.longitude ?? 0.0) + 0.0001)")
        }
        
        let driversToModify = drivers
        let latLngsString = latLngArray.joined(separator: "|")
        
        let snapToRoadURL = "https://roads.googleapis.com/v1/nearestRoads?points=\(latLngsString)&key=\(/UDSingleton.shared.appSettings?.appSettings?.ios_google_key)"
        let encodedUrl = snapToRoadURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        Alamofire.request(encodedUrl, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { [weak self] (response) in
            do {
                
                let json = try JSONSerialization.jsonObject(with: response.data ?? Data(), options: []) as? [String : Any]
                let dictArray = json?["snappedPoints"] as? [[String: Any]]
                var roadSnapLatLngs = [RoadSnap]()
                dictArray?.forEach({ (dict) in
                    roadSnapLatLngs.append(RoadSnap(map: Map(mappingType: .fromJSON, JSON: dict))!)
                })
                
                driversToModify?.forEachEnumerated({ (index, driver) in
                    driver.latitude = roadSnapLatLngs.filter({$0.originalIndex == index}).first?.location?.latitude
                    driver.longitude = roadSnapLatLngs.filter({$0.originalIndex == index}).first?.location?.longitude
                })
                
                self?.showMovingDrivers(newResponse: driversToModify ?? [])
                
                //                let json = try JSONSerialization.jsonObject(with: response.data ?? Data(), options: []) as? [String : Any]
                //                let dictArray = json?["snappedPoints"] as? [[String: Any]]
                //                var roadSnapLatLngs = [RoadSnap]()
                //
                //                dictArray?.forEach({ (dict) in
                //                    roadSnapLatLngs.append(RoadSnap(map: Map(mappingType: .fromJSON, JSON: dict))!)
                //                })
                
                //                drivers?.forEachEnumerated({ (indx , dict) in
                //                roadSnapLatLngs =  roadSnapLatLngs.filter({$0.originalIndex == indx})
                //                })
                //
                //                var bearingArray :[Float]?
                //                roadSnapLatLngs.forEachEnumerated({ (indx , dict) in
                //
                //                    if  indx % 2 == 1{
                //
                //                        let val = self?.degreeBearing(fromCoordinate: CLLocationCoordinate2D.init(latitude:/roadSnapLatLngs[indx - 1].location?.latitude , longitude: /roadSnapLatLngs[indx - 1].location?.longitude), toCoordinate: CLLocationCoordinate2D.init(latitude: /roadSnapLatLngs[indx].location?.latitude, longitude: /roadSnapLatLngs[indx].location?.longitude))
                //
                //                        print(/roadSnapLatLngs[indx - 1].location?.latitude )
                //                        print(/roadSnapLatLngs[indx].location?.latitude)
                //                        print(/roadSnapLatLngs[indx - 1].location?.longitude )
                //                        print(/roadSnapLatLngs[indx].location?.longitude)
                //                        bearingArray?.append(/val)
                //                        print("bearing calc \(/val)")
                //                    }
                //                })
                
                //                driversToModify?.forEachEnumerated({ (index, driver) in
                //
                //                    driver.latitude = roadSnapLatLngs.filter({$0.originalIndex == index}).first?.location?.latitude
                //                    driver.longitude = roadSnapLatLngs.filter({$0.originalIndex == index}).first?.location?.longitude
                ////                    driver.bearingValue =  bearingArray?[index] ?? 0.0
                //
                //                    print("bearing send \(/driver.bearingValue)")
                //                })
                //
                //                self?.showMovingDrivers(newResponse: driversToModify ?? [])
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func showMovingDrivers(newResponse: [HomeDriver]) {
        
        var previousDrivers : [MovingVehicle] = []
        previousDrivers.append(contentsOf: movingDrivers)
        movingDrivers.removeAll()
        
        newResponse.forEachEnumerated { [weak self] (indexObject, item) in
            
            let previousPin = previousDrivers.filter{($0.driver.driverUserId == item.driverUserId)}
            
            if previousPin.count > 0 {
                
                let firstObj = previousPin[0]
                let objDriver = firstObj.driver
                
                let oldLocation = CLLocation(latitude: /objDriver.latitude, longitude: /objDriver.longitude)
                let newLocation = CLLocation(latitude:  /item.latitude, longitude: /item.longitude)
                
                guard   let index  =  previousDrivers.index(where: { $0.driver.driverUserId == firstObj.driver.driverUserId }) else{return}
                previousDrivers.remove(at: index)
                
                if GoogleMapsDataSource.getDistance(newPosition: newLocation, previous:  oldLocation) > 5 {
                    
                    let newCordinates = CLLocationCoordinate2D(latitude: /item.latitude, longitude: /item.longitude)
                    
                    objDriver.latitude = /item.latitude
                    objDriver.longitude = /item.longitude
                    objDriver.bearingValue = /item.bearingValue
                    //Bearing from Driver Socket
                    guard let bearing = item.bearingValue else {return}
                    self?.animateVehicle(bearing: bearing , newCoordinate: newCordinates, marker: firstObj.driverMarker)
                }
                
                let pinObject = MovingVehicle(driver: objDriver, driverMarker:  firstObj.driverMarker )
                self?.movingDrivers.append(pinObject)
                
                //Get previous Lat and long
            } else {
                self?.showMarkerFirstTime(driver: item, index: indexObject)
            }
        }
        
        for item in previousDrivers {
            ez.runThisInMainThread {
                item.driverMarker.map  = nil;
            }
        }
    }
    
    func showMarkerFirstTime(driver : HomeDriver, index: Int?) {
        
        ez.runThisInMainThread { [weak self] in
            
            let driverPin = GMSMarker()
            driverPin.rotation = CLLocationDegrees(/driver.bearingValue)
            driverPin.position = CLLocationCoordinate2D(latitude: /driver.latitude, longitude:  /driver.longitude)
            driverPin.isFlat = true
            
            let mgVehicle = UIImage().getDriverImage(type: /driver.driverServiceId)
            driverPin.icon  =  mgVehicle.imageWithImage(scaledToSize: vehicleCurrentSize)
            
           /* let imageView = UIImageView(image: R.image.dropMarker())
            imageView.kf.setImage(with: URL(string: /driver.icon_image_url), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
            driverPin.iconView = imageView */
            
            driverPin.zIndex = Int32(/index)
            driverPin.map = self?.mapView
            
            let pinObject = MovingVehicle(driver: driver, driverMarker: driverPin)
            self?.movingDrivers.append(pinObject)
        }
    }
    
    func animateVehicle(bearing : Float ,newCoordinate : CLLocationCoordinate2D , marker : GMSMarker) {
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(3.0)
        marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        marker.rotation = /CLLocationDegrees(bearing)
        marker.position = newCoordinate
        CATransaction.commit()
    }
    
    func startMovingVehicleTimer() {
        
        if let status =  SocketIOManagerCab.shared.getStatus() {
            if status == .disconnected || status == .notConnected {
                SocketIOManagerCab.shared.establishConnection()
            }
        }else {
            SocketIOManagerCab.shared.establishConnection()
        }
        
        getNearByDrivers()
        
        timerMovingVehicle?.invalidate()
        timerMovingVehicle = nil
        timerMovingVehicle = Timer.scheduledTimer(timeInterval: 5 , target: self, selector: #selector(HomeVC.getNearByDrivers), userInfo: nil, repeats: true)
    }
    
    func clearMovingVehicles() {
        cleanPath()
        
        ez.runThisInMainThread { [weak self] in
            self?.timerMovingVehicle?.invalidate()
            self?.timerMovingVehicle = nil
            self?.mapView.clear()
            self?.movingDrivers.removeAll()
        }
    }
}

extension HomeVC {
    
    func showCollectionView(){
        if dataItems.count == 0{
            collectionSavedPlaces?.isHidden = true
        }
        else{
            collectionSavedPlaces?.isHidden = false
        }
    }
    
    func configureSavePlacesCollectionView(){
        
        //        collectionViewPlacesDataSource?.items = dataItems
        //        collectionSavedPlaces?.reloadData()
        
        
        collectionViewPlacesDataSource = CollectionViewDataSourceCab(items: self.dataItems, collectionView: collectionSavedPlaces, cellIdentifier: R.reuseIdentifier.placesSavedCell.identifier, cellHeight: 55, cellWidth: /*collectionSavedPlaces?.contentSize.width ?? 0*/ 120 , configureCellBlock: { ( cell , item , indexPath) in
            guard let cell = cell as? PlacesSavedCell else {return}
            //            guard let model = item as? AddSaveAddresses else {return}
            //            cell.assignData(item: model )
            if self.addSavedPlaces?.isSelected == true {
                cell.lblName?.text = self.dataItems[indexPath.item]
            } else{
                
            }
        })
        
        //        collectionViewPlacesDataSource?.configureCellBlock = configureCellBlock
        
        //        let configureCellBlock : ListCellConfigureBlock = { ( cell , item , indexPath) in
        //            guard let cell = cell as? PlacesSavedCell else {return}
        //            guard let model = item as? AddSaveAddresses else {return}
        //            cell.assignData(item: model )
        //        }
        
        let didSelectBlock : DidSelectedRowCab = { ( indexPath , cell , item) in
            if self.addSavedPlaces?.isSelected == true {
                self.user?.addSaveAddresses?[indexPath.item].name = self.arraySaveName[indexPath.item]
                //                self.user?.addSaveAddresses?[indexPath.item].locationName =
                //                self.user?.addSaveAddresses?[indexPath.item].latitude =
                //                self.user?.addSaveAddresses?[indexPath.item].longitude =
                
                
                self.addSavedPlaces?.isSelected = false
                self.dataItems.removeAll()
                self.collectionViewPlacesDataSource?.items = self.dataItems
                self.collectionSavedPlaces?.reloadData()
                self.showCollectionView()
            }
            else{
                
            }
        }
        
        collectionViewPlacesDataSource?.aRowSelectedListener = didSelectBlock
        
        collectionSavedPlaces?.dataSource = collectionViewPlacesDataSource
        collectionSavedPlaces?.delegate = collectionViewPlacesDataSource
        collectionSavedPlaces?.reloadData()
    }
    
    func configureRecentLocationTableView() {
        
       /* googlePickupLocation = GooglePlaceDataSource(txtField: txtPickUpLocation, resListener: { [weak self] (places) in
            self?.tableDataSource?.items = places
            self?.tblLocationSearch.reloadData()
            
            if !(/self?.viewStop1.isHidden && /self?.viewStop2.isHidden) {
                self?.viewStoppageDesc.isHidden = (places.count > 0)
            }
            // Ankush  self?.viewLocationTableContainer.alpha = CGFloat(places.count)
        })
        
        googleStop1Location = GooglePlaceDataSource(txtField: txtStop1, resListener: { [weak self] (places) in
            self?.tableDataSource?.items = places
            self?.tblLocationSearch.reloadData()
            
            self?.viewStoppageDesc.isHidden = places.count > 0
          // Ankush  self?.viewLocationTableContainer.alpha = CGFloat(places.count)
        })
        
        googleStop2Location = GooglePlaceDataSource(txtField: txtStop2, resListener: { [weak self] (places) in
            self?.tableDataSource?.items = places
            self?.tblLocationSearch.reloadData()
            
            self?.viewStoppageDesc.isHidden = places.count > 0
          // Ankush  self?.viewLocationTableContainer.alpha = CGFloat(places.count)
        })
        
        googleDropOffLocation = GooglePlaceDataSource(txtField: txtDropOffLocation, resListener: {[weak self]  (places) in
            self?.tableDataSource?.items = places
            self?.tblLocationSearch.reloadData()
            
            if !(/self?.viewStop1.isHidden && /self?.viewStop2.isHidden) {
                self?.viewStoppageDesc.isHidden = (places.count > 0)
            }
            
           // Ankush   self?.viewLocationTableContainer.alpha = CGFloat(places.count)
        }) */
        
        let   configureCellBlock :  ListCellConfigureBlockCab? = {  ( cell , item , indexPath) in
            if let cell = cell as? LocationTableViewCell, let model = item as? AddressCab {
                cell.assignData(item: model)
            }
        }
        
        let didSelectBlock : DidSelectedRowCab = {[weak self] ( indexPath , cell , item) in
            
            self?.viewChooseAddress.showView(address: item as? AddressCab)
            
          /*  if  let model = item as? GMSAutocompletePrediction {
                                
                if /self?.txtPickUpLocation.isEditing  {
                    self?.txtPickUpLocation.text = model.attributedFullText.string
                    self?.serviceRequest.locationNameDest = model.attributedFullText.string // Assigning Name of location
                    self?.tempPickUp = model.attributedFullText.string
                    
                } else if /self?.txtStop1.isEditing  {
                    self?.txtStop1.text = model.attributedFullText.string
                    let modal = Stops(latitude: nil, longitude: nil, priority: 1, address: model.attributedFullText.string)
                    self?.serviceRequest.stops.append(modal)
                   // self?.tempStop1 = model.attributedFullText.string
                    
                } else if /self?.txtStop2.isEditing  {
                    self?.txtStop2.text = model.attributedFullText.string
                    let modal = Stops(latitude: nil, longitude: nil, priority: 2, address: model.attributedFullText.string)
                    self?.serviceRequest.stops.append(modal)
                    // self?.tempStop2 = model.attributedFullText.string
                } else {
                    self?.txtDropOffLocation.text = model.attributedFullText.string
                    self?.serviceRequest.locationName = model.attributedFullText.string
                    self?.tempDropOff = model.attributedFullText.string
                }
                self?.locationLatest = model.attributedFullText.string
                self?.getPlaceDetails(strPlaceID: model.placeID)
                
            } */
        }
        
        tableDataSource = TableViewDataSourceCab(items: recentLocations, tableView: tblLocationSearch, cellIdentifier: R.reuseIdentifier.locationTableViewCell.identifier, cellHeight: UITableView.automaticDimension)
        
        tableDataSource?.configureCellBlock = configureCellBlock
        tableDataSource?.aRowSelectedListener = didSelectBlock
        
        tblLocationSearch.delegate = tableDataSource
        tblLocationSearch.dataSource = tableDataSource
        
        tblLocationSearch.reloadData()
    }
    
    func getPlaceDetails(strPlaceID : String?) {
        
        GooglePlaceDataSource.placeDetails(placeID: /strPlaceID) { [weak self](place) in
            guard let placeDetail = place else{return}
            
            
             ///Assign Latitude and LOngitude
            if /self?.txtPickUpLocation.isEditing  {
                
                self?.serviceRequest.latitudeDest =  /placeDetail.coordinate.latitude
                self?.serviceRequest.longitudeDest =  /placeDetail.coordinate.longitude
                
            } else if /self?.txtStop1.isEditing  {
                
                guard var stopsArray = self?.serviceRequest.stops else {return}
                stopsArray[0].latitude = /placeDetail.coordinate.latitude
                stopsArray[0].longitude = /placeDetail.coordinate.longitude
                self?.serviceRequest.stops = stopsArray
                
            } else if /self?.txtStop2.isEditing  {
                
                if /self?.serviceRequest.stops.count > 1 {
                    guard var stopsArray = self?.serviceRequest.stops else {return}
                    stopsArray[1].latitude = /placeDetail.coordinate.latitude
                    stopsArray[1].longitude = /placeDetail.coordinate.longitude
                    self?.serviceRequest.stops = stopsArray
                } else {
                    guard var stopsArray = self?.serviceRequest.stops else {return}
                    stopsArray[0].latitude = /placeDetail.coordinate.latitude
                    stopsArray[0].longitude = /placeDetail.coordinate.longitude
                    self?.serviceRequest.stops = stopsArray
                }
                
            } else {
                
                // On did Select Drop of location
                self?.serviceRequest.latitude =  /placeDetail.coordinate.latitude
                self?.serviceRequest.longitude =  /placeDetail.coordinate.longitude
                
            }
            
            self?.longitudeLatest = /placeDetail.coordinate.longitude
            self?.latitudeLatest = /placeDetail.coordinate.latitude
            
            self?.setCameraGoogleMap(latitude: /placeDetail.coordinate.latitude, longitude: /placeDetail.coordinate.longitude)
            
             // Ankush
            if (/self?.viewStop1.isHidden && /self?.viewStop2.isHidden) {
                
                if !(/self?.txtDropOffLocation.text?.isEmpty) && self?.txtDropOffLocation.text != nil {
                    self?.locationsSelected()
                }
            } else {
                self?.viewStoppageDesc.isHidden = false
            }
            
            self?.view.endEditing(true)
        }
    }
    
    func setCameraGoogleMap( latitude : Double , longitude : Double) {
        
        let newLocation = GMSCameraPosition.camera(withLatitude: latitude ,
                                                   longitude: longitude ,
                                                   zoom: 14)
        mapView.animate(to: newLocation)
    }
    
    func dropPickUpAndDropOffPins(pickLat : Double , pickLong : Double , dropLat : Double , dropLong : Double, isConfirmedPickUp: Bool = false) {
        
        mapView.clear()
        
        markerDropOffLocation = nil
        markerDropOffLocation = GMSMarker()
        markerDropOffLocation?.position = CLLocationCoordinate2D(latitude: dropLat, longitude:  dropLong)
        markerDropOffLocation?.icon  = #imageLiteral(resourceName: "DropMarker")
        markerDropOffLocation?.map = mapView
        addIconViewToMarker(marker: markerDropOffLocation, text: "Drop off")
        
        markerPickUpLocation = nil
        markerPickUpLocation = GMSMarker()
        markerPickUpLocation?.position = CLLocationCoordinate2D(latitude: pickLat, longitude:  pickLong)
        markerPickUpLocation?.icon  = #imageLiteral(resourceName: "PickUpMarker")
        markerPickUpLocation?.map = mapView
        addIconViewToMarker(marker: markerPickUpLocation, text: "Pick up")
        
        
        serviceRequest.stops.forEachEnumerated {[weak self] (index, stop) in
            let markerStoppage = GMSMarker()
            markerStoppage.position = CLLocationCoordinate2D(latitude: /stop.latitude, longitude:  /stop.longitude)
            markerStoppage.icon  = R.image.ic_pick_location()
            markerStoppage.map = self?.mapView
        }
        
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        var urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(pickLat),\(pickLong)&destination=\(dropLat),\(dropLong)&sensor=true&mode=driving&key=\(/UDSingleton.shared.appSettings?.appSettings?.ios_google_key)"
        
        if serviceRequest.stops.count == 1 {
            urlString = urlString + "&waypoints=via:\(/serviceRequest.stops.first?.latitude),\(/serviceRequest.stops.first?.longitude)"
        } else if serviceRequest.stops.count == 2 {
            urlString = urlString +  "&waypoints=via:\(/serviceRequest.stops.first?.latitude),\(/serviceRequest.stops.first?.longitude)|via:\(/serviceRequest.stops[1].latitude),\(/serviceRequest.stops[1].longitude)"
        } else {
            
        }
        
        guard let nsString  = NSString.init(string: urlString).addingPercentEscapes(using: String.Encoding.utf8.rawValue),
              let url = URL(string: nsString) else {return}
        
        let task = session.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }else {
                do {
                    
                    if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
                        
                        ez.runThisInMainThread {
                            
                            guard let routes = json["routes"] as? NSArray else { return }
                            
                            if (routes.count > 0) {
                                let overview_polyline = routes[0] as? NSDictionary
                                let dictPolyline = overview_polyline?["overview_polyline"] as? NSDictionary
                                guard let points = dictPolyline?.object(forKey: "points") as? String else { return }
                                
                                guard let legs  = overview_polyline , let legsJ = legs["legs"] as? NSArray , let lg = legsJ[0] as? NSDictionary else { return }
                                
                                guard  let distance = lg["distance"] as? NSDictionary  ,  let distanceLeftMeters =  distance.object(forKey: "value") as? Int, let time = lg["duration"] as? NSDictionary,  let timeInSeconds =  time.object(forKey: "value") as? Int else { return }
                                
                                //Rohit
                                self?.serviceRequest.distance = Float(Float(distanceLeftMeters)/1000)
                                UserDefaults.standard.set(Float(Float(distanceLeftMeters)/1000), forKey: "MapDistance")
                                
                                self?.serviceRequest.duration = Float(Float(timeInSeconds)/60)
                                UserDefaults.standard.set(Float(Float(timeInSeconds)/60), forKey: "MapTime")
                                
                                // Check if seleced distance is more than Package distance

                                if /self?.isFromPackage && self?.screenType.entryType == .Forward && !isConfirmedPickUp {
                                    
                                    if /self?.serviceRequest.distance > /self?.modalPackages?.package?.distanceKms {
                                        
                                        self?.alertBoxOption(message: "package_distance_confirmation".localizedString  , title: "AppName".localizedString , leftAction: "no".localizedString , rightAction: "yes".localizedString , ok: { }, cancel: { [weak self] in
                                            
                                            self?.viewFreightBrand.minimizeSelectBrandView()
                                            self?.screenType = ScreenType(mapMode: .SelectingLocationMode, entryType: .Backward)
                                            
                                        })
                                    }
                                }
                                
                               /* CATransaction.begin()
                                CATransaction.setAnimationDuration(1.0)
                                
                                guard let path = GMSMutablePath(fromEncodedPath: /points) else { return }
                                let bounds = GMSCoordinateBounds(path: path)
                                self?.mapView?.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
                                CATransaction.commit() */
                                self?.showPath(polyStr: points)
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
    
    func addIconViewToMarker(marker : GMSMarker?, text: String) {
        
        let iconView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 70, height: 20)))
        iconView.backgroundColor = .white
        iconView.clipsToBounds = true
        
        let label = UILabel(frame: CGRect(origin: .zero, size: CGSize(width:     iconView.bounds.width, height: 20)))
        label.text = text
        label.textAlignment = .center
        label.font = R.font.sfProTextMedium(size: 12.0)
        iconView.addSubview(label)
        
        marker?.iconView = iconView
    }
    
    
    @objc func etokenNotification(notifcation : Notification) {
        
        if let objNoti = notifcation.object as? ETokenPurchased {
            serviceRequest.paymentMode = .EToken
            serviceRequest.eToken = objNoti
            self.viewOrderPricing.updatePaymentMode(service: serviceRequest)
        }
    }
}

extension HomeVC {
    
    func checkUpdate(strForce : String) {
        
        guard let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {return}
        
        if strForce != currentVersion{
            
            if currentVersion.compare(strForce, options: NSString.CompareOptions.numeric) == ComparisonResult.orderedDescending {
            }
            else{
                alertBoxOk(message:"Alert.VersionUpdateText".localizedString , title: "AppName".localizedString, ok: {
                    APIBasePath.AppStoreURL.openAppStore()
                })
            }
        }
    }
}
