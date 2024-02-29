//
//  SelectLocationVC.swift
//  Buraq24
//
//  Created by MANINDER on 03/08/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit
import GooglePlaces

enum LocationTypeCab : String{
    case PickUpDropOff = "PickUpDropOff"
    case OnlyDropOff = "OnlyDropOff"
}

enum NavigationType : String{
    case Basic = "Basic"
    case Location = "Location"
    case OnlyBack = "OnlyBack"

}


class SelectLocationVCCab: UIViewController {
    
   //MARK:- OUTLETS
    @IBOutlet var txtFieldPickUpLocation: UITextField!
    @IBOutlet var viewPickUpLocation: UIView!
    @IBOutlet var tblResults: UITableView!
    @IBOutlet var constraintPickUpViewHeight: NSLayoutConstraint!
    @IBOutlet var txtFieldDropOffLocation: UITextField!
    
    
    //MARK:- PROPERTIES
    var locationType : LocationTypeCab = .OnlyDropOff
    var tableDataSource : TableViewDataSourceCab?
    var configureCellBlock: ListCellConfigureBlockCab?
    var googlePickupLocation : GooglePlaceDataSource?
    var googleDropOffLocation : GooglePlaceDataSource?
    var results = [GMSAutocompletePrediction]()
    
    //MARK:- VIEW CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        changeUI()
        configureTableView()
        
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- FUNCTIONS
    func changeUI() {
        viewPickUpLocation.isHidden =  locationType == .OnlyDropOff
        constraintPickUpViewHeight.constant =  locationType == .OnlyDropOff ? 0 : 50
        
        googlePickupLocation = GooglePlaceDataSource(txtField: txtFieldPickUpLocation, resListener: { [weak self] (places) in
            self?.tableDataSource?.items = places
            self?.tblResults.reloadData()
        })
        
        
        googleDropOffLocation = GooglePlaceDataSource(txtField: txtFieldDropOffLocation, resListener: {[weak self]  (places) in
            self?.tableDataSource?.items = places
            self?.tblResults.reloadData()
        })
    }
}

//MARK: - Configure CollectionView
extension SelectLocationVCCab {
    
    func configureTableView() {
        
        configureCellBlock = { ( cell , item , indexpath) in
            
        }
        tableDataSource = TableViewDataSourceCab(items: results, tableView: tblResults, cellIdentifier: R.reuseIdentifier.locationResultCell.identifier, cellHeight: UITableView.automaticDimension)
        
        tableDataSource?.configureCellBlock = configureCellBlock
        
        tblResults.delegate = tableDataSource
        tblResults.dataSource = tableDataSource
        
        tblResults.reloadData()
    }
    
    
}
