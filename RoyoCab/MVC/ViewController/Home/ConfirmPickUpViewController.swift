//
//  ConfirmPickUpViewController.swift
//  Trava
//
//  Created by Apple on 19/11/19.
//  Copyright © 2019 CodeBrewLabs. All rights reserved.
//

import UIKit
import GoogleMaps
import IBAnimatable

protocol ConfirmPickUpViewControllerDelegate: class {
    func confirmedPickupandSubmitedOrder(request : ServiceRequest?)
}

class ConfirmPickUpViewController: UIViewController {
    
    // MARK:- Outlet
    @IBOutlet var viewMapContainer: UIView!
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var imgViewPickingLocation: UIImageView!
    @IBOutlet var viewConfirmPickUp: ConfirmPickupView!
    @IBOutlet weak var textFieldPickUpLocation: AnimatableTextField!
    
    @IBOutlet weak var viewNavigation: UIView?
    @IBOutlet weak var viewStatusBar: UIView?
    @IBOutlet var buttonTitle: UIButton?
    
     @IBOutlet var btnNewBack: UIButton?
    
    
    //MARK:- Properties
    var isMapLoaded : Bool = false
    var mapDataSource:GoogleMapsDataSource?
    
    var request : ServiceRequest?
    weak var delegate: ConfirmPickUpViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !isMapLoaded {
            configureMapView()
            isMapLoaded = !isMapLoaded
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        initialSetup()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
            
            let template = AppTemplate(rawValue: (UDSingleton.shared.appSettings?.appSettings?.app_template?.toInt() ?? 0) )
            switch template {
            case .Moby?:
                return .lightContent
                
            default:
                return .default
            }
    }
}

//MARK:- Function
extension ConfirmPickUpViewController {
    
    
    func initialSetup() {
        
        viewConfirmPickUp.delegate = self
        showConfirmPickUpView()
    }
    
    func setupUI() {
        
        let template = AppTemplate(rawValue: (UDSingleton.shared.appSettings?.appSettings?.app_template?.toInt() ?? 0) )
        switch template {
        case .Moby?:
            viewNavigation?.isHidden = false
            viewStatusBar?.setViewBackgroundColorHeader()
            
        case .DeliverSome?:
            viewNavigation?.isHidden = false
            viewStatusBar?.setViewBackgroundColorHeader()
            
        default:
            viewNavigation?.isHidden = true
            viewStatusBar?.isHidden = true
        }
        
        buttonTitle?.setButtonWithTitleColorHeaderText()
        viewNavigation?.setViewBackgroundColorHeader()
        
        
        btnNewBack?.setButtonWithTintColorHeaderText()
    }
    
    
    func configureMapView() {
        
        /* let didUpdateCurrentLocation : DidUpdatecurrentLocation = {[weak self] (manager,locations) in  //current location closure
         let currentLocation = GMSCameraPosition.camera(withLatitude: /manager.location?.coordinate.latitude,
         longitude: /manager.location?.coordinate.longitude,
         zoom: 14.0)
         // self?.currentLocation =   CLLocation(latitude: /manager.location?.coordinate.latitude, longitude: /manager.location?.coordinate.longitude )
         if !(/self?.isCurrentLocationUpdated) {
         
         self?.mapView.camera = currentLocation
         self?.isCurrentLocationUpdated = true
         
         let widthVal = (Float(vehicleSize.width)*(/self?.mapView.camera.zoom).getZoomPercentage)/100
         let heightVal = (Float(vehicleSize.height)*(/self?.mapView.camera.zoom).getZoomPercentage)/100
         vehicleCurrentSize =  CGSize(width: Double(widthVal), height: Double(heightVal))
         
         self?.mapDataSource?.getAddressFromlatLong(lat: /manager.location?.coordinate.latitude, long: /manager.location?.coordinate.longitude, completion: {  [weak self](strLocationName) in
         
         self?.setUpdatedAddress(location: strLocationName, coordinate: manager.location?.coordinate)
         })
         }
         } */
        
        
        /* let didChangePosition : DidChangePosition = { [weak self] in
         if self?.screenType.mapMode == .NormalMode {
         self?.calculateImageSize()
         }
         } */
        
        let didStopPosition : MapsDidStopMoving = { [weak self]  (position) in
            
            let newLocation = CLLocation(latitude: /position.latitude, longitude: /position.longitude)
            
            /* if  let currentLocation = self?.currentLocation {
             if let distance = self?.getDistance(newPosition: currentLocation , previous:  newLocation) {
             //                    self?.btnCurrentLocation.isSelected = !(distance > Float(2))
             }
             } */
            
            /* if self?.screenType.mapMode == .SelectingLocationMode {
             // Ankush self?.viewLocationTableContainer.alpha = 0
             
             self?.results.removeAll()
             self?.tblLocationSearch.reloadData()
             } */
            
            self?.mapDataSource?.getAddressFromlatLong(lat: /position.latitude , long:  /position.longitude , completion: { (strLocationName, country, name) in
                self?.setUpdatedAddress(location: strLocationName, coordinate: position)
            })
        }
        
        mapDataSource = GoogleMapsDataSource.init(mapStyleJSON: "MapStyle", mapView: mapView)
        mapView.delegate = mapDataSource
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = false
        mapView.settings.tiltGestures = false
        mapView.isBuildingsEnabled = false
        mapView.setMinZoom(2, maxZoom: 20)
        mapView.animate(toZoom: 6)
        //  mapDataSource?.didUpdateCurrentLocation = didUpdateCurrentLocation
        //  mapDataSource?.didChangePosition = didChangePosition
        mapDataSource?.mapStopScroll = didStopPosition
        
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "MapStyle", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                
            } else {
                debugPrint("Unable to find style.json")
            }
        } catch {
            debugPrint("One or more of the map styles failed to load. \(error)")
        }
        
        
        let pickupLoc = GMSCameraPosition.camera(withLatitude: /request?.latitudeDest, longitude: /request?.longitudeDest, zoom: 14.0)
        
        mapView.camera = pickupLoc
        mapDataSource?.getAddressFromlatLong(lat: /request?.latitudeDest, long: /request?.longitudeDest, completion: {  [weak self] (strLocationName, country, name) in
            
            self?.setUpdatedAddress(location: strLocationName, coordinate: CLLocationCoordinate2D(latitude: /self?.request?.latitudeDest, longitude: /self?.request?.longitudeDest))
        })
        
    }
    
    func setUpdatedAddress(location : String , coordinate : CLLocationCoordinate2D?) {
        
        request?.locationNameDest = location
        request?.latitudeDest = Double(/coordinate?.latitude)
        request?.longitudeDest = Double(/coordinate?.longitude)
        
        viewConfirmPickUp.assignData(location: request?.locationNameDest )
        textFieldPickUpLocation.text = request?.locationNameDest
        
        // viewSelectService.lblLocationName.text = location
        
        /* CouponSelectedLocation.latitude = /coordinate?.latitude
         CouponSelectedLocation.longitude = /coordinate?.longitude
         CouponSelectedLocation.selectedAddress = location */
        
        /* locationLatest = location
         latitudeLatest = Double(/coordinate?.latitude)
         longitudeLatest =  Double(/coordinate?.longitude) */
        
        /* if screenType.mapMode == .SelectingLocationMode {
         
         if txtDropOffLocation.isEditing == true  ||  locationEdit  == .DropOff {
         
         // Ankush Experimental - to not fill out Drop off automatically
         /* txtDropOffLocation.text = location
         serviceRequest.locationName = location
         serviceRequest.longitude =  Double(/coordinate?.longitude)
         serviceRequest.latitude =  Double(/coordinate?.latitude)
         tempDropOff = location */
         
         }else if txtPickUpLocation.isEditing == true ||  locationEdit  == .PickUp {
         
         serviceRequest.locationNameDest = location
         serviceRequest.longitudeDest =  Double(/coordinate?.longitude)
         serviceRequest.latitudeDest =  Double(/coordinate?.latitude)
         txtPickUpLocation.text = location
         tempPickUp = location
         }
         } */
    }
    
    func showConfirmPickUpView() {
        viewConfirmPickUp.showConfirmPickUPView(superView: viewMapContainer)
    }
    
    func setCameraGoogleMap( latitude : Double , longitude : Double) {
        
        let newLocation = GMSCameraPosition.camera(withLatitude: latitude ,
                                                   longitude: longitude ,
                                                   zoom: 14)
        mapView.animate(to: newLocation)
    }
}


//MARK:- Button Selectors
extension ConfirmPickUpViewController {
    
    @IBAction func buttonBackClicked(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func buttonCurrentLocationPressed(_ sender: Any) {
        
        let lat = /mapView.myLocation?.coordinate.latitude
        let long = /mapView.myLocation?.coordinate.longitude
        
        
        let currentLocation = GMSCameraPosition.camera(withLatitude: lat,
                                                       longitude: long,
                                                       zoom: 14)
        mapView.animate(to: currentLocation)
        
        mapDataSource?.getAddressFromlatLong(lat: lat, long: long, completion: {  [weak self](strLocationName, country, name) in
            
            self?.setUpdatedAddress(location: strLocationName, coordinate: self?.mapView.myLocation?.coordinate)
        })
        
        
        /* if sender.isSelected {
         btnCurrentLocation.isSelected = false
         
         let currentLocation = GMSCameraPosition.camera(withLatitude: /mapView.myLocation?.coordinate.latitude,
         longitude: /mapView.myLocation?.coordinate.longitude,
         zoom: 14)
         mapView.animate(to: currentLocation)
         return
         }
         
         if  screenType.mapMode == .RequestAcceptedMode{
         
         guard let path = GMSMutablePath(fromEncodedPath: Polyline.points) else { return }
         let bounds = GMSCoordinateBounds(path: path)
         self.mapView?.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
         btnCurrentLocation.isSelected = true
         
         }
         else{
         
         let currentLocation = GMSCameraPosition.camera(withLatitude: /mapView.myLocation?.coordinate.latitude,
         longitude: /mapView.myLocation?.coordinate.longitude,
         zoom: 14)
         mapView.animate(to: currentLocation)
         
         }
         
         
         //        if !(self.btnCurrentLocation.isSelected){
         //
         //            guard let path = GMSMutablePath(fromEncodedPath: Polyline.points) else { return }
         //            let bounds = GMSCoordinateBounds(path: path)
         //            self.mapView?.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
         //            self.btnCurrentLocation.isSelected = true
         //
         //        }
         //        else{
         //                    let currentLocation = GMSCameraPosition.camera(withLatitude: /mapView.myLocation?.coordinate.latitude,
         //                                                                   longitude: /mapView.myLocation?.coordinate.longitude,
         //                                                                   zoom: 14)
         //                    mapView.animate(to: currentLocation)
         //              self.btnCurrentLocation.isSelected = false
         //        } */
        
    }
    
    @IBAction func buttonPickUpLocationclicked(_ sender: UIButton) {
        
        GooglePlaceDataSource.sharedInstance.showAutocomplete {[weak self] (place) in
            
            self?.setUpdatedAddress(location: /place?.formattedAddress, coordinate: place?.coordinate)
            self?.setCameraGoogleMap(latitude: /place?.coordinate.latitude, longitude: /place?.coordinate.longitude)
        }
        
    }
    
}

//MARK:- ConfirmPickupViewDelegate
extension ConfirmPickUpViewController: ConfirmPickupViewDelegate {
    
    func didClickConfirmPickup() {
        
        dismiss(animated: false, completion: nil)
        delegate?.confirmedPickupandSubmitedOrder(request: request)
    }
}
