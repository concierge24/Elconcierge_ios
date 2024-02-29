//
//  RoyoRentalHomeViewController.swift
//  Sneni
//
//  Created by Apple on 25/10/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit
import GooglePlaces
import GooglePlacePicker
import ObjectMapper

extension Date {
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
}

extension String {
    func htmlToAttributedString(label: UILabel) -> NSAttributedString?{
        let str = self + String(format: "<style>body{font-family: '%@'; font-size:%fpx;}</style>", label.font.fontName, label.font.pointSize)
        return str.htmlToAttributedString
    }
    
    func htmlToAttributedString(textView: UITextView) -> NSAttributedString?{
        guard let font = textView.font else {
            return htmlToAttributedString
        }
        let str = self + String(format: "<style>body{font-family: '%@'; font-size:%fpx;}</style>", font.fontName, font.pointSize)
        return str.htmlToAttributedString
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
          let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
          let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
          
          return ceil(boundingBox.width)
      }
}

class RoyoRentalHomeViewController: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var search_button: UIButton!
    @IBOutlet weak var withoutDriver_button: UIButton!
    @IBOutlet weak var withDriver_button: UIButton!
    @IBOutlet weak var dropoff_view: UIView!
    @IBOutlet weak var dropoffTime_textField: UITextField! {
        didSet{
            dropoffTime_textField.delegate = self
            dropoffTime_textField.placeholder = "Drop-off Time".localized()
        }
    }
    @IBOutlet weak var pickupTime_textField: UITextField!{
        didSet{
            pickupTime_textField.delegate = self
            pickupTime_textField.placeholder = "Pick-up Time".localized()
        }
    }
    @IBOutlet weak var dropoffLocation_textField: UITextField!{
        didSet{
            dropoffLocation_textField.delegate = self
        }
    }
    @IBOutlet weak var pickupLocation_textField: UITextField!{
        didSet{
            pickupLocation_textField.delegate = self
        }
    }
    @IBOutlet weak var date_collectionView: UICollectionView! {
        didSet{
            date_collectionView.register(UINib(nibName: "RentalHomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RentalHomeCollectionViewCell")
        }
    }
    
    //MARK:- Variables
    var dateModalArray = [RentalDateModalClass]()
    var datePicker = UIDatePicker()
    var selectedIndex = [Int]()
    var selectedAddress: Address?
    var deliveryData = Delivery()
    var needDriver = 1
    var filteredIndex = [Int]()
    var placesClient: GMSPlacesClient!
    var pickupCordinates : CLLocationCoordinate2D?
    var dropoffCordinates : CLLocationCoordinate2D?
    var isPickupTextField = true
    var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
    var parameters = Dictionary<String,Any>()
    var shouldContinue = false
    var presentTransition: UIViewControllerAnimatedTransitioning?
    var dismissTransition: UIViewControllerAnimatedTransitioning?
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        self.nextSevenDays()
        self.datePicker.datePickerMode = .time
        self.pickupTime_textField.inputView = datePicker
        self.dropoffTime_textField.inputView = datePicker
        placesClient = GMSPlacesClient.shared()
        self.openGooglePlaces()

    }
    
    func nextSevenDays() {

        let calendar = Calendar(identifier: .gregorian)
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "yyyy-MM-dd"
        
        let currentDate = dateFormatterPrint.string(from: Date())
        let paramterDate = newFormatter.string(from: Date())
        
        if let index = currentDate.firstIndex(of: ",") {
            let data = currentDate.prefix(upTo: index)
            let dateTime = data.components(separatedBy: " ")
            let obj = RentalDateModalClass(month: dateTime[0], date: dateTime[1], parameterDate: paramterDate)
            self.dateModalArray.append(obj)
        }
        
        for i in 1...6 {
            guard let newDate = calendar.date(byAdding: .day, value: i, to: Date()) else { return }
            let strDate = dateFormatterPrint.string(from: newDate)
            let newParamterDate = newFormatter.string(from: newDate)
            
            if let index = strDate.firstIndex(of: ",") {
                let data = strDate.prefix(upTo: index)
                let dateTime = data.components(separatedBy: " ")
                
                let obj = RentalDateModalClass(month:  dateTime[0], date: dateTime[1], parameterDate: newParamterDate)
                self.dateModalArray.append(obj)
            }
        }
        if self.dateModalArray.count == 7 {
            self.date_collectionView.reloadData()
        }
    }
    
    func openPlacePicker() {
        
        let placePickerController = GMSAutocompleteViewController()
        placePickerController.delegate = self
        present(placePickerController, animated: true, completion: nil)
        
    }
    
    func openGooglePlaces() {
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Current Place error: \(error.localizedDescription)")
                return
            }
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    self.parameters["pickupCordinates"] = place.coordinate
                    self.parameters["pickupAddress"] = place.name ?? ""

                    let add = Address(name: nil, address: place.formattedAddress ?? "", landmark: nil, houseNo: nil, buildingName: nil, city: nil, country: nil, placeLink: nil, area: nil, lat: String(place.coordinate.latitude), long: String(place.coordinate.longitude),id:nil)
                    
                    self.parameters["addressModal"] = add

                    self.pickupLocation_textField.text = place.name ?? ""
                    if self.pickupLocation_textField.text != "" {
                        self.dropoff_view.isHidden = false
                    }
                }
            }
        })
    }
    
    func searchSuppliers() {

        guard let pickCordinates = self.parameters["pickupCordinates"] as? CLLocationCoordinate2D else {
            UtilityFunctions.showSweetAlert(title: "Alert!".localized(), message: "Please select your pickup point.".localized(), style: .Error)
            return }
        if self.selectedIndex.count == 0 {
            UtilityFunctions.showSweetAlert(title: "Wait!".localized(), message: "Please select dates.".localized(), style: .Error)
            return
        }
        if self.selectedIndex.count == 1 {
            if !self.shouldContinue {
                UtilityFunctions.showSweetAlert(title: "Alert!".localized(), message: "Your pickup and dropoff date is same. Do you want to continue".localized(), success: {
                    self.shouldContinue = true
                }) {
                    self.shouldContinue = false
                    return
                }
                return
            }
        }
        if self.pickupTime_textField.text?.count == 0 {
            UtilityFunctions.showSweetAlert(title: "Wait!".localized(), message: "Please select pickup time.".localized(), style: .Error)
            return
        }
        if self.dropoffTime_textField.text?.count == 0 {
            UtilityFunctions.showSweetAlert(title: "Wait!".localized(), message: "Please select dropoff time.".localized(), style: .Error)
            return
        }
        let firstIndex = self.selectedIndex[0]
        let lastIndex = self.selectedIndex.last ?? 0
        let bookingFromDate = self.dateModalArray[firstIndex].parameterDate ?? ""
        let bookingToDate = self.dateModalArray[lastIndex].parameterDate ?? ""
        
        var paramFromDate = ""
        var paramToDate = ""
        if let pickTime = self.parameters["pickupTime"] as? String,let dropTime = self.parameters["dropTime"] as? String {
            
            paramFromDate = bookingFromDate + " " + pickTime
            paramToDate = bookingToDate + " " + dropTime
            self.parameters["pickupApiDate"] = paramFromDate
            self.parameters["dropoffApiDate"] = paramToDate

        }
     
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        //formatter.timeZone = TimeZone(abbreviation: "UTC")
        let fromDate = formatter.date(from: paramFromDate)
        self.parameters["pickupDateObj"] = fromDate
        
        let toDate = formatter.date(from: paramToDate)
        self.parameters["deliveryDateObj"] = toDate

        let abbr = String(self.localTimeZoneAbbreviation.dropFirst(3))
        
        let obj = API.rentalFilternation(FormatAPIParameters.rentalFilteration(latitude:pickCordinates.latitude , longitude: pickCordinates.longitude, subCategoryId: [], low_to_high: "1", is_availability: "1", max_price_range: "1000", min_price_range: "0", is_discount: "0", is_popularity: "1", product_name: nil, variant_ids: [], supplier_ids: [], brand_ids: [], booking_from_date: paramFromDate, booking_to_date: paramToDate, need_agent: self.needDriver, zone_offset: abbr).formatParameters())
        
        APIManager.sharedInstance.opertationWithRequest(withApi: obj) { [weak self](response) in
            guard let self = self else { return }
            
            switch response {
            case .Success(let object):
                self.shouldContinue = false
                let obj = object as? RentalFilterData
                if obj?.count != 0 {
                    
                    let vc = StoryboardScene.Main.instantiateRentalSupplierController()
                    vc.filteredDataObj = obj
                    self.parameters["selectedDates"] = self.selectedIndex
                    self.parameters["modalObj"] = self.dateModalArray
                    vc.parameters = self.parameters
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                } else {
                    UtilityFunctions.showSweetAlert(title: "Sorry!".localized(), message: "No provider found, Please change booking date and time.".localized(), style: .Warning)
                }
            default:
                break
            }
        }
        
    }
    
    //MARK:- Button Action
    @IBAction func pickupMap_buttonAction(_ sender: UIButton) {
       // self.openMapViewController(sender)

    }
    
    @IBAction func dropoffMap_buttonAction(_ sender: UIButton) {
      //  self.openMapViewController(sender)
    }
    
    func openMapViewController(_ sender: UIButton) {
        
        let vc = MapViewController.getVC(.main)
        vc.fromRental = true
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    @IBAction func withDriver_buttonAction(_ sender: UIButton) {
        sender.isSelected = false
        needDriver = 1
        self.withoutDriver_button.isSelected = false

    }
    
    @IBAction func withoutDriver_buttonAction(_ sender: UIButton) {
        sender.isSelected = true
        needDriver = 0
        self.withDriver_button.isSelected = true
        
    }
    
    @IBAction func search_buttonAction(_ sender: Any) {
        self.searchSuppliers()

    }   

}

//MARK:- UICollectionViewDelegate,UICollectionViewDataSource
extension RoyoRentalHomeViewController : UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dateModalArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RentalHomeCollectionViewCell", for: indexPath) as! RentalHomeCollectionViewCell
        
        let data = self.dateModalArray[indexPath.item]
        cell.date_label.text = data.date ?? ""
        cell.month_label.text = data.month ?? ""
        
        if self.selectedIndex.contains(indexPath.row) {
            cell.background_view.backgroundColor = UIColor(red:0, green:0.69, blue:1, alpha:1)

            cell.date_label.textColor = .white
            cell.month_label.textColor = .white
            if self.selectedIndex[0] == indexPath.row {
                cell.info_label.text = "Start Date".localized()
            } else if self.selectedIndex.last ?? 0 == indexPath.row{
                cell.info_label.text = "End Date".localized()
            } else {
                cell.info_label.text = " "
            }
            
        } else if self.filteredIndex.contains(indexPath.row) {
            cell.background_view.backgroundColor = .lightGray

            cell.month_label.textColor = .darkGray
            cell.date_label.textColor = .darkGray
            cell.info_label.text = ""
            
        } else {
            cell.background_view.backgroundColor = .white

            cell.month_label.textColor = .darkGray
            cell.date_label.textColor = .darkGray
            cell.info_label.text = ""
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let _ = collectionView.cellForItem(at: indexPath) as? RentalHomeCollectionViewCell {
            
            if !self.filteredIndex.contains(indexPath.row) {
                
                if self.selectedIndex.contains(indexPath.row) {
                    if self.selectedIndex.count > 1 {
                        if self.selectedIndex[0] == indexPath.row {
                            self.selectedIndex.removeAll()
                            self.filteredIndex.removeAll()
                        } else if self.selectedIndex.last ?? 0 == indexPath.row {
                            let value = self.selectedIndex[0]
                            self.selectedIndex.removeAll()
                            self.selectedIndex.append(value)
                        }
                    } else {
                        if let index = self.selectedIndex.index(where: {$0 == indexPath.row}) {
                            self.selectedIndex.remove(at: index)
                        }
                        self.filteredIndex.removeAll()
                    }
                   
                } else {
                    if self.selectedIndex.count<2 {
                        if self.selectedIndex.count == 0 {
                            self.selectedIndex.append(indexPath.row)
                            for i in stride(from: self.selectedIndex[0]-1, through: 0, by: -1) {
                                self.filteredIndex.append(i)
                            }
                            
                        } else if self.selectedIndex.count == 1 {
                            self.selectedIndex.append(indexPath.row)
                            for i in stride(from: self.selectedIndex[0]+1, through: self.selectedIndex[1]-1, by: +1) {
                                self.selectedIndex.append(i)
                                self.selectedIndex.sort()
                            }
                        }
                    }
                }
                
                collectionView.reloadData()
            }
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width/4.7, height: 80)
    }
}

//MARK:- UITextFieldDelegate
extension RoyoRentalHomeViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.pickupTime_textField {
            self.datePicker.minimumDate = Date().adding(minutes: 60)
            
        } else if textField == dropoffTime_textField {

            if self.selectedIndex.count == 0 {
                self.dropoffTime_textField.shakeViewForTimes(3)
                self.view.endEditing(true)
                return
            } else if self.selectedIndex.count == 1 {
                self.datePicker.minimumDate = Date().adding(minutes: 120)
            } else {
                self.setPickerTime()
            }
            
        } else if textField == self.pickupLocation_textField {
            self.view.endEditing(true)
            self.isPickupTextField = true
            self.openPlacePicker()
        } else if textField == self.dropoffLocation_textField {
            self.view.endEditing(true)
            self.isPickupTextField = false
            self.openPlacePicker()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short

        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "HH:mm:ss"
        
        if textField == self.pickupTime_textField {
            self.pickupTime_textField.text = formatter.string(from: datePicker.date)
            let sas = newFormatter.string(from: datePicker.date)
            self.parameters["pickupTime"] = sas
            
        } else if textField == dropoffTime_textField {
            
            if self.selectedIndex.count != 0 {
                self.dropoffTime_textField.text = formatter.string(from: datePicker.date)
                let sas = newFormatter.string(from: datePicker.date)
                self.parameters["dropTime"] = sas
                return
            }

        }
       
    }
    
    func setPickerTime() {
        
        let startHour: Int = 0
        let endHour: Int = 24
        let date1 = Date()
        let gregorian:Calendar = Calendar(identifier: .gregorian)
        var components: DateComponents = gregorian.dateComponents(([.day, .month, .year]), from: date1)
        
        components.hour = startHour
        components.minute = 0
        components.second = 0
        
        let startDate: Date = gregorian.date(from: components)!
        components.hour = endHour
        components.minute = 0
        components.second = 0
        
        datePicker.minimumDate = startDate
        datePicker.setDate(startDate, animated: true)
        datePicker.reloadInputViews()
    }
    
}

//MARK:- UIViewControllerTransitioningDelegate
extension RoyoRentalHomeViewController : UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}

//MARK:- GMSAutocompleteViewControllerDelegate
extension RoyoRentalHomeViewController : GMSAutocompleteViewControllerDelegate{
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        if let name = place.name {
            if self.isPickupTextField{
                self.pickupLocation_textField.text = name
                //self.pickupCordinates = place.coordinate
                self.parameters["pickupCordinates"] = place.coordinate
                self.parameters["pickupAddress"] = name

                let add = Address(name: nil, address: place.formattedAddress ?? "", landmark: nil, houseNo: nil, buildingName: nil, city: nil, country: nil, placeLink: nil, area: nil, lat: String(place.coordinate.latitude), long: String(place.coordinate.longitude),id:nil)
                
                self.parameters["addressModal"] = add
                
            } else {
                self.dropoffLocation_textField.text = name
                //self.dropoffCordinates = place.coordinate
                self.parameters["dropoffCordinates"] = place.coordinate
                self.parameters["dropoffAddress"] = name

            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
