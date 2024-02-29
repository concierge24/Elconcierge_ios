//
//  AddressPickerViewController.swift
//  Clikat
//
//  Created by cblmacmini on 7/27/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import Material
import GooglePlaces
import GoogleMaps
import GooglePlacePicker
import EZSwiftExtensions
import GooglePlacesAPI

extension UIViewController : Dimmable {
    
}

typealias SaveAddressListener = (Address) -> ()

class AddressPickerViewController: UIViewController {

    @IBOutlet weak var tfFullName : UITextField!
    @IBOutlet weak var tfHouseNo : UITextField!
    @IBOutlet weak var tfBuildingName : UITextField!
    @IBOutlet weak var tfLandmark : UITextField!
    @IBOutlet weak var tfCity : UITextField!
    @IBOutlet weak var tfCountry : UITextField!
    @IBOutlet weak var tfArea: UITextField!
    @IBOutlet weak var labelPickAPlace: UILabel!
    @IBOutlet weak var viewContainer : UIView!
    @IBOutlet weak var stackView : UIStackView!
    
    @IBOutlet var textFields: [UITextField]!{
        didSet{
            for tf in textFields {
                tf.textAlignment = Localize.currentLanguage() == Languages.Arabic ? .right : .left
            }
        }
    }
    
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, w: 16, h: 40))
    var placePicker : GMSPlacePickerConfig?
    
    var saveAddressBlock : SaveAddressListener?
    
    var selectedAddress : Address?
    var isEdit : Bool = false
    
    var placeLink : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       //  locationManager.requestAlwaysAuthorization()
        
        tfFullName?.text = GDataSingleton.sharedInstance.loggedInUser?.firstName
        tfArea?.text = LocationSingleton.sharedInstance.location?.getArea()?.name
        tfCity?.text = LocationSingleton.sharedInstance.location?.getCity()?.name
        tfCountry?.text = LocationSingleton.sharedInstance.location?.getCountry()?.name
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isEdit {
            populateTextFieldsFromAddress()
        }else{
            populateTextfieldsfromGoogle()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK: - Initialize TextFields 
extension AddressPickerViewController {
    func populateTextfieldsfromGoogle(){
        
        GMSPlacesClient.shared().currentPlace(callback: { [weak self]
            (placeLikelihoodList: GMSPlaceLikelihoodList?, error: Error?) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    self?.labelPickAPlace?.text = place.formattedAddress
                    self?.placeLink = "http://maps.google.com/?q=" + place.coordinate.latitude.toString + "," + place.coordinate.longitude.toString
                }
            }
            })
    }
    
    func populateTextFieldsFromAddress(){
        tfFullName?.text = GDataSingleton.sharedInstance.loggedInUser?.firstName
        guard let _ = selectedAddress else { return }
        tfHouseNo?.text = selectedAddress?.houseNo
        tfBuildingName?.text = selectedAddress?.buildingName
        labelPickAPlace?.text = selectedAddress?.address
        tfLandmark?.text = selectedAddress?.landMark
        tfCity?.text = selectedAddress?.city
        tfCountry?.text = selectedAddress?.country
    }
}
//MARK: - Button Actions
extension AddressPickerViewController {

    @IBAction func actionCancel(sender : UIButton){
//        presentingViewController?.dim(direction: .Out)
        dismissVC {
            ez.topMostVC?.dim(direction: .Out)
        }
        
    }
    @IBAction func actionSave(sender : UIButton){
        let message = Address.validateAddress(name: tfFullName, houseNo: tfHouseNo, building: tfBuildingName, address: labelPickAPlace, landmark: tfLandmark, city: tfCity, country: tfCountry)
        
        if message.count == 0 {
            guard let block = saveAddressBlock else { return }
          
            let address = Address(name: tfFullName.text, address: labelPickAPlace.text, landmark: tfLandmark.text, houseNo: tfHouseNo.text, buildingName: tfBuildingName.text, city: tfCity.text, country: tfCountry.text,placeLink: self.placeLink,area: tfArea.text, lat: nil, long: nil,id: nil)
//            presentingViewController?.dim(direction: .Out)
            dismissVC(completion: {
                ez.topMostVC?.dim(direction: .Out)
                block(address)
            })
        }else {
            SKToast.makeToast(message)
        }
    }
    
    @IBAction func actionLocate(sender : UIButton){
        
        let vc = NewLocationViewController.getVC(.main)
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        vc.completionBlock = { [weak self] data in
            guard let strongSelf = self else { return }
            if let value = data as? Bool,value == true {
            //    strongSelf.locationFetched()
            }
        }
        self.present(vc, animated: true, completion: nil)
        
        
//        let lat = LocationManager.sharedInstance.currentLocation?.currentLat?.toDouble(),lng = LocationManager.sharedInstance.currentLocation?.currentLng?.toDouble()
//        let center = CLLocationCoordinate2DMake(lat ?? 0.0, lng ?? 0.0)
//        let northEast = CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001)
//        let southWest = CLLocationCoordinate2DMake(center.latitude - 0.001, center.longitude - 0.001)
//        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
//        placePicker = GMSPlacePickerConfig(viewport: viewport)
//        //placePicker = GMSPlacePickerConfig(
//
//        placePicker?.pickPlace(callback: { [weak self] (place: GMSPlace?, error: Error?) -> Void in
//            if let error = error {
//                print("Pick Place error: \(error.localizedDescription)")
//                return
//            }
//
//            if let place = place {
//                self?.reverseGeocodeLocation(place: place)
//            } else {
//                print("No place selected")
//            }
//        })
    }
    
}

//MARK: - Reverse Geocode Location

extension AddressPickerViewController {
    
    func reverseGeocodeLocation(place : GMSPlace){
        
//        tfLandmark?.text = place.name
        let location = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        
        CLGeocoder().reverseGeocodeLocation(location) {
            [weak self] (placeMark, error) in
            guard let self = self else { return }
            
            if let pinCode = self.formatAddress(placeMark: placeMark?.last), !pinCode.isEmpty {
                self.labelPickAPlace.text = pinCode
            }
        }
        placeLink = "http://maps.google.com/?q=" + place.coordinate.latitude.toString + "," + place.coordinate.longitude.toString
    }
    
    private func formatAddress (placeMark : CLPlacemark?) -> String? {
        
        let address = "\(placeMark?.name != nil ? ("\(/placeMark?.name),") : "") \(placeMark?.thoroughfare != nil ? ("\(/placeMark?.thoroughfare),") : "") \(/placeMark?.locality), \(/placeMark?.subLocality), \(/placeMark?.administrativeArea), \(/placeMark?.postalCode), \(/placeMark?.country)"
        
        return address
    }
}
//MARK:- UIViewControllerTransitioningDelegate
extension AddressPickerViewController : UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}
