//
//  DeliveryAddressCell.swift
//  Clikat
//
//  Created by cblmacmini on 5/19/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import TYAlertController
import IQKeyboardManager
import EZSwiftExtensions
import CoreLocation

class DeliveryAddressCell: ThemeTableCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var labelPlaceholder : UILabel!
    
    let arrTextfieldNames = [L10n.Landmark.string , L10n.AddressLineFirst.string , L10n.AddressLineSecond.string , L10n.HouseNo.string]
    
    var selectedIndexPath : IndexPath?// = IndexPath(row: -1, section: 0)
    
    var collectionDataSource = CollectionViewDataSource() {
        didSet {
            collectionView.register(UINib(nibName: CellIdentifiers.DeliveryAddressCollectionCell,bundle: nil), forCellWithReuseIdentifier: CellIdentifiers.DeliveryAddressCollectionCell)
            collectionView.dataSource = collectionDataSource
            collectionView.delegate = collectionDataSource
        }
    }
    
    var arrAddress : [Address]? {
        didSet {
            labelPlaceholder?.isHidden = arrAddress?.count == 0 ? false : true
            btnEdit.isHidden =  arrAddress?.count == 0 ? true : false
            
            configureCollectionView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension DeliveryAddressCell {
    
    func configureCollectionView() {
        collectionView.allowsMultipleSelection = false
        collectionDataSource = CollectionViewDataSource(items: arrAddress, tableView: collectionView, cellIdentifier: CellIdentifiers.DeliveryAddressCollectionCell, headerIdentifier: nil, cellHeight: collectionView.frame.size.height - MidPadding, cellWidth: ScreenSize.SCREEN_WIDTH / 1.6, configureCellBlock: {
            [weak self] (cell, item) in
            guard let self = self else { return }
            
            self.configureCell(cell: cell,item: item)
            
            }, aRowSelectedListener: {
                [weak self] (indexPath) in
                guard let self = self else { return }
                
                self.configureCellSelection(indexPath: indexPath)
        })
        if /arrAddress?.count > 0 {
            self.configureCellSelection(indexPath: IndexPath(row: 0, section: 0))
        }

    }
    
    func configureCell(cell : Any?,item : Any?){
        
        guard let tempCell = cell as? DeliveryAddressCollectionCell,
            let address = item as? Address
            else { return }
        
        let index = arrAddress?.index(of: address) ?? -2

        let isSeleted = index == selectedIndexPath?.row
        tempCell.address = address
        tempCell.imageViewSelected.isHidden = !isSeleted
        tempCell.viewBg.layer.borderColor = isSeleted ? Colors.MainColor.color().cgColor : UIColor.lightGray.cgColor
        tempCell.viewBg.backgroundColor = isSeleted ? Colors.MainColor.color().withAlphaComponent(0.1) : UIColor.white
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(DeliveryAddressCell.handleLongPress(sender:)))
        
        tempCell.addGestureRecognizer(longPress)
    }
    
    func configureCellSelection(indexPath : IndexPath){
        selectedIndexPath = indexPath
        btnEdit.isEnabled = true
        collectionView.reloadData()
    }
    
    @objc func handleLongPress(sender : UILongPressGestureRecognizer){
        guard let indexPath = collectionView.indexPathForItem(at: sender.location(in: collectionView)),let cell = collectionView.cellForItem(at: indexPath) as? DeliveryAddressCollectionCell else { return }
        
        if sender.state == .began {
            cell.viewBg.backgroundColor = UIColor.red.withAlphaComponent(0.25)
            
            var context = UIGraphicsGetCurrentContext()
            UIView.beginAnimations(nil, context: &context)
            UIView.setAnimationDuration(0.3)
            UIView.setAnimationTransition(.flipFromLeft, for: cell, cache: true)
            UIView.commitAnimations()
            deleteContent(indexPath: indexPath,cell: cell)
        }
    }
    
    func deleteContent(indexPath : IndexPath,cell : DeliveryAddressCollectionCell){
        
        UtilityFunctions.showAlert(title: nil, message: L10n.AreYouSureYouWantToDeleteThisAddress.string, success: {
            [weak self] in
            
            self?.deleteAddressWebservice(addressId: self?.arrAddress?[indexPath.row].id)
            self?.collectionDataSource.items?.remove(at: indexPath.row)
            self?.arrAddress?.remove(at: indexPath.row)
            self?.collectionView.reloadData()
            self?.btnEdit.isEnabled = (self?.arrAddress?.count ?? 0) > 0 ? true : false
            }) { [weak self] in
                guard let self = self else { return }
                
                guard let selectedIndex = self.selectedIndexPath else {
                    cell.viewBg.backgroundColor = UIColor.white
                    return
                }
                cell.viewBg.backgroundColor = indexPath ==  selectedIndex ? Colors.MainColor.color().withAlphaComponent(0.1) : UIColor.white
        }   
    }
    
    func deleteAddressWebservice(addressId : String?){
        APIManager.sharedInstance.opertationWithRequest(withApi: API.DeleteAddress(FormatAPIParameters.DeleteAddress(addressId: addressId).formatParameters())) { (response) in
            
        }
    }
}

//MARK: - Button Actions
extension DeliveryAddressCell {
    
    @IBAction func actionEdit(sender: UIButton) {
        if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() != .denied {
            
            showAddAddressController(address: arrAddress?[selectedIndexPath?.row ?? 0],isEdit: true)
        }else {
            guard let window = UIApplication.shared.delegate?.window,let controller = window?.rootViewController else { return }
            UtilityFunctions.alertToEncourageLocationAccess(viewController: controller)
        }
    }
    
    @IBAction func actionAddNew(sender: UIButton) {
        if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() != .denied {
            showAddAddressController(address: nil,isEdit: false)
        }else {
            guard let window = UIApplication.shared.delegate?.window,let controller = window?.rootViewController else { return }
            UtilityFunctions.alertToEncourageLocationAccess(viewController: controller)
        }
    }
}
//MARK: - Address Selector
extension DeliveryAddressCell {
    
    func showAddAddressController(address : Address?,isEdit : Bool) {
        guard let controller = ez.topMostVC else { return }
        let VC = StoryboardScene.Options.instantiateAddressPickerViewController()
        controller.dim(direction: .In, alpha: 0.5, speed: 0.5)
        controller.modalPresentationStyle = .overCurrentContext
        VC.selectedAddress = address
        VC.isEdit = isEdit
        if isEdit {
            VC.placeLink = address?.placeLink
        }
        VC.saveAddressBlock = { [weak self] (selectedAddress) in
            self?.handleAddressBlock(address: selectedAddress, isEdit: isEdit)
        }
        controller.presentVC(VC)
    }
}

//MARK: - Alert

extension DeliveryAddressCell {
    
    func handleAddressBlock(address : Address,isEdit : Bool){
        
        if isEdit {
            address.id = arrAddress?[selectedIndexPath?.row ?? 0].id
            collectionDataSource.items?[selectedIndexPath?.row ?? 0] = address
            arrAddress?[selectedIndexPath?.row ?? 0] = address
        }else {
            collectionDataSource.items?.append(address)
            arrAddress?.append(address)
        }
        addAddress(address: address,isEdit: isEdit)
    }
}

//MARK: - Webservice Edit and Add Address

extension DeliveryAddressCell {
    
    func addAddress(address : Address?,isEdit : Bool){
        
        let params : [String : Any]?
        if isEdit {
            guard let selectedAddressId = arrAddress?[selectedIndexPath?.row ?? 0].id else { return }
            params = FormatAPIParameters.EditAddress(address: address, addressId: selectedAddressId).formatParameters()
        }else {
            params = FormatAPIParameters.AddNewAddress(address: address).formatParameters()
        }
        let api = isEdit ? API.EditAddress(params) : API.AddNewAddress(params)
        
        APIManager.sharedInstance.opertationWithRequest(withApi: api) { (response) in
            weak var weakSelf = self
            switch response {
            case .Success(let address):
                weakSelf?.addAddressHandler(addedAddress: address,isEdit: isEdit)
            case .Failure(_):
                break
            }
        }
    }
    
    func addAddressHandler(addedAddress : Any?,isEdit : Bool){
        guard let address = addedAddress as? Address,let index = arrAddress?.count else { return }
        
        let saveIndex = isEdit ? (selectedIndexPath?.row ?? 0) : index - 1
        arrAddress?[saveIndex] = address
        collectionDataSource.items?[saveIndex] = address
        collectionView.reloadData()
    }
}

//MARK: - TextField Delegates 

extension DeliveryAddressCell : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
}
