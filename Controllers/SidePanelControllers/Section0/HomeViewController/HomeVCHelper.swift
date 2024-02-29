//
//  HomeVCHelper.swift
//  Sneni
//
//  Created by cbl41 on 1/20/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import Foundation
import UIKit
import GooglePlacePicker
import GoogleMaps
import EZSwiftExtensions
import SupportSDK

//MARK:- UISearchBarDelegate
extension HomeViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count ?? 0 > 0 {
                    
                    var isValue : Bool?
        //            let _ = self.filterData?.filter({ (item: ProductList) -> Bool in
        //                guard let section = self.filterData?.firstIndex(of: item) else {return false}
        //                let _ = item.productValue?.filter({ (data) -> Bool in
        //                    let isContain = data.name?.lowercased().contains(searchBar.text!.lowercased())
        //                    isValue = isContain
        //                    if isValue ?? false {
        //                        guard let row = self.filterData?[section].productValue?.firstIndex(of: data) else {return false}
        //                        let indexPath = IndexPath(row: row, section: section)
        //                        self.tableView.scrollToRow(at: indexPath, at: .none, animated: true)
        //                    }
        //                    return isValue ?? false
        //                })
        //                return isValue ?? false
        //            })
        //
                    var filteredArr: [ProductList] = []
                    //let offset = HomeScreenSection.allValues.firstIndex(of: .ProductList)
                    let allArr = GDataSingleton.sharedInstance.homeData?.arrProductsList ?? []
                    for item in allArr {
                        var filteredSubArr: [ProductF] = []
                        for data in (item.productValue ?? []) {
                            let isContain = data.name?.lowercased().contains(searchBar.text!.lowercased())
                                isValue = isContain
                                if isValue ?? false {
                                    filteredSubArr.append(data)
                                    //let indexPath = IndexPath(row: row, section: section + /offset)
                                    //self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                    //break
                                }
                        }
                        if filteredSubArr.count > 0 {
                            let itemNew = item
                            itemNew.productValue = filteredSubArr
                            filteredArr.append(itemNew)
                        }
                    }
                    GDataSingleton.isSearching = true
                    GDataSingleton.filteredProducts = filteredArr
                    tableView.reloadData()
                }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.becomeFirstResponder()
        self.searchBar.showsCancelButton = true
       // self.tableView.scrollToRow(at: IndexPath(row: NSNotFound, section: 2), at: .middle, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.view.endEditing(true)
//        isFilterEnable = false
        GDataSingleton.isSearching = false
        tableView.reloadData()
    }
}


//MARK:- UIPopoverPresentationControllerDelegate
extension HomeViewController : UIPopoverPresentationControllerDelegate {
    
    @IBAction func menu_buttonAction(_ sender: UIButton) {
        
        let allArr = GDataSingleton.sharedInstance.homeProductList ?? []
        let offset = HomeScreenSection.allValues.firstIndex(of: .ProductList)
        
        let frame = sender.bounds
        let popoverContentController = PopOverVC.getVC(.splash)
        popoverContentController.modalPresentationStyle = .popover
        popoverContentController.filterData = allArr

        let height = CGFloat(allArr.count)*44.0

        if let popoverPresentationController = popoverContentController.popoverPresentationController {
            popoverContentController.preferredContentSize = CGSize(width: 200, height: height)
            popoverPresentationController.permittedArrowDirections = .down
            popoverPresentationController.sourceView = sender
            popoverPresentationController.sourceRect = frame
            popoverPresentationController.delegate = self
            present(popoverContentController, animated: true, completion: nil)

            popoverContentController.blockSelectSection = {
                [weak self] section in
                self?.tableView.scrollToRow(at: IndexPath(row: NSNotFound, section: section + /offset), at: .middle, animated: true)
                //                if let cell = self?.tableView.cellForRow(at: IndexPath(row: 0, section: section)) {
                //                    self?.tableView.scrollRectToVisible(CGRect(x: 0, y: cell.frame.minY-40.0-35.0-44.0, w: cell.frame.width, h: self?.tableView.frame.height ?? 0.0), animated: true)
                //                }
            }
        }
    }
    
    //UIPopoverPresentationControllerDelegate inherits from UIAdaptivePresentationControllerDelegate, we will use this method to define the presentation style for popover presentation controller
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    //UIPopoverPresentationControllerDelegate
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
}

//MARK: - Reverse Geocode Location
extension HomeViewController {
    
    func reverseGeocodeLocation(place: GMSPlace) {
        
        let location = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location) {
            [weak self] (placeMark, error) in
            guard let self = self else { return }
            if let placeMark = placeMark{
                LocationSingleton.sharedInstance.selectedAddress = placeMark.first
                self.locationSelected()
            }
        }
    }
    
}

////MARK:- UIViewControllerTransitioningDelegate
//extension HomeViewController : UIViewControllerTransitioningDelegate {
//    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
//        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
//    }
//}


//MARK: - TextField delegate
extension HomeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        handleSearch(searchKey: textField.text)
        return true
    }
    
    func openBarCodeScanner(){
        if UtilityFunctions.isCameraPermission() {
            let barCodeVc = StoryboardScene.Options.instantiateBarCodeScannerViewController()
            barCodeVc.isCompareProducts = true
            pushVC(barCodeVc)
        }else {
            UtilityFunctions.alertToEncourageCameraAccessWhenApplicationStarts(viewController: self)
        }
    }
    
    func handleSearch(searchKey : String?){
        view.endEditing(true)
        let VC = StoryboardScene.Options.instantiateCompareProductsController()
        VC.searchKey = searchKey
        VC.isHomeSearch = true
        pushVC(VC)
    }
}


//MARK: - Action Methods
extension HomeViewController {
    
    @IBAction func svDelivery_buttonAction(_ sender: UIButton) {
        
        if deliveryType == 0 {return}
        deliveryType = 0
        svPickup_button.isSelected = sender.isSelected
        sender.isSelected = !sender.isSelected
        self.openLocationController()
        
    }
    
    @IBAction func svPickup_buttonAction(_ sender: UIButton) {
        deliveryType = 1
        svDelivery_button.isSelected = sender.isSelected
        sender.isSelected = !sender.isSelected
        
    }
    
    @IBAction func profile_buttonAction(_ sender: Any) {
        
        guard let _ = GDataSingleton.sharedInstance.loggedInUser?.firstName else{
            UtilityFunctions.sharedAppDelegateInstance().window?.rootViewController?.presentVC(StoryboardScene.Register.instantiateLoginViewController())
            return
        }
        let settingsVC = StoryboardScene.Options.instantiateSettingsViewController()
        //settingsVC.delegate = self
        pushVC(settingsVC)
        
    }
    
    @IBAction func btnTapVegOnly(sender: AnyObject) {
        
        //        isVegOnly = !isVegOnly
        
    }
    
    @IBAction func searchTextFieldClick(sender: AnyObject) {
        
        let vc = ItemTableViewController.getVC(.main)
        pushVC(vc)
        
    }
    
    @IBAction func didTapSearch(_ sender: AnyObject) {
        
        let vc = ItemTableViewController.getVC(.main)
        pushVC(vc)
    }
    
    @IBAction func didTapBotChat(_ sender: AnyObject) {
        ZDKLocalization.printAllKeys()
        
//        let viewController = RequestUi.buildRequestUi(with: [])
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
//        self.navigationController?.pushViewController(viewController, animated: true)

        let helpCenter = HelpCenterUi.buildHelpCenterOverviewUi(withConfigs: [])
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.pushViewController(helpCenter, animated: true)
        
//        let VC = ChatBotChatVC.getVC(.bot)
//        ez.topMostVC?.pushVC(VC)
    }
    
    @IBAction func actionCart(sender: AnyObject) {
        pushVC(StoryboardScene.Options.instantiateCartViewController())
    }
    
    @IBAction func actionLanguage(sender: UIButton) {
        
//        if DBManager.sharedManager.isCartEmpty() {
//            changeLanguage(sender: senOlocder)
//        } else {
//            UtilityFunctions.showSweetAlert(title: L10n.AreYouSure.string, message: L10n.ChangingTheLanguageWillClearYourCart.string, style: AlertStyle.Success, success: { [weak self] in
//                self?.changeLanguage(sender: sender)
//            }) {
//            }
//        }
    }
    
    @IBAction func actionArea(sender : UIButton) {
        self.openLocationController()
        
    }
    
    @IBAction func actionMenu(sender: UIButton) {
        toggleSideMenuView()
        
    }
    
    func openLocationController() {
        //Nitin
        let vc = NewLocationViewController.getVC(.main)
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        vc.completionBlock = { [weak self] data in
            guard let strongSelf = self else { return }
            var lati : Double?
            var longi: Double?
            
            if let value = data as? Bool,value == true {
                // value == true is for current location selection
                if let name = LocationSingleton.sharedInstance.selectedAddress?.name {
                    if let locality = LocationSingleton.sharedInstance.selectedAddress?.locality {
                        strongSelf.strArea = name + " " + locality
                    }
                }
            } else if let _ = data as? [String:Any] {
                if let address = LocationSingleton.sharedInstance.tempAddAddress?.formattedAddress{
                    strongSelf.strArea = address
                }
                lati = LocationSingleton.sharedInstance.tempAddAddress?.lat ?? 0.0
                longi = LocationSingleton.sharedInstance.tempAddAddress?.long ?? 0.0
            } else if let value = data as? Bool, value == false {
                if let address = LocationSingleton.sharedInstance.searchedAddress?.formattedAddress{
                    strongSelf.strArea = address
                }
                lati = LocationSingleton.sharedInstance.searchedAddress?.lat ?? 0.0
                longi = LocationSingleton.sharedInstance.searchedAddress?.long ?? 0.0
            }
            
            strongSelf.isLoadingFirstTime = true
            strongSelf.startSkeletonAnimation(strongSelf.tableView)
            strongSelf.isDataFetched = true
            if let lat = lati, let long = longi {
                strongSelf.webserviceHomeData(latitude: lat, longitude: long)
            } else {
                strongSelf.webserviceHomeData(latitude: nil, longitude: nil)
            }
            
        }
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func viewAllOffers(sender : UIButton?) {
        
        let VC = ItemListingViewController.getVC(.main)
        VC.isOffers = true
        pushVC(VC)
    }
    
//    func changeLanguage(sender : UIButton){
//        let delegate = UtilityFunctions.sharedAppDelegateInstance()
//        sender.isSelected ?
//            delegate.switchViewControllers(isArabic: false) : delegate.switchViewControllers(isArabic: true)
//        sender.isSelected = !sender.isSelected
//        DBManager.sharedManager.cleanCart()
//    }
    
}
