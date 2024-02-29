//
//  EditLocationViewController.swift
//  Trava
//
//  Created by Apple on 27/12/19.
//  Copyright © 2019 CodeBrewLabs. All rights reserved.
//

import UIKit
import GooglePlaces

protocol EditLocationViewControllerDelegate: class {
    func ongoingRideLocationEdited(order: OrderCab?)
}

class EditLocationViewController: UIViewController {

    //MARK:- Outlet
    @IBOutlet weak var ViewEnterPickUpDropOff: UIView!
    @IBOutlet weak var viewStoppageDesc: UIView!
    @IBOutlet weak var viewStop1: UIView!
    @IBOutlet weak var viewStop2: UIView!
    @IBOutlet weak var viewStop3: UIView!
    @IBOutlet weak var viewStop4: UIView!
    
    
    @IBOutlet var txtStop1: UITextField!
    @IBOutlet var txtStop2: UITextField!
    @IBOutlet var txtStop3: UITextField!
    @IBOutlet var txtStop4: UITextField!
    @IBOutlet var txtPickUpLocation: UITextField!
    @IBOutlet var txtDropOffLocation: UITextField!
    
    @IBOutlet weak var constraintHeightViewEnterPickDrop: NSLayoutConstraint!
    @IBOutlet weak var buttonAddStop: UIButton!

    //MARK:- Properties
    var currentOrder: OrderCab?
    lazy var rideStops = [Stops]()
    var delegate : EditLocationViewControllerDelegate?
    
  /*  var tableDataSource : TableViewDataSource?
    
    var googleDropOffLocation : GooglePlaceDataSource?
    var googleStop1Location : GooglePlaceDataSource?
    var googleStop2Location : GooglePlaceDataSource?
    var googleStop3Location : GooglePlaceDataSource?
    var googleStop4Location : GooglePlaceDataSource?
    
    var results = [GMSAutocompletePrediction]() {
           didSet {
               tblLocationSearch.reloadData()
           }
       } */
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }
}

//MARK:- Functions
extension EditLocationViewController {
    
    func initialSetup() {
        
      //  configureLocationSearchTableView()
        
        txtPickUpLocation.text = currentOrder?.pickUpAddress
        txtDropOffLocation.text = currentOrder?.dropOffAddress
        
        currentOrder?.ride_stops?.forEachEnumerated({[weak self] (index, stop) in
            
            switch /stop.priority {
                
            case 1:
                self?.setupUIAndData(textfield: self?.txtStop1, view: self?.viewStop1, index: index)
                
            case 2:
                self?.setupUIAndData(textfield: self?.txtStop2, view: self?.viewStop2, index: index)
                
            case 3:
                self?.setupUIAndData(textfield: self?.txtStop3, view: self?.viewStop3, index: index)
                    
            case 4:
                self?.setupUIAndData(textfield: self?.txtStop4, view: self?.viewStop4, index: index)
                
            default:
                break
            }
        })
    }
    
    func setupUIAndData(textfield: UITextField?, view: UIView?, index: Int) {
        
        view?.isHidden = false
        textfield?.text = currentOrder?.ride_stops?[index].address
        
        view?.isUserInteractionEnabled = false
        
        if view != nil {
            constraintHeightViewEnterPickDrop.constant += 48
            view?.layoutIfNeeded()
        }
    }
    
    func addStoppageData(place: GMSPlace?, priority: Int) {
        
        if /rideStops.isEmpty {
          rideStops = currentOrder?.ride_stops?.filter({/$0.added_with_ride == "0"}) ?? []
        }
        
        let stop = Stops(latitude:  place?.coordinate.latitude, longitude: place?.coordinate.longitude, priority: priority, address: place?.formattedAddress)
        rideStops.append(stop)
    }
    
    
   /* func configureLocationSearchTableView() {
        
        googleStop1Location = GooglePlaceDataSource(txtField: txtStop1, resListener: { [weak self] (places) in
            self?.tableDataSource?.items = places
            self?.tblLocationSearch.reloadData()
            
            self?.viewStoppageDesc.isHidden = places.count > 0
        })
        
        googleStop2Location = GooglePlaceDataSource(txtField: txtStop2, resListener: { [weak self] (places) in
            self?.tableDataSource?.items = places
            self?.tblLocationSearch.reloadData()
            
            self?.viewStoppageDesc.isHidden = places.count > 0
        })
        
        googleStop3Location = GooglePlaceDataSource(txtField: txtStop3, resListener: { [weak self] (places) in
            self?.tableDataSource?.items = places
            self?.tblLocationSearch.reloadData()
            
            self?.viewStoppageDesc.isHidden = places.count > 0
        })
        
        googleStop4Location = GooglePlaceDataSource(txtField: txtStop4, resListener: { [weak self] (places) in
            self?.tableDataSource?.items = places
            self?.tblLocationSearch.reloadData()
            
            self?.viewStoppageDesc.isHidden = places.count > 0
        })
        
        
        googleDropOffLocation = GooglePlaceDataSource(txtField: txtDropOffLocation, resListener: {[weak self]  (places) in
            self?.tableDataSource?.items = places
            self?.tblLocationSearch.reloadData()
            
            if !(/self?.viewStop1.isHidden && /self?.viewStop2.isHidden && /self?.viewStop3.isHidden && /self?.viewStop4.isHidden) {
                self?.viewStoppageDesc.isHidden = (places.count > 0)
            }
        })
        
        let   configureCellBlock :  ListCellConfigureBlock? = {  ( cell , item , indexPath) in
            if let cell = cell as? LocationTableViewCell, let model = item as? GMSAutocompletePrediction {
                cell.assignData(item: model)
            }
        }
        
        let didSelectBlock : DidSelectedRow = {[weak self] ( indexPath , cell , item) in
            
            if  let model = item as? GMSAutocompletePrediction {
                                
                if /self?.txtPickUpLocation.isEditing  {
                    self?.txtPickUpLocation.text = model.attributedFullText.string
                   // self?.serviceRequest.locationNameDest = model.attributedFullText.string // Assigning Name of location
                    
                } else if /self?.txtStop1.isEditing  {
                    self?.txtStop1.text = model.attributedFullText.string
                  //  let modal = Stops(latitude: nil, longitude: nil, priority: 1, address: model.attributedFullText.string)
                 //   self?.serviceRequest.stops.append(modal)
                   // self?.tempStop1 = model.attributedFullText.string
                    
                } else if /self?.txtStop2.isEditing  {
                    self?.txtStop2.text = model.attributedFullText.string
                  
                } else if /self?.txtStop3.isEditing  {
                    self?.txtStop3.text = model.attributedFullText.string
                   
                } else if /self?.txtStop4.isEditing  {
                    self?.txtStop4.text = model.attributedFullText.string
                  
                } else if /self?.txtDropOffLocation.isEditing {
                    self?.txtDropOffLocation.text = model.attributedFullText.string
                   
                } else {
                    return
                }
               // self?.locationLatest = model.attributedFullText.string
                self?.getPlaceDetails(strPlaceID: model.placeID)
                
            }
        }
        
        tableDataSource = TableViewDataSource(items: results, tableView: tblLocationSearch, cellIdentifier: R.reuseIdentifier.locationTableViewCell.identifier, cellHeight: UITableView.automaticDimension)
        
        tableDataSource?.configureCellBlock = configureCellBlock
        tableDataSource?.aRowSelectedListener = didSelectBlock
        
        tblLocationSearch.delegate = tableDataSource
        tblLocationSearch.dataSource = tableDataSource
        
        tblLocationSearch.reloadData()
    } */
    
    
   /* func getPlaceDetails(strPlaceID : String?) {
        
        GooglePlaceDataSource.placeDetails(placeID: /strPlaceID) { [weak self](place) in
            guard let placeDetail = place else{return}
            
            
             ///Assign Latitude and LOngitude
            if /self?.txtPickUpLocation.isEditing  {
                
               // self?.serviceRequest.latitudeDest =  /placeDetail.coordinate.latitude
              //  self?.serviceRequest.longitudeDest =  /placeDetail.coordinate.longitude
                
            } else if /self?.txtStop1.isEditing  {
                
             /*   guard var stopsArray = self?.serviceRequest.stops else {return}
                stopsArray[0].latitude = /placeDetail.coordinate.latitude
                stopsArray[0].longitude = /placeDetail.coordinate.longitude
                self?.serviceRequest.stops = stopsArray */
                
            } else if /self?.txtStop2.isEditing  {
                
              /*  if /self?.serviceRequest.stops.count > 1 {
                    guard var stopsArray = self?.serviceRequest.stops else {return}
                    stopsArray[1].latitude = /placeDetail.coordinate.latitude
                    stopsArray[1].longitude = /placeDetail.coordinate.longitude
                    self?.serviceRequest.stops = stopsArray
                } else {
                    guard var stopsArray = self?.serviceRequest.stops else {return}
                    stopsArray[0].latitude = /placeDetail.coordinate.latitude
                    stopsArray[0].longitude = /placeDetail.coordinate.longitude
                    self?.serviceRequest.stops = stopsArray
                }*/
                
            } else {
                
                // On did Select Drop of location
              //  self?.serviceRequest.latitude =  /placeDetail.coordinate.latitude
              //  self?.serviceRequest.longitude =  /placeDetail.coordinate.longitude
                
            }
            
          //  self?.longitudeLatest = /placeDetail.coordinate.longitude
           // self?.latitudeLatest = /placeDetail.coordinate.latitude
            
         //   self?.setCameraGoogleMap(latitude: /placeDetail.coordinate.latitude, longitude: /placeDetail.coordinate.longitude)
            
             // Ankush
            if (/self?.viewStop1.isHidden && /self?.viewStop2.isHidden) {
                
                if !(/self?.txtDropOffLocation.text?.isEmpty) && self?.txtDropOffLocation.text != nil {
                  //  self?.locationsSelected()
                }
            } else {
                self?.viewStoppageDesc.isHidden = false
            }
            
            self?.view.endEditing(true)
        }
    } */
    
}


//MARK:- Button Selectors

extension EditLocationViewController {
    
    @IBAction func buttonAddStopClicked(_ sender: Any) {
           
           view.endEditing(true)
           
        alertBoxOption(message: "Ongoing_AddStop_Confirmation".localizedString, title: "AppName".localizedString, leftAction: "no".localizedString, rightAction: "yes".localizedString, ok: {
            
            
            UIView.animate(withDuration: 0.2) { [weak self] in

                if /self?.viewStop1.isHidden {
                     self?.viewStop1.isHidden = false
                } else if (/self?.viewStop2.isHidden) && !(/self?.txtStop1.text?.isEmpty)  {
                     self?.viewStop2.isHidden = false
                } else if (/self?.viewStop3.isHidden) && !(/self?.txtStop2.text?.isEmpty)  {
                     self?.viewStop3.isHidden = false
                }  else if (/self?.viewStop4.isHidden) && !(/self?.txtStop3.text?.isEmpty)  {
                     self?.viewStop4.isHidden = false
                } else {
                 return
             }
                
                self?.constraintHeightViewEnterPickDrop.constant += 48
                self?.view.layoutIfNeeded()
               // self?.viewStoppageDesc.isHidden = (/self?.viewStop1.isHidden && /self?.viewStop2.isHidden && /self?.viewStop3.isHidden && /self?.viewStop4.isHidden)
                self?.buttonAddStop.isHidden = !(/self?.viewStop1.isHidden) && !(/self?.viewStop2.isHidden) && !(/self?.viewStop3.isHidden) && !(/self?.viewStop4.isHidden)
            }
            
        }, cancel: {})
    }
       
    @IBAction func buttonContinueClicked(_ sender: Any) {
        addStops()
        
    }
    
    @IBAction func buttonCrossClicked(_ sender: Any) {
        removeChildViewController()
    }
    
    @IBAction func buttonAddLocationclicked(_ sender: UIButton) {
        
            // Stop1- 2, Stop2- 3, Stop3- 4, Stop4- 5, DropOff -6
            switch sender.tag {
            case 2:
                GooglePlaceDataSource.sharedInstance.showAutocomplete {[weak self] (place) in
                               
                    self?.txtStop1.text = place?.formattedAddress
                    self?.addStoppageData(place: place, priority: 1)
                }
                
            case 3:
                
                GooglePlaceDataSource.sharedInstance.showAutocomplete {[weak self] (place) in
                               
                    self?.txtStop2.text = place?.formattedAddress
                    self?.addStoppageData(place: place, priority: 2)
                    
                }
                
            case 4:
                
                GooglePlaceDataSource.sharedInstance.showAutocomplete {[weak self] (place) in
                               
                    self?.txtStop3.text = place?.formattedAddress
                    self?.addStoppageData(place: place, priority: 3)
                    
                }
                
            case 5:
                
                GooglePlaceDataSource.sharedInstance.showAutocomplete {[weak self] (place) in
                               
                    self?.txtStop4.text = place?.formattedAddress
                    self?.addStoppageData(place: place, priority: 4)
                    
                }
                
            case 6:
                
                GooglePlaceDataSource.sharedInstance.showAutocomplete {[weak self] (place) in
                               
                    self?.txtDropOffLocation.text = place?.formattedAddress
                    
                    self?.currentOrder?.dropOffAddress = place?.formattedAddress
                    self?.currentOrder?.dropOffLongitude = place?.coordinate.longitude
                    self?.currentOrder?.dropOffLatitude = place?.coordinate.latitude
                }
                
            default:
                break
            }
    }
}


//MARK:- API
extension EditLocationViewController {
    
    func addStops() {
        
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        
        let obj = BookServiceEndPoint.addStops(orderId: currentOrder?.orderId, stops: rideStops.toJSONString(), dropOffAddress: currentOrder?.dropOffAddress, dropOffLatitude: currentOrder?.dropOffLatitude, dropOffLongitude: currentOrder?.dropOffLongitude)
        
        obj.request(header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token, "secretdbkey": APIBasePath.secretDBKey]) {  [weak self] (response) in
            
            switch response {
            case .success(let data):
                debugPrint("Successs")
                
                guard let modal = (data as? [OrderCab])?.first else {return}
                
                DispatchQueue.main.async {[weak self] in
                    
                    self?.removeChildViewController()
                    self?.currentOrder = modal
                    self?.delegate?.ongoingRideLocationEdited(order: self?.currentOrder)
                    (ez.topMostVC as? OngoingRideDetailsViewController)?.dismissVC(completion: nil)
                }
                
            case .failure(let strError):
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
            }
        }
    }
    
}
