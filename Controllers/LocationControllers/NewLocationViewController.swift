//
//  NewLocationViewController.swift
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
import ObjectMapper
import MessageUI
import EZSwiftExtensions

extension UIStackView {
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}

extension UISearchBar {
    func changeSearchBarColor(color : UIColor) {
        for subView in self.subviews {
            for subSubView in subView.subviews {
                if let _ = subSubView as? UITextInputTraits {
                    let textField = subSubView as! UITextField
                    textField.backgroundColor = color
                    var bounds: CGRect
                    bounds = textField.frame
                    bounds.size.height = 100
                    textField.bounds = bounds
                    break
                }
            }
        }
    }
}

class NewLocationViewController: UIViewController {

    //MARK:- IBOutlet
    @IBOutlet weak var dismiss_button: UIButton!
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            self.searchBar.backgroundImage = UIImage()
            self.searchBar.changeSearchBarColor(color: UIColor(red: 214.0/255.0, green: 214.0/255.0, blue: 214.0/255.0, alpha: 1))
            searchBar.setAlignment()

        }
    }
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            self.tableView.tableFooterView = UIView(frame: CGRect.zero)
            self.tableView.register(UINib(nibName: "SavedAddressTableViewCell", bundle: nil), forCellReuseIdentifier: "SavedAddressTableViewCell")
            self.tableView.register(UINib(nibName: "AddAddressTableViewCell", bundle: nil), forCellReuseIdentifier: "AddAddressTableViewCell")
            self.tableView.estimatedRowHeight = 45
        }
    }

    //MARK:- Variables
    var sectionArray = ["Use current location".localized()]
    var iconArray = [#imageLiteral(resourceName: "currentLocationIcon"),#imageLiteral(resourceName: "plusIcon")]
    var presentTransition: UIViewControllerAnimatedTransitioning?
    var dismissTransition: UIViewControllerAnimatedTransitioning?
    var placeIDArray = [String]()
    var resultsArray = [String]()
    var primaryAddressArray = [String]()
    var searchResults = [String]()
    var searhPlacesName = [String]()
    var completionBlock : AnyCompletionBlock?
    var deliverycompletionBlock : AnyCompletionBlock?
    var foodDeliverycompletionBlock : AnyCompletionBlock?
    var fromStarting = false
    
    var pickupDetails : PickupDetails? {
        didSet{
            tableView.reloadTableViewData(inView: view)
        }
    }
    var stackView: UIStackView? = nil
    var address : Address? = nil
    var isSearchActive : Bool = false {
        didSet{
            self.tableView.reloadData()
        }
    }
    var onlySearch = false
    let sessionToken = GMSAutocompleteSessionToken.init()

    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        guard let _ = GDataSingleton.sharedInstance.loggedInUser?.firstName else{
            //self.sectionArray.append("Search Address")
            //self.iconArray.insert(#imageLiteral(resourceName: "ic_search_white-1"), at: 1)
            return}
        self.sectionArray.append("Add Address".localized())
        self.sectionArray.append("")
        self.getAllAdresses()

    }

    //MARK:- Button Actions
    @IBAction func dismiss_buttonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func moreButtonAction(_ sender: UIButton) {
        
        guard let cell = self.tableView.cellForRow(at: IndexPath(row: sender.tag, section: 1)) as? SavedAddressTableViewCell else {return}

        cell.backgroundColor = .red
        if stackView?.frame.height ?? 0.0 > CGFloat(0.0) {
            stackView?.removeFromSuperview()
        }
        stackView = UIStackView(frame: CGRect(x: self.view.frame.width/1.5 - 15, y: cell.frame.y + cell.frame.height + 100, w: self.view.frame.width-(self.view.frame.width/1.5), h: 80))
        stackView?.alignment = .fill
        stackView?.distribution = .fillEqually
        stackView?.axis = .vertical
        stackView?.addBackground(color: UIColor(red: 214.0/255.0, green: 214.0/255.0, blue: 214.0/255.0, alpha: 0.9))
        
        let editButton = UIButton()
        editButton.backgroundColor = .clear
        editButton.setTitleColor(.black, for: .normal)
        editButton.setTitle("Edit".localized(), for: .normal)
        
        let deleteButton = UIButton()
        deleteButton.backgroundColor = .clear
        deleteButton.setTitleColor(.black, for: .normal)
        deleteButton.setTitle("Delete".localized(), for: .normal)
        
        stackView?.addArrangedSubview(editButton)
        stackView?.addArrangedSubview(deleteButton)
        
        self.view.addSubview(stackView!)
        
    }
    
}

//MARK:- UITableViewDelegate,UITableViewDataSource
extension NewLocationViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
      //return 1
        if self.isSearchActive || onlySearch {
            return 1
        } else {
            return sectionArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return searchResults.count
        if self.isSearchActive || onlySearch{
            return searchResults.count
        } else {
            return section == 2 ? self.pickupDetails?.arrAddress?.count ?? 0 : 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.isSearchActive || onlySearch {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddAddressTableViewCell", for: indexPath) as! AddAddressTableViewCell
            cell.sideImage_imageView.isHidden = true
            cell.title_label.textColor = .black
            cell.title_label.text = self.searchResults[indexPath.row]
            cell.selectionStyle = .none
            return cell
            
        } else {
            if indexPath.section == 2 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "SavedAddressTableViewCell", for: indexPath) as! SavedAddressTableViewCell
                cell.more_button.isHidden = true
                
                if let arr = self.pickupDetails?.arrAddress{
                    
                    let data = arr[indexPath.row]
                    cell.address_label.text = data.area ?? ""
                    cell.addressType_label.text = data.address ?? ""
                    cell.sideImage_imageView.isHidden = true
                    if data.id == LocationSingleton.sharedInstance.searchedAddress?.id {
                        cell.sideImage_imageView.isHidden = false
                    }
//                    if let latitude = LocationSingleton.sharedInstance.searchedAddress?.lat {
//                        if let longitude = LocationSingleton.sharedInstance.searchedAddress?.long {
//                            if let lat = data.latitude {
//                                if let long = data.longitude {
//                                    if lat == String(latitude) && long == String(longitude) {
//                                        cell.sideImage_imageView.isHidden = false
//                                    } else {
//                                        cell.sideImage_imageView.isHidden = true
//                                    }
//                                }
//                            }
//                        }
//                    } else {
//                        cell.sideImage_imageView.isHidden = true
//                    }
                }
                
                cell.selectionStyle = .none
                return cell
                
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddAddressTableViewCell", for: indexPath) as! AddAddressTableViewCell
                cell.sideImage_imageView.isHidden = false
                cell.sideImage_imageView.image = iconArray[indexPath.section]
                cell.title_label.textColorId = "AppColor"
                cell.title_label.text = sectionArray[indexPath.section].localized()
                cell.selectionStyle = .none
                return cell
            }
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 2 ? 60 : 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.isSearchActive || onlySearch {
            self.selectSearchedAddress(indexPath: indexPath)
            
        } else {
            if indexPath.section == 1 {
                self.showMapViewController(animated: false)
            } else if indexPath.section == 0 {
                var notEnabled = false
                if CLLocationManager.locationServicesEnabled() {
                    switch CLLocationManager.authorizationStatus() {
                        case .notDetermined, .restricted, .denied:
                            print("No access")
                        notEnabled = true
                        case .authorizedAlways, .authorizedWhenInUse:
                            self.showMapViewController(animated: false)
                        @unknown default:
                        break
                    }
                } else {
                    notEnabled = true
                    print("Location services are not enabled")
                }
                
                if notEnabled {
                    UtilityFunctions.alertToEncourageLocationAccess(viewController: self)
                }
                
//                LocationSingleton.sharedInstance.searchedAddress = nil
//                LocationSingleton.sharedInstance.tempAddAddress = nil
//
//                self.dismiss(animated: true, completion: {
//                    if let block = self.completionBlock {
//                        block(true as AnyObject)
//                    }
//                })
            } else if indexPath.section == 2 {
                self.selectFirstSection(indexPath: indexPath)
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            guard let cell = tableView.cellForRow(at: indexPath) as? SavedAddressTableViewCell else {return}
            cell.sideImage_imageView.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2 {
            return self.pickupDetails?.arrAddress?.count ?? 0 > 0 ? 55.0 : 001            
        } else {
            return 0.001
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 2 {
           // return UIView()
            if self.pickupDetails?.arrAddress?.count ?? 0 > 0 {
                let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 55))
                headerView.backgroundColor = .white
                
                let headerTitle = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 54))
                headerTitle.font = UIFont(name: Fonts.ProximaNova.SemiBold, size: 20.0)
                headerTitle.text = "Saved Addresses".localized()
                headerTitle.textColor = .black
                
                let bottomView = UIView(frame: CGRect(x: 0, y: 54, width: tableView.frame.width, height: 1))
                bottomView.backgroundColor = UIColor(red: 214.0/255.0, green: 214.0/255.0, blue: 214.0/255.0, alpha: 1)
                
                headerView.addSubview(headerTitle)
                headerView.addSubview(bottomView)
                
                return headerView
                
            } else {
                return UIView()
            }
  
        } else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        if !isSearchActive,indexPath.section == 2 {
            let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
                if let array = self.pickupDetails?.arrAddress {
                    self.address = array[indexPath.row]
                    self.showMapViewController(animated: false)
                }
            }
            edit.backgroundColor = UIColor(red: 214.0/255.0, green: 214.0/255.0, blue: 214.0/255.0, alpha: 1)
            
            let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
                if let array = self.pickupDetails?.arrAddress {
                    let object = array[indexPath.row]
                    self.deleteAdress(id: object.id ?? "", index: indexPath)
                }
            }
            
            delete.backgroundColor = UIColor(red: 214.0/255.0, green: 214.0/255.0, blue: 214.0/255.0, alpha: 1)
            
            return [edit, delete]
        }
        
        return[]
    }
   
}

//MARK:- UIViewControllerTransitioningDelegate
extension NewLocationViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentTransition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissTransition
    }
}

//MARK:- UISearchBarDelegate
extension NewLocationViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarIsEmpty() -> Bool {
        return self.searchBar.text?.isEmpty ?? true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBarIsEmpty()){
            searchBar.text = ""
            self.isSearchActive = false
            searchBar.resignFirstResponder()
        }else{
            self.isSearchActive = true
            placeAutocomplete(text_input: searchText)            
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        self.isSearchActive = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func placeAutocomplete(text_input: String) {
        let filter = GMSAutocompleteFilter()
        let placesClient = GMSPlacesClient()
        filter.type = .establishment
        
        placesClient.autocompleteQuery(text_input, bounds: nil, filter: nil) { (results, error) -> Void in
            self.placeIDArray.removeAll()
            self.resultsArray.removeAll()
            self.primaryAddressArray.removeAll()
            if let error = error {
                print("Autocomplete error \(error)")
                self.tableView.reloadData()
                return
            }
            if let results = results {
                for result in results {
                    self.primaryAddressArray.append(result.attributedPrimaryText.string)
                    //(String(describing: result.placeID!))")
                    self.resultsArray.append(result.attributedFullText.string)
                    self.primaryAddressArray.append(result.attributedPrimaryText.string)
                    self.placeIDArray.append(result.placeID)
                }
            }
            self.searchResults = self.resultsArray
            self.searhPlacesName = self.primaryAddressArray
            self.tableView.reloadData()
        }
    }
    
}

//MARK:- Api Methods
extension NewLocationViewController {
    
    func getAllAdresses() {
        
        APIManager.sharedInstance.showLoader()
        APIManager.sharedInstance.opertationWithRequest(withApi: API.Addresses(FormatAPIParameters.Addresses(supplierBranchId: nil ,areaId: nil).formatParameters())) { [weak self] (result) in
            APIManager.sharedInstance.hideLoader()
            guard let strongSelf = self else {return}
            switch result {
            case .Success(let object):
                guard let delivery = object as? Delivery else { return }
                strongSelf.pickupDetails = PickupDetails(arrAddress: delivery.addresses)
            case .Failure(let validation):
                print(validation)
            }
        }
    }
    
    func deleteAdress(id: String,index: IndexPath) {
        
        APIManager.sharedInstance.showLoader()
        
        APIManager.sharedInstance.opertationWithRequest(withApi: API.DeleteAddress(FormatAPIParameters.DeleteAddress(addressId: id).formatParameters())) { [weak self] (response) in
            APIManager.sharedInstance.hideLoader()
            guard let strongSelf = self else {return}
            switch response {
            case .Success( _):
                if LocationSingleton.sharedInstance.searchedAddress?.id == id {
                    LocationSingleton.sharedInstance.searchedAddress = nil
                    strongSelf.completionBlock?(false)
                }
                if let array = strongSelf.pickupDetails?.arrAddress {
                    if let indexValue = array.index(where: {$0.id == id }) {
                        strongSelf.pickupDetails?.arrAddress?.remove(at: indexValue)
                        strongSelf.tableView.reloadData()
                    }
                }
            case .Failure(let validation):
                print(validation)
            }
        }        
    }
    
}

//MARK:- Functions
extension NewLocationViewController {
    
    func selectFirstSection(indexPath: IndexPath)  {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? SavedAddressTableViewCell else {return}
        cell.sideImage_imageView.isHidden = false
        
        if let arr = self.pickupDetails?.arrAddress{
            
            let data = arr[indexPath.row]
            
            guard let lat = data.latitude,let latDouble = Double(lat) else { return }
            guard let long = data.longitude,let longDouble = Double(long) else { return }
            guard let addLine1 = data.address,let addLine2 = data.area else {return}
            
            self.getPlacemark(lat: latDouble, long: longDouble) { (response) in
                
                if let placemark = response as? CLPlacemark {
                    
                    let add = SearchedLocation(lat: latDouble, long: longDouble, addLine1: addLine1, addLine2: addLine2 , placeid: nil, locality: placemark.locality ?? "", country: placemark.country ?? "", placemark: placemark,id: data.id ?? "")
                    
                    LocationSingleton.sharedInstance.searchedAddress = add
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {
                        self.dismiss(animated: true, completion: {
                            if let block = self.completionBlock {
                                print("NewLocation - completion - false")
                                block(false)
                            }
                            if let block = self.deliverycompletionBlock {
                                print("NewLocation - completion - address data")
                                block(data)
                            }
                            if let block = self.foodDeliverycompletionBlock {
                                let dict : Dictionary<String,AnyObject> = ["selectedDict": data, "arrayAddress": arr as AnyObject]
                                print("NewLocation - completion - address data and array all address")
                                block(dict)
                            }
                        })
                    }
                }
            }
        }
    }
    
    func selectSearchedAddress(indexPath: IndexPath) {
        
        searchBar.showsCancelButton = false
        self.isSearchActive = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        
       // LocationSingleton.sharedInstance.selectedAddress = nil
//        LocationSingleton.sharedInstance.selectedLatitude = nil
//        LocationSingleton.sharedInstance.selectedLongitude = nil
        if self.resultsArray.count == 0 { return }

        let placeId = placeIDArray[indexPath.row]
        GMSPlacesClient().fetchPlace(fromPlaceID: placeId, placeFields: .all, sessionToken: sessionToken) { [weak self] (place, error) in
            guard let `self` = self else { return }
            guard let result = place else { return }
            if self.onlySearch {
                self.completionBlock?(result)
                self.dismissVC(completion: nil)
            }
            else if let comps = place?.addressComponents {
                var locality = comps.first(where: { $0.types.containsIgnoringCase("locality")})?.name ?? ""
                if locality.isEmpty {
                    locality = comps.first(where: { $0.types.containsIgnoringCase("administrative_area_level_1") })?.name ?? ""
                }
                let country = comps.first(where: { $0.types.containsIgnoringCase("country") })?.name
                let obj:SearchedLocation = SearchedLocation (lat: result.coordinate.latitude, long: result.coordinate.longitude, addLine1: result.formattedAddress ?? "", addLine2: "", placeid: placeId , locality: locality, country: country ?? "", placemark: nil,id: "")
                self.showMapViewController(animated: true, searchedAdd: obj)
            }
        }
        
    }
//    func selectSearchedAddress(indexPath: IndexPath) {
//
//        searchBar.showsCancelButton = false
//        self.isSearchActive = false
//        searchBar.text = ""
//        searchBar.resignFirstResponder()
//
//       // LocationSingleton.sharedInstance.selectedAddress = nil
////        LocationSingleton.sharedInstance.selectedLatitude = nil
////        LocationSingleton.sharedInstance.selectedLongitude = nil
//        if self.resultsArray.count == 0 { return }
//        guard let correctedAddress = self.resultsArray[indexPath.row].addingPercentEncoding(withAllowedCharacters: .symbols) else { return }
//
//        let urlString =  "https://maps.googleapis.com/maps/api/geocode/json?address=\(correctedAddress)&sensor=false&key=\(GoogleApiKey)"
//
//        let url = URL(string: urlString)
//
//        Alamofire.request(url!, method: .get, headers: nil)
//            .validate()
//            .responseJSON { (response) in
//                switch response.result {
//                case.success(let value):
//                    //LocationSingleton.sharedInstance.searchedAddress = nil
//                     LocationSingleton.sharedInstance.tempAddAddress = nil
//
//                    let json = JSON(value)
//                    let lat = json["results"][0]["geometry"]["location"]["lat"].doubleValue
//                    let lng = json["results"][0]["geometry"]["location"]["lng"].doubleValue
//                    let formattedAddress = json["results"][0]["formatted_address"].rawString()
//                    let placeId = json["results"][0]["place_id"].rawString()
//
//                    let addComp =  json["results"][0]["address_components"].arrayValue
//                    let typesArray = addComp.compactMap({$0["types"].arrayValue})
//                    let arrCountry : [JSON] = ["country","political"]
//                    guard let indexValue = typesArray.indexes(of: arrCountry).first else { return }
//                    let country = addComp[indexValue]["long_name"].rawString()
//
//                     var locality: String?
//                     let arrLocality : [JSON] = ["locality","political"]
//                     if let cityIndex = typesArray.indexes(of: arrLocality).first {
//                        locality = addComp[cityIndex]["long_name"].rawString()
//                     }
//
//                    let obj:SearchedLocation = SearchedLocation (lat: lat, long: lng, addLine1: formattedAddress ?? "", addLine2: "", placeid: placeId ?? "", locality: locality ?? "", country: country ?? "", placemark: nil,id: "")
//
//                   // LocationSingleton.sharedInstance.selectedAddress = nil
//                    LocationSingleton.sharedInstance.searchedAddress = obj
////                    LocationSingleton.sharedInstance.selectedLatitude = lat
////                    LocationSingleton.sharedInstance.selectedLongitude = lng
//
//                     self.showMapViewController(animated: true, searchedAdd: obj)
//
////                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {
////                        self.dismiss(animated: true, completion: {
////                            if let block = self.completionBlock {
////                                block(false as AnyObject)
////                            }
////                        })
////                    }
//                case.failure(let error):
//                    print("\(error.localizedDescription)")
//                }
//
//        }
//    }
    
    func showMapViewController(animated: Bool, searchedAdd: SearchedLocation? = nil) {
        
        let vc = MapViewController.getVC(.main)
        vc.searchedAddress = searchedAdd
        
        presentTransition = RightToLeftTransition()
        dismissTransition = LeftToRightTransition()
        
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        if !animated {
            vc.address = self.address
            vc.fromNewlocation = true
        } else {
            vc.fromSelectLocaitons = true
        }
        if self.fromStarting {
            vc.fromStarting = true
        }
        vc.completionBlock = { [weak self] data in
            guard let strongSelf = self else {return}
            if let result = data as? Bool {
                strongSelf.dismiss(animated: true, completion: {
                    if let block = strongSelf.completionBlock {
                        print("NewLocation(M) - completion - \(result)")
                        block(result)
                    }
                })
            } else if let result = data as? [String:Any] {
                strongSelf.dismiss(animated: true, completion: {
                    if let block = strongSelf.completionBlock {
                        print("NewLocation(M) - completion - \(result)")
                        block(result)
                    }
                })
            } else if let result = data as? Int, result == 0{
                strongSelf.getAllAdresses()
            }
            
        }
        self.present(vc, animated: true) { [weak self] in
            print("Dismiss")
            self?.presentTransition = nil
        }

    }
    
    func getPlacemark(lat: Double, long: Double,data: @escaping(AnyObject) -> ()) {
        
        let location = CLLocation(latitude: lat, longitude: long)
        CLGeocoder().reverseGeocodeLocation(location) {
            (placeMark, error) in
            if let placeMarkObj = placeMark?.first{
                data(placeMarkObj)
            }
        }
    }
}
