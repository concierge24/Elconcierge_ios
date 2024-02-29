//
//  SelectLocationVC.swift
//  Sneni
//
//  Created by admin on 21/04/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON
import ObjectMapper

class SelectLocationVC: UIViewController {
    
    //MARK::- OUTLETS
    @IBOutlet weak var btnCurrentLoc: UIButton?{
        didSet{
            btnCurrentLoc?.setTitleColor(ButtonThemeColor.shared.btnBorderThemeColor, for: .normal)
        }
    }
    @IBOutlet weak var btnRequestNow: UIButton?{
        didSet{
            btnRequestNow?.backgroundColor = ButtonThemeColor.shared.btnBorderThemeColor
        }
    }
    @IBOutlet weak var lblWelcome: UILabel?{
        didSet{
            lblWelcome?.textColor = LabelThemeColor.shared.lblThemeColor
        }
    }
    @IBOutlet weak var viewLine: UIView?{
        didSet{
            viewLine?.backgroundColor = SKAppType.type.color
        }
    }
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            self.searchBar.backgroundImage = UIImage()
            self.searchBar.changeSearchBarColor(color: UIColor(red: 214.0/255.0, green: 214.0/255.0, blue: 214.0/255.0, alpha: 1))
        }
    }
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            self.tableView.tableFooterView = UIView(frame: CGRect.zero)
            self.tableView.register(UINib(nibName: "AddAddressTableViewCell", bundle: nil), forCellReuseIdentifier: "AddAddressTableViewCell")
        }
    }
    
    //MARK::- Properties
    var isSearchActive : Bool = false
    var placeIDArray = [String]()
    var resultsArray = [String]()
    var primaryAddressArray = [String]()
    var searchResults = [String]()
    var searhPlacesName = [String](){
        didSet{
            self.tableView.reloadData()
        }
    }
    var searchSelected : SearchedLocation?
    
    //MARK::- ViewCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
    }
    
    //MARK::- Functions
    func selectSearchedAddress(indexPath: IndexPath) {
        
        searchBar.showsCancelButton = false
        self.isSearchActive = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        
        guard let correctedAddress = self.resultsArray[indexPath.row].addingPercentEncoding(withAllowedCharacters: .symbols) else { return }
        
        let urlString =  "https://maps.googleapis.com/maps/api/geocode/json?address=\(correctedAddress)&sensor=false&key=\(GoogleApiKey)"
        
        let url = URL(string: urlString)
        
        Alamofire.request(url!, method: .get, headers: nil)
            .validate()
            .responseJSON { (response) in
                switch response.result {
                case.success(let value):
                    //LocationSingleton.sharedInstance.searchedAddress = nil
                    LocationSingleton.sharedInstance.tempAddAddress = nil
                    
                    let json = JSON(value)
                    let lat = json["results"][0]["geometry"]["location"]["lat"].doubleValue
                    let lng = json["results"][0]["geometry"]["location"]["lng"].doubleValue
                    let formattedAddress = json["results"][0]["formatted_address"].rawString()
                    let placeId = json["results"][0]["place_id"].rawString()
                    
                    let addComp =  json["results"][0]["address_components"].arrayValue
                    let typesArray = addComp.compactMap({$0["types"].arrayValue})
                    let arrCountry : [JSON] = ["country","political"]
                    guard let indexValue = typesArray.indexes(of: arrCountry).first else { return }
                    let country = addComp[indexValue]["long_name"].rawString()
                    
                    let arrLocality : [JSON] = ["locality","political"]
                    guard let cityIndex = typesArray.indexes(of: arrLocality).first else { return }
                    let locality = addComp[cityIndex]["long_name"].rawString()
                    
                    let obj:SearchedLocation = SearchedLocation (lat: lat, long: lng, addLine1: formattedAddress ?? "", addLine2: "", placeid: placeId ?? "", locality: locality ?? "", country: country ?? "", placemark: nil,id: "")
                    self.searchBar.text = formattedAddress
                    self.searchSelected = obj
                    self.searchResults = [String]()
                    self.tableView.reloadData()
                    self.tableView.isHidden = true

                
                    
                case.failure(let error):
                print("\(error.localizedDescription)")
        }
        
    }
}

//MARK::- Actions
@IBAction func actionCurrentLocation(_ sender: UIButton){
    GDataSingleton.isOnBoardingDone = true
    (UIApplication.shared.delegate as? AppDelegate)?.onload()
}

@IBAction func actionRequestNow(_ sender: UIButton){
    if self.searchSelected == nil || searchBar.text == ""{
        UtilityFunctions.showAlert(message: "Enter some location first")
    }else{
    LocationSingleton.sharedInstance.searchedAddress = self.searchSelected
    GDataSingleton.isOnBoardingDone = true
    (UIApplication.shared.delegate as? AppDelegate)?.onload()
    }
}

@IBAction func actionSchedule(_ sender: UIButton){
    GDataSingleton.isOnBoardingDone = true
    (UIApplication.shared.delegate as? AppDelegate)?.onload()
}


}


//MARK:- UISearchBarDelegate
extension SelectLocationVC: UISearchBarDelegate {
    
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
                return
            }
            if let results = results {
                for result in results {
                    self.primaryAddressArray.append(result.attributedPrimaryText.string)
                    self.resultsArray.append(result.attributedFullText.string)
                    self.primaryAddressArray.append(result.attributedPrimaryText.string)
                    self.placeIDArray.append(result.placeID)
                }
            }
            self.searchResults = self.resultsArray
            if self.searchResults.count > 0 {
                self.tableView.isHidden = false
            }
            self.searhPlacesName = self.primaryAddressArray
            self.tableView.reloadData()
        }
    }
    
}


//MARK:- UITableViewDelegate,UITableViewDataSource
extension SelectLocationVC: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddAddressTableViewCell", for: indexPath) as! AddAddressTableViewCell
        cell.sideImage_imageView.isHidden = true
        cell.title_label.textColor = .black
        cell.title_label.text = self.searchResults[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectSearchedAddress(indexPath: indexPath)
        
    }
    
}
