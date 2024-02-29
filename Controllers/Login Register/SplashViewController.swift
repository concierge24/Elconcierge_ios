
//
//  SplashViewController.swift
//  Clikat
//
//  Created by cblmacmini on 5/12/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import Material
import EZSwiftExtensions
import GooglePlacePicker
enum SelectedLocation : Int {
    case Country = 1
    case City
    case Zone
    case Area
    case None
}

protocol SplashViewControllerDelegate {
    func locationSelected()
}

class SplashViewController: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var imageViewSplash: UIImageView!
    @IBOutlet weak var btnContinue: UIButton! {
        didSet {
            self.btnContinue.setBackgroundColor(SKAppType.type.color, forState: .normal)
        }
    }
    @IBOutlet weak var logoBgView: UIView!
    @IBOutlet weak var bgView: View!
    @IBOutlet weak var txtFldPincode: UITextField!
    @IBOutlet weak var btnCountry: UIButton!
    @IBOutlet weak var btnCity: UIButton!
    @IBOutlet weak var btnZone: UIButton!
    @IBOutlet weak var labelArea: UILabel!
    @IBOutlet weak var btnCheck: UIButton!

    //MARK:- ======== Variables ========
    var locationUser: ApplicationLocation? {
        didSet {
            updateLoc()
        }
    }
    var strCountry: String? {
        didSet {
            let str = /strCountry
            btnCountry.setTitle(str, for: .normal)
            if str.isEmpty {
                btnCountry.setTitle(L10n.Country.string, for: .normal)
                btnCountry.setTitleColor(UIColor.black.withAlphaComponent(0.25), for: .normal)
            } else {
                btnCountry.setTitle(str, for: .normal)
                btnCountry.setTitleColor(UIColor.black, for: .normal)
            }
        }
    }
    var strCity: String? {
        didSet {
            let str = /strCity
            btnCity.setTitle(str, for: .normal)
            if str.isEmpty {
                btnCity.setTitle(L10n.City.string, for: .normal)
                btnCity.setTitleColor(UIColor.black.withAlphaComponent(0.25), for: .normal)
            } else {
                btnCity.setTitle(str, for: .normal)
                btnCity.setTitleColor(UIColor.black, for: .normal)
            }
        }
    }
    var strArea: String? {
        didSet {
            let str = /strArea
            btnZone.setTitle(str, for: .normal)
            if str.isEmpty {
                btnZone.setTitle(L10n.Area.string, for: .normal)
                btnZone.setTitleColor(UIColor.black.withAlphaComponent(0.25), for: .normal)
            } else {
                btnZone.setTitle(str, for: .normal)
                btnZone.setTitleColor(UIColor.black, for: .normal)
            }
        }
    }
    var delegate : SplashViewControllerDelegate?
    var placePicker : GMSPlacePickerViewController?
    //var placePicker : GMSPlacePicker?

//    var countryAr : Locations?
//    var cityAr : Locations?
//    var areaAr : Locations?
    
//    var countryEn : Locations?
//    var cityEn : Locations?
//    var areaEn : Locations?
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func updateLoc() {
        
        btnCountry.isUserInteractionEnabled = true
        btnCity.isUserInteractionEnabled = true
        btnZone.isUserInteractionEnabled = true
        txtFldPincode.isUserInteractionEnabled = true
        btnContinue.isUserInteractionEnabled = false
        
        if let loc = locationUser, let area = loc.area?.name, locationUser?.country == nil {
            
            btnCountry.isUserInteractionEnabled = false
            btnCity.isUserInteractionEnabled = false
            btnZone.isUserInteractionEnabled = false
            txtFldPincode.isUserInteractionEnabled = false
            txtFldPincode.text = area
            btnCheck.isSelected = true
            btnContinue.isUserInteractionEnabled = true
            
        } else {
            btnCheck.isSelected = false
            strCountry = locationUser?.country?.name
            strCity = locationUser?.city?.name
            strArea = locationUser?.area?.name
            txtFldPincode.text = ""
        }
        //        self.validateBtnText()
        if let loc = locationUser, let _ = loc.country?.name, let _ = loc.city?.name, let _ = loc.area?.name {
            btnContinue.isUserInteractionEnabled = true
        }
    }
    
}

//MARK: - Setup UI and Animation
extension SplashViewController {
    
    func continueBtnSetUp(color:UIColor, isEnable:Bool,alpha:CGFloat){
        
       // btnContinue.backgroundColor = color
        //btnContinue.alpha = alpha
        btnContinue.isUserInteractionEnabled = isEnable
        
    }
    
    func setupUI(){
 
        setupAnimation()
        configureLanguage()
        
        if !LocationSingleton.sharedInstance.isLocationSelected() {
//            webServiceForLocation()
        }
        guard let location = LocationSingleton.sharedInstance.location else { return }
        locationUser = location
    }
    
    func setupAnimation(){
        //        logoBgView.transform = CGAffineTransform(translationX: 0, y: -logoBgView.frame.height)
        //        bgView.transform = CGAffineTransform(scaleX: 0, y: 0)
        //
        //        UIView.animate(withDuration: 1.5, delay: 0.4, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.3, options: UIView.AnimationOptions.curveEaseInOut, animations: {
        //            weak var weakSelf = self
        //            weakSelf?.logoBgView.transform = CGAffineTransform.identity
        //            weakSelf?.bgView.transform = CGAffineTransform.identity
        //            }) { (complete) in
        //        }
    }
    
    func configureLanguage(){
        if Localize.currentLanguage() == Languages.Arabic {
            btnCity.contentHorizontalAlignment = .right
            btnCountry.contentHorizontalAlignment = .right
            btnZone.contentHorizontalAlignment = .right
            btnCountry.titleEdgeInsets = UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 0)
        }
    }
}

extension SplashViewController {
    
    
}

//MARK: - Button Actions
extension SplashViewController {
    
    @IBAction func actionCountry(sender: UIButton) {
        
        let VC = StoryboardScene.Register.instantiateLocationViewController()
        VC.delegate = self
        VC.locationType = .Country
        presentVC(VC)
    }
    
    @IBAction func actionCity(sender: UIButton) {
        let message = validateType(selectedType: .City)
        
        if message.isEmpty {
            let VC = StoryboardScene.Register.instantiateLocationViewController()
            VC.delegate = self
            VC.countryId = locationUser?.countryEN?.id
            VC.locationType = .City
            presentVC(VC)
        } else {
            SKToast.makeToast(message)
        }
    }
    
    @IBAction func actionZone(sender: UIButton) {
        
        let message = validateType(selectedType: .Area)

        if message.isEmpty {
            let VC = StoryboardScene.Register.instantiateLocationViewController()
            VC.delegate = self
            VC.countryId = locationUser?.countryEN?.id
            VC.cityId = locationUser?.cityEN?.id
            VC.locationType = .Area
            presentVC(VC)
        }else {
            SKToast.makeToast(message)
        }
    }
    
    @IBAction func actionContinue(sender: UIButton) {
        
//        guard let _ = locationUser?.countryEN, let _ = locationUser?.cityEN, let _ = locationUser?.areaEN, let _ = locationUser?.countryAR, let _ = locationUser?.cityAR, let _ = locationUser?.areaAR, let applicationLocation = locationUser else {
//            SKToast.makeToast(L10n.PleaseSelectAllFieldsAbove.string)
//            return
//        }
        
        guard let locationUser = self.locationUser, let _ = locationUser.area else {
            SKToast.makeToast(L10n.PleaseSelectAllFieldsAbove.string)
            return
        }
        LocationSingleton.sharedInstance.location = locationUser
        
        dismissVC {
            [weak self] in
            self?.delegate?.locationSelected()
        }
    }
    
    
    @IBAction func backBtnClick(sender: UIButton) {
        self.dismissVC {}
    }
    
    @IBAction func checkBtnClick(sender: UIButton) {
        
        if sender.isSelected {
            locationUser = ApplicationLocation()
            updateLoc()
            return
        }
        self.webServiceGetArea()
    }
    
    @IBAction func useLoactionClick(sender: UIButton) {
        
        let lat = LocationManager.sharedInstance.currentLocation?.currentLat?.toDouble(),lng = LocationManager.sharedInstance.currentLocation?.currentLng?.toDouble()
        
        let center = CLLocationCoordinate2DMake(lat ?? 0.0, lng ?? 0.0)
       
        let northEast = CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001)
        let southWest = CLLocationCoordinate2DMake(center.latitude - 0.001, center.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        placePicker = GMSPlacePickerViewController(config: config)
        guard let picker = placePicker else {return}
        picker.delegate = self
        present(picker, animated: true, completion: nil)
        
    }
}

//MARK:- GMSPlacePickerViewControllerDelegate
extension SplashViewController: GMSPlacePickerViewControllerDelegate {
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        placePicker?.dismiss(animated: true, completion: {
            LocationSingleton.sharedInstance.selectedLatitude = place.coordinate.latitude
            LocationSingleton.sharedInstance.selectedLongitude = place.coordinate.longitude
           // self.reverseGeocodeLocation(place: place)
        })
    }

    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        placePicker?.dismiss(animated: true, completion: nil)
    }
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didFailWithError error: Error) {
        print(error.localizedDescription )
    }
    
}

//MARK:- ======== LocationViewControllerDelegate ========
extension SplashViewController: LocationViewControllerDelegate {

    func locationSelected(locationArabic location: Locations?, locationEnglish : Locations?, type: SelectedLocation?) {
        
        if locationUser == nil {
            locationUser = ApplicationLocation()
        }

        guard let selectedLocationType = type else { return }
        switch selectedLocationType {
        case .Country:
            locationUser?.countryEN = locationEnglish
            locationUser?.countryAR = location

        case .City:
            locationUser?.cityAR = location
            locationUser?.cityEN = locationEnglish

        case .Area:
            locationUser?.areaAR = location
            locationUser?.areaEN = locationEnglish
            
        default:
            break
        }
        updateLoc()
    }
}

//MARK: - Reset and Validate
extension SplashViewController {
    
    func validateType(selectedType : SelectedLocation) -> String {
        
        switch selectedType {
        case .City:
            return locationUser?.countryEN == nil ? L10n.PleaseSelectACountry.string : ""
            
        case .Zone:
            
            guard let _ = locationUser?.countryEN else {
                return L10n.PleaseSelectACountry.string
            }
            guard let _ = locationUser?.cityEN else { return L10n.PleaseSelectACity.string }
            
            return ""
        default:
            return ""
        }
    }
}

//MARK: - Web service for Area

extension SplashViewController {
    
//    func webServiceForLocation(){
//        let params = FormatAPIParameters.LocationList(type: .Country, id: nil).formatParameters()
//
//        APIManager.sharedInstance.opertationWithRequest(withApi: API.LocationList(params, type: .Country)) {
//            [weak self] (response) in
//
//            switch response {
//            case .Success(let locationResults):
//                let location = (locationResults as? LocationResults)
//                //                self?.countryEn = location?.arrLocationEn?.first
//                //                self?.countryAr = location?.arrLocationAr?.first
//                //                self?.resetFields(type: .Country)
//            //                self?.locationSelected(locationArabic: self?.countryAr,locationEnglish:self?.countryEn , type: .Country)
//            default:
//                break
//            }
//        }
//    }
    
//    func webServiewForArea(){
//
//        let params = FormatAPIParameters.LocationList(type: .Area, id: locationUser?.area?.id).formatParameters()
//
//        APIManager.sharedInstance.opertationWithRequest(withApi: API.LocationList(params, type: .Area)) { (response) in
//
//            weak var weakSelf = self
//            switch response {
//            case .Success(let locationResults):
//                weakSelf?.handleAreaWebService(locationResults: locationResults)
//            default:
//                break
//            }
//        }
//    }
    
//    func handleAreaWebService(locationResults : Any?){
//
//        guard let results = locationResults as? LocationResults else { return }
//
//        UtilityFunctions.showActionSheet(withTitle: L10n.SelectArea.string, subTitle: nil, vc: self, senders: stringArrayForDataSource(data: results)) { (selectedResult,index) in
//
//        }
//    }
    
//    func stringArrayForDataSource(data : AnyObject?) -> [String]{
//
//        //        guard let location = data as? LocationResults,arrLocation = location.arrLocation else { return [] }
//        //        var arrString : [String] = []
//        //        for result in arrLocation {
//        //            arrString.append(result.name ?? "")
//        //        }
//        //        return arrString
//        return [""]
//    }
}

//MARK: - Set Default Country
extension SplashViewController {
    
    func webServiceGetArea(){
        let text = /txtFldPincode.text
        
        if text.isEmpty {
            SKToast.makeToast(L10n.PleaseEnterValidPincode.string)
            return
        }
        
        APIManager.sharedInstance.opertationWithRequest(withApi: API.GetArea(FormatAPIParameters.GetArea(pincode: text).formatParameters())) {
            [weak self] (response) in
            guard let self = self else { return }
            
            switch response {
            case .Success(let object):
                
                if let getArea = object as? GetArea {
                    self.locationUser = ApplicationLocation()
                    self.locationUser?.areaEN = getArea.locEN
                    self.locationUser?.areaAR = getArea.locAR
                    self.updateLoc()
                }
                
            default:
                break
            }
        }
    }
}

//MARK: - Reverse Geocode Location
extension SplashViewController {
    
    func reverseGeocodeLocation(place: GMSPlace) {
        
        let location = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location) {
            [weak self] (placeMark, error) in
            guard let self = self else { return }
            
            if let pinCode = self.formatAddress(placeMark: placeMark?.last), !pinCode.isEmpty {
                self.txtFldPincode.text = pinCode
                self.checkBtnClick(sender: self.btnCheck)
            }
        }
    }
    
    private func formatAddress(placeMark: CLPlacemark?) -> String? {
        
        let address = (/placeMark?.postalCode)
        print("Postal Code - \(address)")
        return address
    }
}
