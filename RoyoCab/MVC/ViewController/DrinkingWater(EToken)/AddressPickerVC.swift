//
//  AddressPickerVC.swift
//  Buraq24
//
//  Created by Apple on 29/11/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces


struct CouponSelectedLocation {
    static var latitude  = 0.00
    static var longitude = 0.00
    static var selectedAddress = ""
    static var categoryId = 0
    static var categoryBrandId = 0
    static var Brands:[Brand]?
    static var brandSelected: Brand?
    
    mutating func reset (){
        self = CouponSelectedLocation()
    }
}


class AddressPickerVC: UIViewController , GMSMapViewDelegate, UITextFieldDelegate{
    
    //MARK: - Outlets
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var txtPickUpLocation: UITextField!
    
    //MARK: - Properties
    
    @IBOutlet weak var viewSearchResults: UIView!
    @IBOutlet weak var tblSearchResults: UITableView!
    @IBOutlet weak var btnNext: UIButton!
    
    var googlePickupLocation : GooglePlaceDataSource?
    var tableDataSource : TableViewDataSourceCab?
    
    var mapDataSource:GoogleMapsDataSource?
    var markerPickUpLocation : GMSMarker?
    
    var locationLatest : String = ""
    var latitudeLatest : Double?
    var longitudeLatest : Double?
    
    var results = [GMSAutocompletePrediction]() {
        didSet {
            tblSearchResults.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.isMyLocationEnabled = true
        self.setupMap()
    }
    
    func setupMap(){
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        btnNext.setImage(#imageLiteral(resourceName: "NextMaterial").setLocalizedImage(), for: .normal)
        
        self.configureMapView()
        self.configureLocationSearchTableView()
        viewSearchResults.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print("dsgfg")
        return true
    }
    
    //MARK:- Button Action
    
    @IBAction func actionForwardButton(_ sender: Any) {
        
        guard let vc = R.storyboard.drinkingWater.tokenListingVC() else{return}
        guard let val =  txtPickUpLocation.text else{
            Alerts.shared.show(alert: "AppName".localizedString, message: R.string.localizable.eTokenSelectAddress(), type: .info)
            return
        }
        
        CouponSelectedLocation.selectedAddress = val
        
        self.pushVC(vc)
        
    }
    
    @IBAction func actionBack(_ sender: Any) {
        
        guard let val =  txtPickUpLocation.text else{
            Alerts.shared.show(alert: "AppName".localizedString, message: R.string.localizable.eTokenSelectAddress() , type: .info)
            return
        }
        
        CouponSelectedLocation.selectedAddress = val
        ez.topMostVC?.popVC()
    }
    
    @IBAction func actionMyLocation(_ sender: Any) {
        
    }
}

extension AddressPickerVC: UITableViewDelegate{
    
    func configureLocationSearchTableView() {
        
        googlePickupLocation = GooglePlaceDataSource(txtField: txtPickUpLocation, resListener: { [weak self] (places) in
            self?.tableDataSource?.items = places
            if places.count > 0{
                self?.viewSearchResults.isHidden = false
            }
            else{self?.viewSearchResults.isHidden = true}
            
            self?.tblSearchResults.reloadData()
        })
        
        let   configureCellBlock :  ListCellConfigureBlockCab? = {  ( cell , item , indexPath) in
            if let cell = cell as? LocationResultCell, let model = item as? GMSAutocompletePrediction {
                cell.assignData(item: model)
            }
        }
        
        let didSelectBlock : DidSelectedRowCab = {[weak self] ( indexPath , cell , item) in
            
            if  let model = item as? GMSAutocompletePrediction {
                
                if /self?.txtPickUpLocation.isEditing{
                    self?.txtPickUpLocation.text = model.attributedFullText.string
                    
                    CouponSelectedLocation.selectedAddress = /self?.txtPickUpLocation.text
                }
                self?.getPlaceDetails(strPlaceID: model.placeID)
            }
        }
        
        tableDataSource = TableViewDataSourceCab(items: results, tableView: tblSearchResults, cellIdentifier: R.reuseIdentifier.locationResultCell.identifier, cellHeight: UITableView.automaticDimension)
        
        tableDataSource?.configureCellBlock = configureCellBlock
        tableDataSource?.aRowSelectedListener = didSelectBlock
        tblSearchResults.delegate = tableDataSource
        tblSearchResults.dataSource = tableDataSource
        tblSearchResults.reloadData()
    }
    
    func getPlaceDetails(strPlaceID : String?) {
        
        GooglePlaceDataSource.placeDetails(placeID: /strPlaceID) { [weak self](place) in
            guard let placeDetail = place else{return}
            
            ///Assign Latitude and LOngitude
            if /self?.txtPickUpLocation.isEditing  {
                
                //                self?.serviceRequest.latitudeDest =  /placeDetail.coordinate.latitude
                //                self?.serviceRequest.longitudeDest =  /placeDetail.coordinate.longitude
                
            }else{
                
                // On did Select Drop of location
                //                self?.serviceRequest.latitude =  /placeDetail.coordinate.latitude
                //                self?.serviceRequest.longitude =  /placeDetail.coordinate.longitude
                
            }
            self?.longitudeLatest = /placeDetail.coordinate.longitude
            self?.latitudeLatest = /placeDetail.coordinate.latitude
            
            CouponSelectedLocation.latitude = /placeDetail.coordinate.latitude
            CouponSelectedLocation.longitude = /placeDetail.coordinate.longitude
            
            self?.setCameraGoogleMap(latitude: /placeDetail.coordinate.latitude, longitude: /placeDetail.coordinate.longitude)
            
        }
    }
    func setCameraGoogleMap( latitude : Double , longitude : Double) {
        
        let newLocation = GMSCameraPosition.camera(withLatitude: latitude ,
                                                   longitude: longitude ,
                                                   zoom: 18)
        mapView.animate(to: newLocation)
    }
}

extension AddressPickerVC {
    
    func configureMapView() {
        
        self.setCameraGoogleMap(latitude: /LocationManagerCab.shared.latitude, longitude:  /LocationManagerCab.shared.longitude)
        
        let didUpdateCurrentLocation : DidUpdatecurrentLocation = {[weak self] (manager,locations) in  //current location closure
            
            if /self?.txtPickUpLocation.isEditing{
                return
            }
            
            self?.mapDataSource?.getAddressFromlatLong(lat: /manager.location?.coordinate.latitude, long: /manager.location?.coordinate.longitude, completion: {  [weak self](strLocationName, country, name) in
                self?.setUpdatedAddress(location: strLocationName, coordinate: manager.location?.coordinate)
            })
        }
        
        let didStopPosition : MapsDidStopMoving = { [weak self]  (position) in
            
            if /self?.txtPickUpLocation.isEditing{
                return
            }
            
            let newLocation = CLLocation(latitude: /position.latitude, longitude: /position.longitude)
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
        mapView.animate(toZoom: 18)
        mapDataSource?.didUpdateCurrentLocation = didUpdateCurrentLocation
        mapDataSource?.mapStopScroll = didStopPosition
        
    }
    
    func setUpdatedAddress(location : String , coordinate : CLLocationCoordinate2D?) {
        
        locationLatest = location
        latitudeLatest = Double(/coordinate?.latitude)
        longitudeLatest =  Double(/coordinate?.longitude)
        txtPickUpLocation.text = location
    }
}

