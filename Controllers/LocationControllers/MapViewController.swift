//
//  MapViewController.swift
//  Sneni
//
//  Created by Apple on 29/08/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON
import FlagPhoneNumber
import Material

typealias  AnyCompletionBlock = (Any) -> ()

class MapViewController: UIViewController,GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        
    }
    
    //MARK:- IBOutlet
    
    
    @IBOutlet weak var btnBack: UIButton! {
        didSet {
            btnBack.imageView?.mirrorTransform()
        }
    }

    @IBOutlet weak var address_label: UILabel!
    @IBOutlet weak var mapview: GMSMapView!
    @IBOutlet weak var saveProceed_button: UIButton!{
        didSet {
            saveProceed_button.setBackgroundColor(SKAppType.type.color, forState: .normal)
        }
    }
    @IBOutlet weak var completeAddress_textField: UITextField! {
        didSet {
            completeAddress_textField.setAlignment()
            if APIConstants.defaultAgentCode == "readychef_0309" || APIConstants.defaultAgentCode == "poneeex_0812" {
                completeAddress_textField.placeholder  = "Home / Work / Joe's Place".localized()
            } else {
                completeAddress_textField.placeholder  = "Apartment no. / Flat no. / Floor / Building".localized()
            }
            if APIConstants.defaultAgentCode == "stanley_0313" {
                completeAddress_textField.placeholder = "Receiver Address".localized()
            }
            if APIConstants.defaultAgentCode == "faindiy_0561" {
                completeAddress_textField.placeholder = "Receiver Address1".localized()
            }
        }
    }
    @IBOutlet weak var title_label: UILabel!{
        didSet{
            if APIConstants.defaultAgentCode == "faindiy_0561"{
                title_label.text = "Add Address".localized()
            }
        }
    }
    
    //MARK:- Variables
    private let locationManager = CLLocationManager()
    private var tempPlacemark : CLPlacemark?
    var completionBlock : AnyCompletionBlock?
    var fromRental = false
    var address : Address? = nil
    var searchedAddress: SearchedLocation?
    var fromNewlocation = false
    var fromStarting = false
    var fromSelectLocaitons = false
    var addressOptional: Bool {
        return false//RoyoConstant.defaultAgentCode == "readychef_0309"
    }
    
    var listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)

    var lastStatusOfInvalidPhone = false

    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        //saveProceed_button.setBackgroundColor(.lightGray, forState: .normal)
        //saveProceed_button.isUserInteractionEnabled = false
        
        completeAddress_textField.delegate = self
        mapview.delegate = self
        
        guard let _ = GDataSingleton.sharedInstance.loggedInUser?.firstName else{
            saveProceed_button.setTitle("Search".localized(), for: .normal)
            return
        }

        if self.fromRental || self.fromStarting {
            self.title_label.text = "Select Address".localized()
            self.saveProceed_button.setTitle("Select".localized(), for: .normal)
        }
     
        
        //completeAddress_textField.addDoneOnKeyboard(withTarget: self, action: #selector(doneButtonClicked))
        //tfName.addDoneOnKeyboard(withTarget: self, action: #selector(doneButtonClicked))
        //phoneNumberTextField.addDoneOnKeyboard(withTarget: self, action: #selector(doneButtonClicked))
    }
   
    @objc func doneButtonClicked() {
        self.view.endEditing(true)
    }

    override func viewDidAppear(_ animated: Bool) {

        if fromSelectLocaitons {
            var address_label = ""

            if let address = searchedAddress?.formattedAddress {
                address_label = address
            } else if let name = LocationSingleton.sharedInstance.selectedAddress?.name {
                if let locality = LocationSingleton.sharedInstance.selectedAddress?.locality {
                    address_label = name + " " + locality
                }
            }
            
            self.address_label.text = address_label
           // self.completeAddress_textField.text = address_label
            
            saveProceed_button.setTitle("Save & Proceed".localized(), for: .normal)
            saveProceed_button.setBackgroundColor(SKAppType.type.color, forState: .normal)
            saveProceed_button.isUserInteractionEnabled = true
            
            if searchedAddress != nil {
                if let lati = searchedAddress?.lat, let longi = searchedAddress?.long ,let lat = CLLocationDegrees(exactly: Double(lati) ), let long = CLLocationDegrees(exactly: Double(longi) ?? 0.0){
                    //let target = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 15)
                    mapview.camera = camera
                    mapview.animate(to: camera)
                }
            }
            else {
                if let lati = LocationSingleton.sharedInstance.searchedAddress?.lat, let longi = LocationSingleton.sharedInstance.searchedAddress?.long ,let lat = CLLocationDegrees(exactly: Double(lati) ), let long = CLLocationDegrees(exactly: Double(longi) ?? 0.0){
                    //let target = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 15)
                    mapview.camera = camera
                    mapview.animate(to: camera)
                }
            }
            
        } else if let addressValue = self.address {
            self.address_label.text = addressValue.area ?? ""
            self.completeAddress_textField.text = addressValue.address ?? ""
            saveProceed_button.setTitle("Update".localized(), for: .normal)
            saveProceed_button.setBackgroundColor(SKAppType.type.color, forState: .normal)
            saveProceed_button.isUserInteractionEnabled = true
        
            if let lati = addressValue.latitude, let longi = addressValue.longitude,let lat = CLLocationDegrees(exactly: Double(lati) ?? 0.0), let long = CLLocationDegrees(exactly: Double(longi) ?? 0.0){
              //  let target = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 15)
                self.mapview.camera = camera
                DispatchQueue.main.async {
                    self.mapview.animate(to: camera)
                }
            }
        }
        else if fromNewlocation {

            let lat = AppSettings.shared.defaultAddress?.first?.latitude ?? 30.733315
              let lng = AppSettings.shared.defaultAddress?.first?.longitude ?? 76.779419
            LocationManager.sharedInstance.currentLocation?.currentLat = lat.toString
            LocationManager.sharedInstance.currentLocation?.currentLng = lng.toString
            //            guard let lati = LocationManager.sharedInstance.currentLocation?.currentLat,let long = LocationManager.sharedInstance.currentLocation?.currentLng else {return}

            //            guard let lat = CLLocationDegrees(exactly: lati),let lon = CLLocationDegrees(exactly: long) else {return}
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            self.mapview.camera = GMSCameraPosition(target: coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        else {
            if let name = LocationSingleton.sharedInstance.selectedAddress?.name {
                if let locality = LocationSingleton.sharedInstance.selectedAddress?.locality {
                    let strArea = name + " " + locality
                    self.address_label.text = strArea
                }
            }
            if let lat = LocationSingleton.sharedInstance.selectedAddress?.location?.coordinate.latitude {
                if let long = LocationSingleton.sharedInstance.selectedAddress?.location?.coordinate.longitude {
                    let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 15)
                    self.mapview.camera = camera
                    DispatchQueue.main.async {
                        self.mapview.animate(to: camera)
                    }
                }
            }
            
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
        }
    }
   

    override func viewWillDisappear(_ animated: Bool) {
        self.address = nil
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
  
    @IBAction func dismiss_buttonAction(_ sender: Any) {
        if self.fromRental {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func currentLocatio_buttonAction(_ sender: Any) {
        guard let lati = LocationManager.sharedInstance.currentLocation?.currentLat?.toDouble(),let long = LocationManager.sharedInstance.currentLocation?.currentLng?.toDouble() else {return}
        guard let lat = CLLocationDegrees(exactly: lati),let lon = CLLocationDegrees(exactly: long) else {return}
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude:lon)
        self.mapview.camera = GMSCameraPosition(target: coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
    }
    
    @IBAction func saveProceed_buttonAction(_ sender: UIButton) {
        let completeAddress = (/self.completeAddress_textField.text).isEmpty ? "Others" : (/self.completeAddress_textField.text)
        if self.fromRental {
            
            
        } else {
           
            guard let latitude = self.tempPlacemark?.location?.coordinate.latitude else {return}
            guard let longitude = self.tempPlacemark?.location?.coordinate.longitude else {return}
            
            let add = SearchedLocation(lat: Double(latitude) , long: Double(longitude), addLine1: completeAddress, addLine2: "\(/(self.address_label.text))" , placeid: nil, locality: self.tempPlacemark?.locality ?? "", country: self.tempPlacemark?.country ?? "", placemark: self.tempPlacemark,id:"")
            
            
            
            if sender.titleLabel?.text == "Search".localized() {
                if GDataSingleton.sharedInstance.loggedInUser?.id != nil {
                    //save as tem address and make searched address on clicking in NewLocationViewController
                    LocationSingleton.sharedInstance.tempAddAddress = add
                    if let block = completionBlock {
                        let dict: [String :Any] = ["key" : "Search","value":true]
                        self.dismiss(animated: true, completion: nil)
                        block(dict as AnyObject)
                    }
                }
                 else {
                    //save location locally as current location
                    LocationSingleton.sharedInstance.searchedAddress = add
                    if let block = self.completionBlock {
                       self.dismiss(animated: true, completion: nil)
                       block(false)
                   }
                }

            } else if sender.titleLabel?.text == "Save & Proceed".localized() {
                
                
                
                if GDataSingleton.sharedInstance.isLoggedIn {
                    LocationSingleton.sharedInstance.tempAddAddress = add
                    self.addAndUpdateAddress(isEdit: false, addressObj: nil)
                }
                 else {
                    LocationSingleton.sharedInstance.searchedAddress = add
                    if let block = self.completionBlock {
                       self.dismiss(animated: true, completion: nil)
                       block(false)
                   }
                }
                
            } else if sender.titleLabel?.text == "Update".localized() {
                LocationSingleton.sharedInstance.tempAddAddress = add
                self.addAndUpdateAddress(isEdit: true, addressObj: self.address)
            }
            
        }

    }
    
   
    
}

extension MapViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        if updatedText.count > 1000 {
            UIApplication.shared.windows.last?.makeToast("Maximum limit reached".localized())
            return false
        }
        return true
    }
}

//MARK:- CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
        
        self.mapview.isMyLocationEnabled = true
        self.mapview.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        self.mapview.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        locationManager.stopUpdatingLocation()
    }
    
}

//MARK:- GMSMapViewDelegate
extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.reverseGeocodeLocation(place: position)
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
       // self.reverseGeocodeLocation(place: position)
    }
    
    func reverseGeocodeLocation(place: GMSCameraPosition) {
//        GMSGeocoder().reverseGeocodeCoordinate(CLLocationCoordinate2D(latitude: place.target.latitude, longitude: place.target.longitude)) { (response, error) in
//            UtilityFunctions.printToConsole(message: response?.firstResult()?.lines ?? "")
//        }
//
//                let urlString =  "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(place.target.latitude),\(place.target.longitude)&sensor=false&key=\(GoogleApiKey)"
//
//                let url = URL(string: urlString)
//
//                Alamofire.request(url!, method: .get, headers: nil)
//                    .validate()
//                    .responseJSON { (response) in
//                        switch response.result {
//                        case.success(let value):
//                            //LocationSingleton.sharedInstance.searchedAddress = nil
//                             LocationSingleton.sharedInstance.tempAddAddress = nil
//
//                            let json = JSON(value)
//                             if json["status"] == "REQUEST_DENIED" {
//                                SKToast.makeToast("request denied".localized())
//                                return
//                             }
//                            let lat = json["results"][0]["geometry"]["location"]["lat"].doubleValue
//                            let lng = json["results"][0]["geometry"]["location"]["lng"].doubleValue
//                            let formattedAddress = json["results"][0]["formatted_address"].rawString()
//                            let placeId = json["results"][0]["place_id"].rawString()
//
//                            let addComp =  json["results"][0]["address_components"].arrayValue
//                            let typesArray = addComp.compactMap({$0["types"].arrayValue})
//                            let arrCountry : [JSON] = ["country","political"]
//                            var indexValues = typesArray.indexes(of: arrCountry)
//                             if indexValues.count == 0 {
//                                // get state if country not found
//                                let arrCountry1 : [JSON] = ["administrative_area_level_1","political"]
//                                indexValues = typesArray.indexes(of: arrCountry1)
//                             }
//                             if indexValues.count == 0 {
//                                let arrCountry2 : [JSON] = ["locality","political"]
//                                indexValues = typesArray.indexes(of: arrCountry2)
//                             }
//                             //                     if indexValues.count == 0 && addComp.count > 0 {
//                             //                        indexValues = [0, 0]
//                             //                     }
//                            guard let indexValue = indexValues.first else { return }
//                            let country = addComp[indexValue]["long_name"].rawString()
//
//                             var locality: String?
//                             let arrLocality : [JSON] = ["locality","political"]
//                             if let cityIndex = typesArray.indexes(of: arrLocality).first {
//                                locality = addComp[cityIndex]["long_name"].rawString()
//                             }
//
//                            let obj:SearchedLocation = SearchedLocation (lat: lat, long: lng, addLine1: formattedAddress ?? "", addLine2: "", placeid: placeId ?? "", locality: locality ?? "", country: country ?? "", placemark: nil,id: "")
//
//                        case.failure(let error):
//                            UtilityFunctions.printToConsole(message: "\(error.localizedDescription)")
//                        }
//
//                }
//
//
        if fromSelectLocaitons {
            let location = CLLocation(latitude: place.target.latitude, longitude: place.target.longitude)
            CLGeocoder().reverseGeocodeLocation(location) {
                [weak self] (placeMark, error) in
                guard let self = self else { return }
                if let placeMarkObj = placeMark?.first{
                    self.tempPlacemark = placeMarkObj
                  
                }}
        }else{
            let location = CLLocation(latitude: place.target.latitude, longitude: place.target.longitude)
            CLGeocoder().reverseGeocodeLocation(location) {
                [weak self] (placeMark, error) in
                guard let self = self else { return }
                if let placeMarkObj = placeMark?.first{
                    self.tempPlacemark = placeMarkObj
                    if let name = placeMarkObj.name {
                        if let locality = placeMarkObj.locality {
                            let strArea = name + " " + locality
                            self.address_label.text = strArea
                        }
                        else {
                            let strArea = name
                            self.address_label.text = strArea
                        }
                    }
                    
                }
            }
        }
        
    }
}

//MARK:- UITextFieldDelegate
extension MapViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        var updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        updatedText = updatedText.trimmed()
        //if updatedText.count > 0 {
            saveProceed_button.setBackgroundColor(SKAppType.type.color, forState: .normal)
            saveProceed_button.isUserInteractionEnabled = true
//        } else {
//            saveProceed_button.setBackgroundColor(.lightGray, forState: .normal)
//            saveProceed_button.isUserInteractionEnabled = false
//        }
        return true
    }
}

//Mark:- Api Functions
extension MapViewController {

    func addAndUpdateAddress(isEdit: Bool?,addressObj:Address?) {
        
        
        var completeAddress = (/self.completeAddress_textField.text).isEmpty ? "Others".localized() : (/self.completeAddress_textField.text)
        if addressOptional {
            completeAddress = ""
        }
        saveProceed_button.isUserInteractionEnabled = false
        var strArea = ""
        if let address = LocationSingleton.sharedInstance.tempAddAddress?.addLine2 {
            strArea = address
        }
        
        let lat = LocationSingleton.sharedInstance.tempAddAddress?.lat ?? 0.0
        let long = LocationSingleton.sharedInstance.tempAddAddress?.long ?? 0.0
        var locality = ""
        if let localSearched = LocationSingleton.sharedInstance.tempAddAddress?.locality {
            locality = localSearched
        }
        var country = ""
        if let countrySearched = LocationSingleton.sharedInstance.tempAddAddress?.country {
            country = countrySearched
        }
        
        let addres = Address(name: nil, address: completeAddress, landmark: "", houseNo: "", buildingName: "", city: locality, country: country, placeLink: "", area: strArea, lat: String(lat), long: String(long),id: nil)
        
        let params : [String : Any]?
        let api: API?
        
        
        if isEdit ?? false {
            params = FormatAPIParameters.EditAddress(address: addres, addressId: addressObj?.id ?? "").formatParameters()
            api = API.EditAddress(params)

            
        } else {
            params = FormatAPIParameters.AddNewAddress(address: addres).formatParameters()
            api = API.AddNewAddress(params)
        }
        
        APIManager.sharedInstance.opertationWithRequest(withApi: api!) { (response) in
            switch response {
            case .Success(let item):
                if isEdit == true, let tempId = addressObj?.id, let selId = LocationSingleton.sharedInstance.searchedAddress?.id, tempId == selId {
                    let newAddress = LocationSingleton.sharedInstance.tempAddAddress
                    newAddress?.id = tempId
                    LocationSingleton.sharedInstance.searchedAddress = newAddress
                }
                else if let addressNew = item as? Address, let addId = addressNew.id, !addId.isEmpty {
                    let newAddress = LocationSingleton.sharedInstance.tempAddAddress
                    newAddress?.id = addId
                    LocationSingleton.sharedInstance.searchedAddress = newAddress
                }
                if let block = self.completionBlock {
                    self.dismiss(animated: true, completion: nil)
                    block((/LocationSingleton.sharedInstance.searchedAddress?.id).isEmpty ? 0 : false)
                }
                self.saveProceed_button.isUserInteractionEnabled = true
            case .Failure(_):
                self.saveProceed_button.isUserInteractionEnabled = true
                break
            }
        }
    }
}


extension MapViewController: FPNTextFieldDelegate {

    func fpnDisplayCountryList() {
        let navigationViewController = UINavigationController(rootViewController: listController)

        listController.title = "Countries"
        listController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissCountries))

        self.present(navigationViewController, animated: true, completion: nil)
    }
    
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        textField.rightViewMode = .always
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, w: 32, h: 32))
        var imgNameSuccess = "success"
        
        imgView.image = isValid ? UIImage(named: imgNameSuccess)  : UIImage(named:"error")
        textField.rightView = imgView
        lastStatusOfInvalidPhone = isValid
        print(
            isValid,
            textField.getFormattedPhoneNumber(format: .E164) ?? "E164: nil",
            textField.getFormattedPhoneNumber(format: .International) ?? "International: nil",
            textField.getFormattedPhoneNumber(format: .National) ?? "National: nil",
            textField.getFormattedPhoneNumber(format: .RFC3966) ?? "RFC3966: nil",
            textField.getRawPhoneNumber() ?? "Raw: nil"
        )
    }
    
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
    }
    
    @objc func dismissCountries() {
        listController.dismiss(animated: true, completion: nil)
    }
    
}
