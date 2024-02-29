//
//  LocationViewController.swift
//  Clikat
//
//  Created by cblmacmini on 5/12/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

class SKSearchView: ThemeView {

    //MARK:- ======== Outlets ========
    @IBOutlet weak var tfSearch: UITextField? {
        didSet {
            tfSearch?.setAlignment()
            tfSearch?.addTarget(self, action: #selector(textFieldChanged(sender:)), for: .editingChanged)
        }
    }
    var placeHolder: String? {
        didSet {
            tfSearch?.placeholder = placeHolder
        }
    }

    //MARK:- ======== Variables ========
    var blockSearching: ((String) -> ())?

    //MARK:- ======== Actions ========
    @IBAction func textFieldChanged(sender: UITextField) {
        blockSearching?(/sender.text)
    }
    
}

protocol LocationViewControllerDelegate {
    func locationSelected(locationArabic : Locations?,locationEnglish : Locations?,type : SelectedLocation?)
}

class LocationViewController: LoginRegisterBaseViewController, UITextFieldDelegate {
    
    //MARK:- IBOutlet
    @IBOutlet weak var constraintTableBottom: NSLayoutConstraint!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewSearch: SKSearchView!{
        didSet {
            if let txt = viewSearch.tfSearch {
                txt.delegate = TextFieldDataSource(textField: txt, sender: self)
            }
            viewSearch.blockSearching = {
                [weak self] (txt) in
                self?.textFieldChanged(sender: self?.viewSearch.tfSearch)
            }
        }
    }
    
    //MARK:- Variables
    var delegate : LocationViewControllerDelegate?
    var locationType : SelectedLocation?
    var countryId : String?
    var cityId : String?
    var zoneId : String?
    //var locations : [Locations]?
    var locations : [Locations]?
    var getCityArray : [GetCity]?
    var searchResultsEn : [Locations]? = []
    var searchResultsAr : [Locations]? = []
    var myLocations : [Address]?
    var tableDataSource = LocationDataSource(){
        didSet{
            tableView.dataSource = tableDataSource
            tableView.delegate = tableDataSource
        }
    }
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK:- viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webServiceForLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) {
        constraintTableBottom.constant = 216
    }
    
    override func textFieldDidEndEditing(_ textField: UITextField) {
        constraintTableBottom.constant = 0
    }
    
}
//MARK: - Setup User Interface
extension LocationViewController {
    
    func setupUI(){
        
        guard let type = locationType else { return }
        switch type {
        case .Country:
            labelTitle.text = L10n.SelectCountry.string
            viewSearch?.placeHolder = L10n.SelectCountry.string
        case .City:
            labelTitle.text = L10n.SelectCity.string
            viewSearch?.placeHolder = L10n.SelectCity.string
        case .Area:
            labelTitle.text = L10n.SelectArea.string
            viewSearch?.placeHolder = L10n.SelectArea.string
        default:
            break
        }
    }
}

extension LocationViewController {
    
    static func getFirstCity(loader: Bool = false, location: ApplicationLocation, types:[SelectedLocation], lastId: String?, blockDone: ((ApplicationLocation) -> ())?) {
        
        var newTypes: [SelectedLocation] = types
        let first = newTypes.first ?? .Country
        newTypes.remove(at: 0)
        
        let params : OptionalDictionary = FormatAPIParameters.LocationList(type: first, id: lastId).formatParameters()
        if loader {
            APIManager.sharedInstance.showLoader()
        }
        APIManager.sharedInstance.opertationWithRequest(withApi: API.LocationList(params, type: first)) {
            (response) in
            APIManager.sharedInstance.hideLoader()
            
            switch response {
            case .Success(let locationResults):
                guard let results = locationResults as? Results1 else { return }
                let languageId = GDataSingleton.sharedInstance.languageId
                var lastId: String?

                switch first {
                case .Country:

                    guard let firstLoc = results.getArrLocation().first else { break }
                    location.countryEN = firstLoc
                    location.countryAR = firstLoc
                    lastId = firstLoc.id
                    
                case .City:
                    guard let firstLoc = results.cityLocation.first?.locations.first(where: {$0.languageid == languageId}) else { return }

                    location.cityAR = firstLoc
                    location.cityEN = firstLoc
                    lastId = firstLoc.id
                    
                case .Area:
                    guard let firstLoc = results.cityLocation.first?.locations.first(where: {$0.languageid == languageId}) else { return }
                    
                    location.areaAR = firstLoc
                    location.areaEN = firstLoc
                    lastId = firstLoc.id
                    
                default:
                    break
                }
                if newTypes.isEmpty {
                    blockDone?(location)
                } else {
                    getFirstCity(loader: loader, location: location, types: newTypes, lastId: lastId, blockDone: blockDone)
                }
            default:
                break
            }
        }
    }
    
    func webServiceForLocation() {
        
        var params : OptionalDictionary = ["" : ""]
        
        guard let type = locationType else { return }
        switch type {
        case .Country:
            params = FormatAPIParameters.LocationList(type: type, id: nil).formatParameters()
        case .City:
            params = FormatAPIParameters.LocationList(type: type, id: countryId).formatParameters()
        case .Area:
            params = FormatAPIParameters.LocationList(type: type, id: cityId).formatParameters()
        default:
            break
        }
        APIManager.sharedInstance.showLoader()
        APIManager.sharedInstance.opertationWithRequest(withApi: API.LocationList(params, type: locationType ?? .None)) {
            [weak self] (response) in
            
            APIManager.sharedInstance.hideLoader()
            switch response {
            case .Success(let locationResults):
                
                switch type {
                case .Country:
                    
                    guard let locationResults = locationResults as? Results1 else { return }
                    
                    self?.locations = locationResults.getArrLocation()
                    self?.searchResultsEn = locationResults.getArrLocation()
                    self?.searchResultsAr = locationResults.getArrLocation()
                    self?.tableDataSource.items =  locationResults.getArrLocation()
                    self?.myLocations = (locationResults as? LocationResults)?.myAddress
                    self?.configureTableView(searchResults: locationResults)
                    
                case .City:
                    
                    let results = locationResults as? Results1
                    self?.getCityArray = results?.cityLocation
                    
                    self?.configureCityTableView(searchResults: locationResults)
                case .Area:
                    let results = locationResults as? Results1
                    self?.getCityArray = results?.cityLocation
                    
                    self?.configureCityTableView(searchResults: locationResults)
                default:
                    break
                }  
            default:
                break
            }
        }
    }
    
    func configureCityTableView(searchResults : Any?){
        //  guard let results = searchResults as? LocationResults else { return }
        guard let results = searchResults as? Results1 else { return }
            //.index(where: { $0.id == self?.searchResultsEn
        tableDataSource = LocationDataSource(items: results.cityLocation,myLocations: nil, height: UITableView.automaticDimension, tableView: tableView, cellIdentifier: CellIdentifiers.LocationSearchCell, configureCellBlock: { [weak self] (cell, item) in
            guard let tempCell = cell as? LocationTableCell
                else { return }
            self?.configureCityCell(cell: tempCell, indexPath: item)
            }, aRowSelectedListener: { (indexPath) in
                weak var weakSelf = self
                weakSelf?.locationSelectedAtIndex(indexPath: indexPath)
        })
        tableView.reloadTableViewData(inView: view)
    }
    
    func configureTableView(searchResults : Any?){
      
          guard let results = searchResults as? Results1 else { return }
        tableDataSource = LocationDataSource(items: results.getArrLocation(),myLocations: nil, height: UITableView.automaticDimension, tableView: tableView, cellIdentifier: CellIdentifiers.LocationSearchCell, configureCellBlock: { [weak self] (cell, item) in
            guard let tempCell = cell as? LocationTableCell
                else { return }
            self?.configureCell(cell: tempCell, indexPath: item)
            }, aRowSelectedListener: { (indexPath) in
                weak var weakSelf = self
                weakSelf?.locationSelectedAtIndex(indexPath: indexPath)
        })
        tableView.reloadTableViewData(inView: view)
    }
    
    
    func configureCityCell(cell : Any?,indexPath : Any?){
  
        guard let indexpath = indexPath as? IndexPath,let locations = tableDataSource.items as? [GetCity] else { return }
        
        let getCity =  locations[indexpath.row] as GetCity
        
        let languageId = GDataSingleton.sharedInstance.languageId
        let nameLocation = getCity.locations.filter({$0.languageid == languageId})
        
        self.locations =  getCity.locations
        self.searchResultsEn =  getCity.locations
        //(locationResults as? LocationResults)?.arrLocationEn
        self.searchResultsAr = getCity.locations
        (cell as? LocationTableCell)?.labelTitle.text = nameLocation.first?.name
        
    }
    
    func configureCell(cell : Any?,indexPath : Any?){
        
        guard let indexpath = indexPath as? IndexPath,let locations = tableDataSource.items as? [Locations] else { return }
        if (tableDataSource.myLocations?.count ?? 0) > 0 {
            if indexpath.section == 0{
            let address = UtilityFunctions.appendOptionalStrings(withArray: [myLocations?[indexpath.row].name,myLocations?[indexpath.row].area], separatorString: ", ")
                (cell as? LocationTableCell)?.labelTitle.text =  address
                return
            }
            (cell as? LocationTableCell)?.labelTitle.text = locations[indexpath.row].name
        }else {
            (cell as? LocationTableCell)?.labelTitle.text = locations[indexpath.row].name
        }
    }
    
    func locationSelectedAtIndex(indexPath : IndexPath){
        
        switch locationType {
        case .some(let type):
            if LocationSingleton.sharedInstance.location?.areaEN?.id == nil {
               fallthrough
            }else if type == .Area && searchResultsAr?.first?.id != LocationSingleton.sharedInstance.location?.areaEN?.id {
                if DBManager.sharedManager.isCartEmpty() {
                    handleLocationSelection(indexPath: indexPath)
                    DBManager.sharedManager.cleanCart()
                }else {
                    UtilityFunctions.showSweetAlert(title : L10n.AreYouSure.string, message: L10n.ChangingTheCurrentAreaWillClearYouCart.string, success: { [weak self] in
                        self?.handleLocationSelection(indexPath: indexPath)
                        DBManager.sharedManager.cleanCart()
                        }, cancel: {
                            
                    })
                }
                return
            }
            fallthrough
        default:
            handleLocationSelection(indexPath: indexPath)
        }
    }
    
    func handleLocationSelection(indexPath : IndexPath){
        
        let getCity =  self.getCityArray?[indexPath.row]
        
        dismissVC { [weak self] in
            if (self?.myLocations?.count ?? 0) > 0 && indexPath.section == 0 && !((self?.viewSearch.tfSearch?.text?.trim().count ?? 0) > 0) {
              
                let languageId = GDataSingleton.sharedInstance.languageId
                let nameLocation = getCity?.locations.filter({$0.languageid == languageId})
                
                self?.locations =  nameLocation
                self?.searchResultsEn = nameLocation
                //(locationResults as? LocationResults)?.arrLocationEn
                self?.searchResultsAr = nameLocation

                let index = self?.searchResultsEn?.index(where: { $0.id == self?.myLocations?[indexPath.row].areaId })
                let arabicIndex = self?.searchResultsAr?.index(where: { $0.id == self?.myLocations?[indexPath.row].areaId })
                self?.delegate?.locationSelected( locationArabic: self?.searchResultsAr?[arabicIndex ?? 0],locationEnglish: self?.searchResultsEn?[index ?? 0] , type: self?.locationType)
                return
            }
            
            if L102Language.isRTL {
                
                let index = self?.searchResultsEn?.index(where: { $0.id == self?.searchResultsAr?.first?.id })
                self?.delegate?.locationSelected( locationArabic: self?.searchResultsAr?.first,locationEnglish: self?.searchResultsEn?[index
                     ?? 0] , type: self?.locationType)
                
            } else{
                
                guard let type = self?.locationType else { return }
                switch type {
               
                case .Country:
                    
                    let index = self?.searchResultsAr?.index(where: { $0.id == self?.searchResultsEn?[indexPath.row].id })
                    self?.delegate?.locationSelected( locationArabic: self?.searchResultsAr?[index ?? 0],locationEnglish: self?.searchResultsEn?[indexPath.row] , type: self?.locationType)
                    
                case .Area:
                    
                    let languageId = GDataSingleton.sharedInstance.languageId
                    let nameLocation = getCity?.locations.filter({$0.languageid == languageId})
                    self?.locations =  nameLocation
                    self?.searchResultsEn =  nameLocation
                    self?.searchResultsAr = nameLocation
                    
//                    let index = self?.searchResultsAr?.index(where: { $0.id == self?.searchResultsEn?.first?.id })
                    self?.delegate?.locationSelected( locationArabic: self?.searchResultsAr?.first,locationEnglish: self?.searchResultsEn?.first , type: self?.locationType)
                    
                default:
                    
                    let languageId = GDataSingleton.sharedInstance.languageId
                    let nameLocation = getCity?.locations.filter({$0.languageid == languageId})
                    self?.locations =  nameLocation
                    self?.searchResultsEn =  nameLocation
                    self?.searchResultsAr = nameLocation
                    self?.delegate?.locationSelected( locationArabic: self?.searchResultsAr?.first,locationEnglish: self?.searchResultsEn?.first , type: self?.locationType)
//
                    break
                }
            }
        }
    }
}

extension LocationViewController {
    
    func configureLocationSelection(data : AnyObject?){
        
        guard let locationResults = data as? LocationResults,let arrResults = locationResults.getArrLocation() else { return }
        var arrStrings = [String]()
        for result in arrResults {
            
            arrStrings.append(result.name ?? "")
        }
    }
}

//MARK: - Actions
extension LocationViewController {
    
    @IBAction func textFieldChanged(sender: UITextField?) {
        guard let sender = sender else { return }
        
        tableDataSource.myLocations = (sender.text?.trim().count ?? 0) > 0 ? [] : myLocations
        guard let tempLocations = locations else { return }
        
        guard let type = self.locationType else { return }
        switch type {
            
        case .Area,.City:
            
        guard let tempLocations = getCityArray else { return }
        
        let properResult = getCityArray?.filter { (locations) -> Bool in
            
            let languageId = GDataSingleton.sharedInstance.languageId
            let nameLocation = locations.locations.filter({$0.languageid == languageId})
            
            guard let match = nameLocation.first?.name?.lowercased().contains(sender.text!.lowercased()) else { return false }
            return match
            }
        
            getCityArray = sender.text?.count == 0 ? tempLocations : properResult
            tableDataSource.items = sender.text?.count == 0 ? tempLocations : properResult
        
        default:
            
        let filterSuppliers = tempLocations.filter({ (location) -> Bool in
            guard let match = location.name?.lowercased().contains(sender.text!.lowercased()) else { return false }
            return match
        })

        tableDataSource.items = sender.text?.count == 0 ? tempLocations : filterSuppliers
        
        if L102Language.isRTL {
            searchResultsAr = sender.text?.count == 0 ? tempLocations : filterSuppliers
        }
        else { searchResultsEn = sender.text?.count == 0 ? tempLocations : filterSuppliers }
         }
        
        tableView.reloadData()
    }
    
    
}

