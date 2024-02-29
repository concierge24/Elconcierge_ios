//
//  AddLocationFromMapViewController.swift
//  RoyoRide
//
//  Created by Ankush on 13/05/20.
//  Copyright © 2020 CodeBrewLabs. All rights reserved.
//

import UIKit
import GoogleMaps
import IBAnimatable

protocol AddLocationFromMapViewControllerDelegate: class {
    func locationSelectedFromMap(address: String?, name: String?, latitude: Double?, longitude: Double?, locationType: Int)
}

class AddLocationFromMapViewController: UIViewController {
    
    // MARK:- Outlet
    @IBOutlet var viewMapContainer: UIView!
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var imgViewPickingLocation: UIImageView!
    @IBOutlet var viewConfirmPickUp: ConfirmPickupView!
    @IBOutlet weak var textFieldPickUpLocation: AnimatableTextField!
    @IBOutlet weak var buttonDone: UIButton!
    
    @IBOutlet weak var viewNavigation: UIView?
    @IBOutlet weak var viewStatusBar: UIView?
    @IBOutlet var buttonTitle: UIButton?
    
     @IBOutlet var btnNewBack: UIButton?
    
    //MARK:- Properties
    var isMapLoaded : Bool = false
    var mapDataSource:GoogleMapsDataSource?
    
    var request : ServiceRequest?
    var locationType: Int!
    
    var address: String?
    var name: String?
    var latitude: Double?
    var longitude: Double?
    
    var isCurrentLocationUpdated: Bool?
    
    
    weak var delegate: AddLocationFromMapViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
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
extension AddLocationFromMapViewController {
    
    func initialSetup() {
        
        setupUI()
    }
    
    func setupUI() {
        
        buttonDone.setButtonWithBackgroundColorThemeAndTitleColorBtnText()
        
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
        
        let didUpdateCurrentLocation : DidUpdatecurrentLocation = {[weak self] (manager,locations) in  //current location closure
            let currentLocation = GMSCameraPosition.camera(withLatitude: /manager.location?.coordinate.latitude,
                                                           longitude: /manager.location?.coordinate.longitude,
                                                           zoom: 14.0)
           
            if !(/self?.isCurrentLocationUpdated) {
                
                self?.mapView.camera = currentLocation
                self?.isCurrentLocationUpdated = true
                
                
                self?.mapDataSource?.getAddressFromlatLong(lat: /manager.location?.coordinate.latitude, long: /manager.location?.coordinate.longitude, completion: {  [weak self](strLocationName, country, name)  in
                    
                    self?.setUpdatedAddress(location: strLocationName, name: name, coordinate: manager.location?.coordinate)
                })
            }
        }
        
        
        
        
        let didStopPosition : MapsDidStopMoving = { [weak self]  (position) in
            
           // let newLocation = CLLocation(latitude: /position.latitude, longitude: /position.longitude)
            
            
            self?.mapDataSource?.getAddressFromlatLong(lat: /position.latitude , long:  /position.longitude , completion: { (strLocationName, country, name) in
                self?.setUpdatedAddress(location: strLocationName, name: name, coordinate: position)
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
        mapDataSource?.didUpdateCurrentLocation = didUpdateCurrentLocation
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
    }
    
    func setUpdatedAddress(location : String , name: String?, coordinate : CLLocationCoordinate2D?) {
        
        
        textFieldPickUpLocation.text = location
        
        address = location
        self.name = name
        
        latitude = Double(/coordinate?.latitude)
        longitude = Double(/coordinate?.longitude)
        
    }
    
    func setCameraGoogleMap( latitude : Double , longitude : Double) {
        
        let newLocation = GMSCameraPosition.camera(withLatitude: latitude ,
                                                   longitude: longitude ,
                                                   zoom: 14)
        mapView.animate(to: newLocation)
    }
}


//MARK:- Button Selectors
extension AddLocationFromMapViewController {
    
    @IBAction func buttonBackClicked(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func buttonDonePressed(_ sender: Any) {
        delegate?.locationSelectedFromMap(address: address, name: name, latitude: latitude, longitude: longitude, locationType: locationType)
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
            
            self?.setUpdatedAddress(location: strLocationName, name: name, coordinate: self?.mapView.myLocation?.coordinate)
        })
    }
}


