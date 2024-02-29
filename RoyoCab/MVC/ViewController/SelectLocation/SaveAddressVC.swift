//
//  SaveAddressVC.swift
//  Buraq24
//
//  Created by Apple on 01/08/19.
//  Copyright © 2019 CodeBrewLabs. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import DropDown

class SaveAddressVC: UIViewController {
//
//    @IBOutlet var txtLocation: UITextField?
//    @IBOutlet var txtName: UITextField?
//
//    @IBOutlet var tblLocationSearch: UITableView?
//    @IBOutlet var viewLocationTableContainer: UIView?
//    //    var serviceRequest : ServiceRequest = ServiceRequest()
//    var addSavedAddress : AddSaveAddresses? = AddSaveAddresses()
//
//    var arrayAddresses = [AddSaveAddresses]()
//    var googleDropOffLocation : GooglePlaceDataSource?
//    var tableDataSource : TableViewDataSource?
//    var tempLocation : String = ""
//
//
//
//    var locationLatest : String = ""
//    var latitudeLatest : Double?
//    var longitudeLatest : Double?
//    var results = [GMSAutocompletePrediction](){
//        didSet {
//            viewLocationTableContainer?.alpha = results.count == 0 ? 0 : 1
//            tblLocationSearch?.reloadData()
//        }
//    }
//
//    let user = UDSingleton.shared.userData
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        if txtLocation?.text != nil {
//            configureLocationSearchTableView()
//
//        }
//        self.arrayAddresses = (user?.addSaveAddresses ?? [AddSaveAddresses]())
//        // Do any additional setup after loading the view.
//    }
//
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
//
//    @IBAction func btnBack(_ sender: UIButton){
//        results.removeAll()
//        self.popVC()
//    }
//
//    @IBAction func btnSaveAddress(_sender: UIButton){
//        results.removeAll()
//        if txtName?.text != "", txtLocation?.text != "", latitudeLatest != nil, longitudeLatest != nil  {
//            self.addSavedAddress?.latitude = latitudeLatest
//            self.addSavedAddress?.longitude = longitudeLatest
//            self.addSavedAddress?.locationName = txtLocation?.text
//            self.addSavedAddress?.name = txtName?.text
//
//            arrayAddresses.append(addSavedAddress!)
//             self.user?.addSaveAddresses = arrayAddresses
//
//
//
//         //   self.user?.addSaveAddresses = self.addSavedAddress
////            self.user?.addSaveAddresses?.append(addSavedAddress!)
//            UDSingleton.shared.userData = user
//            popVC()
//        }
//        else{
//        Alerts.shared.show(alert: "", message: "Enter Complete Info", type: .error)
//        }
//    }
//
//    func configureLocationSearchTableView() {
//
//
//        googleDropOffLocation = GooglePlaceDataSource(txtField: txtLocation, resListener: {[weak self]  (places) in
//            self?.tableDataSource?.items = places
//            self?.tblLocationSearch?.reloadData()
//            self?.viewLocationTableContainer?.alpha = CGFloat(places.count)
//        })
//
//        let   configureCellBlock :  ListCellConfigureBlock? = {  ( cell , item , indexPath) in
//            if let cell = cell as? LocationResultCell, let model = item as? GMSAutocompletePrediction {
//                cell.assignData(item: model)
//            }
//        }
//
//        let didSelectBlock : DidSelectedRow = {[weak self] ( indexPath , cell , item) in
//
//            if  let model = item as? GMSAutocompletePrediction {
//
//
//                self?.txtLocation?.text = model.attributedFullText.string
//                //                self?.addSavedAddress?.locationName = model.attributedFullText.string
//
//                //                self?.user?.addSaveAddresses?.append(self?.addSavedAddress ?? AddSaveAddresses()!)
//
//
//                //                    self?.tempLocation = model.attributedFullText.string
//                //                }
//                //                self?.locationLatest = model.attributedFullText.string
//                self?.getPlaceDetails(strPlaceID: model.placeID)
//            }
//        }
//
//        tableDataSource = TableViewDataSource(items: results, tableView: tblLocationSearch, cellIdentifier: R.reuseIdentifier.locationResultCell.identifier, cellHeight: UITableViewAutomaticDimension)
//
//        tableDataSource?.configureCellBlock = configureCellBlock
//        tableDataSource?.aRowSelectedListener = didSelectBlock
//
//        tblLocationSearch?.delegate = tableDataSource
//        tblLocationSearch?.dataSource = tableDataSource
//
//        tblLocationSearch?.reloadData()
    }
//
//
////    func setUpdatedAddress(location : String , coordinate : CLLocationCoordinate2D?) {
//
//        //        viewSelectService.lblLocationName.text = location
//
////        CouponSelectedLocation.latitude = /coordinate?.latitude
////        CouponSelectedLocation.longitude = /coordinate?.longitude
////        CouponSelectedLocation.selectedAddress = location
////
////        locationLatest = location
////        latitudeLatest = Double(/coordinate?.latitude)
////        longitudeLatest =  Double(/coordinate?.longitude)
//
//        //        if screenType.mapMode == .SelectingLocationMode {
//
////        if txtLocation?.isEditing == true {
////
////            txtLocation?.text = location
//            //            self.addSavedAddress?.latitude = Double(/coordinate?.latitude)
//            //            self.addSavedAddress?.longitude = Double(/coordinate?.longitude)
//            //            self.addSavedAddress?.locationName = location
//            //
//            //            self.user?.addSaveAddresses?.append(addSavedAddress!)
//
//            //            self.user?.addSaveAddresses.latitude = Double(/coordinate?.latitude)
//            //            self.user?.addSaveAddresses.longitude = Double(/coordinate?.longitude)
//            //            self.user?.addSaveAddresses.locationName = location
////            UDSingleton.shared.userData = user
//
//
//            //                serviceRequest.locationName = location
//            //                serviceRequest.longitude =  Double(/coordinate?.longitude)
//            //                serviceRequest.latitude =  Double(/coordinate?.latitude)
////            tempLocation = location
//
//            //            }
////        }
////    }
//
//
//    func getPlaceDetails(strPlaceID : String?) {
//
//        GooglePlaceDataSource.placeDetails(placeID: /strPlaceID) { [weak self](place) in
//            guard let placeDetail = place else{return}
//
//            ///Assign Latitude and LOngitude
//            if /self?.txtLocation?.isEditing  {
//
//                self?.results.removeAll()
//
//                //                self?.serviceRequest.latitudeDest =  /placeDetail.coordinate.latitude
//                //                self?.serviceRequest.longitudeDest =  /placeDetail.coordinate.longitude
//
//            }
//            self?.longitudeLatest = /placeDetail.coordinate.longitude
//            self?.latitudeLatest = /placeDetail.coordinate.latitude
//            //
//            //            self?.setCameraGoogleMap(latitude: /placeDetail.coordinate.latitude, longitude: /placeDetail.coordinate.longitude)
//
//        }
//    }
//
//}

//extension SaveAddressVC :UITextFieldDelegate {
//
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//
//        if textField == txtLocation {
//
//            //            locationEdit = .DropOff
//            if let latitude = user?.addSaveAddresses?[/user?.addSaveAddresses?.count - 1].latitude, let longitude = user?.addSaveAddresses?[/user?.addSaveAddresses?.count - 1].longitude , let previousSelected = user?.addSaveAddresses?[/user?.addSaveAddresses?.count - 1].locationName {
//
//                //            if let latitude =   serviceRequest.latitude , let longitude = serviceRequest.longitude  , let previousSelected = serviceRequest.locationName {
//
//                textField.text = previousSelected
//                //                self.setCameraGoogleMap(latitude: latitude, longitude: longitude)
//            }
//        }
//    }
//
//}
