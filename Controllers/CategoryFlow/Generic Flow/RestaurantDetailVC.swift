
//
//  RestaurantDetailVC.swift
//  Sneni
//
//  Created by Sandeep Kumar on 04/07/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit
import SkeletonView
import EZSwiftExtensions

class RestaurantDetailVC: CategoryFlowBaseViewController, UIPopoverPresentationControllerDelegate, UISearchBarDelegate {
    
    //MARK:- ======== Outlets ========
    @IBOutlet weak var cartView_heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel! {
        didSet {
            lblTitle.isHidden = SKAppType.type.isJNJ
        }
    }
    @IBOutlet weak var imgTitle: UIImageView! {
        didSet {
            imgTitle.isHidden = !SKAppType.type.isJNJ
        }
    }
    @IBOutlet var viewStatusBar: UIView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.registerCells(nibNames: [ProductListCell.identifier,FlickeringRestraDetailTableViewCell.identifier])
            tableView.tableFooterView = UIView()
            tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
            tableView.delegate = self
            tableView.dataSource = self
            tableView.estimatedRowHeight = 90
        }
    }
    @IBOutlet weak var menu_button: UIButton! {
        didSet{
            menu_button.setBackgroundColor(SKAppType.type.color, forState: .normal)
            menu_button.isUserInteractionEnabled = false
            if let term = TerminologyKeys.catalogue.localizedValue() as? String{
                menu_button.setTitle(term, for: .normal)
            }
        }
    }
    
    //MARK:- ======== Variables ========
    var viewHeaderTable: RestaurantTableHeader?
    var topConstraintRange = ((CGFloat(72) + ez.screenStatusBarHeight - 20)..<CGFloat(300))
    var oldContentOffset = CGPoint.zero
    var isFilterEnable : Bool = false
    var isSearchBarClicked : Bool = false
    var filterData : [ProductList]?
    var tileForSection : [String]?
    var arrayProductList : [ProductList]? {
        didSet {
            tableView?.reloadData()
        }
    }
    var supplierData: Supplier?
    var backButton = UIButton()

    var isOpen: Bool = true{
        didSet{
            viewHeaderTable?.lblClosed?.isHidden = isOpen
        }
    }
    
    //MARK:- ======== LifeCycle ========
    @objc func updateDelegate() {
       
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // menu_button.isHidden = true
        if APIConstants.defaultAgentCode == "yummy_0122" {
            menu_button.isHidden = true
        }
        
        if SKAppType.type.isJNJ {
            topConstraintRange = (CGFloat(52)..<CGFloat(52.001))
        }
        
        if L102Language.isRTL {
            backButton = UIButton(frame: CGRect(x: ez.screenWidth - 50, y: UIApplication.shared.statusBarFrame.height, width: 40, height: 40))
        }else {
            backButton = UIButton(frame: CGRect(x: 10, y: UIApplication.shared.statusBarFrame.height, width: 40, height: 40))

        }
        backButton.imageView?.mirrorTransform()
        backButton.layer.shadowColor = UIColor.black.cgColor
        backButton.layer.shadowRadius = 2.0
        backButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        backButton.layer.shadowOpacity = 0.4
        backButton.contentVerticalAlignment = .top
        self.view.addSubview(backButton)
        backButton.setImage(UIImage(named: "ic_back_white"), for: UIControl.State.normal)
        backButton.addTarget(self, action: #selector(self.buttonBackAction), for: .touchUpInside)
        //self.navigationController?.navigationBar.isTranslucent = true
        self.startSkeletonAnimation(tableView)
        lblTitle.text = /passedData.supplier?.name
        getProductListing()
        
    }
    
    func configureHeaderView() {
        guard let supplier = self.supplierData else { return }
        if supplier.user_request_flag == 1 {
            topConstraintRange = ((CGFloat(72) + ez.screenStatusBarHeight - 20)..<CGFloat(340))
        }
         viewHeaderTable = RestaurantTableHeader(frame: .init(x: 0, y: -topConstraintRange.upperBound, width: UIScreen.main.bounds.width, height: topConstraintRange.upperBound))
         if supplier.user_request_flag == 1 {
             viewHeaderTable?.constraintImgCenterY.constant = -70
             viewHeaderTable?.viewUploadPrescription.isHidden = false
            
            self.lblPrescriptionImageName = viewHeaderTable?.lblPrescriptionImageName
            self.btnCancel = viewHeaderTable?.btnCancel
            self.imgUpload = viewHeaderTable?.imgUpload
            viewHeaderTable?.btnUploadAction.addTarget(self, action: #selector(uploadPrescription(_:)), for: .touchUpInside)
            viewHeaderTable?.btnUploadAction.addTarget(self, action: #selector(removePrescription(_:)), for: .touchUpInside)
            
         }

         tableView.addSubview(viewHeaderTable!)
        tableView.contentInset = .init(top: topConstraintRange.upperBound - 24, left: 0, bottom: 0, right: 0)
        tableView.setContentOffset(CGPoint(x: 0, y: -topConstraintRange.upperBound), animated: false)
         viewHeaderTable!.searchBar.isHidden = false
         viewHeaderTable!.btnManu.semanticContentAttribute = .forceRightToLeft
         viewHeaderTable!.btnManu.addTarget(self, action: #selector(btnMenuAction(_:)), for: .touchUpInside)
         viewHeaderTable!.btnSearch.addTarget(self, action: #selector(btnSearchAction(_:)), for: .touchUpInside)
        // viewHeaderTable.buttonBack.addTarget(self, action: #selector(self.buttonBackAction), for: .touchUpInside)
         viewHeaderTable!.searchBar.delegate = self
         viewHeaderTable!.supplier = passedData.supplier
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @objc func buttonBackAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- ======== Actions ========
    @IBAction func btnSearchAction(_ sender: Any) {
        
        isFilterEnable = !isFilterEnable
        // viewHeaderTable.btnManu.isHidden = isFilterEnable
        // viewHeaderTable.lblBlank.isHidden = isFilterEnable
        //  viewHeaderTable.btnSearch.isHidden = isFilterEnable
        // viewHeaderTable.searchBar.isHidden = !isFilterEnable
        viewHeaderTable?.searchBar.becomeFirstResponder()
    }
    
    @IBAction func actionCart(sender: AnyObject) {
        pushVC(StoryboardScene.Options.instantiateCartViewController())
        
    }
    
    func scrollToCat(id: String) {
        
    }
    
    @IBAction func btnMenuAction(_ sender: UIButton) {
        
        let buttonFrame = sender.frame
        
        let popoverContentController = PopOverVC.getVC(.splash)
        popoverContentController.modalPresentationStyle = .popover
        popoverContentController.filterData = filterData
        
        var height = CGFloat(/filterData?.count)*44.0
        let maxH = view.frame.height-sender.frame.minY
        
        if height > maxH {
            height = maxH
        }
        
        if let popoverPresentationController = popoverContentController.popoverPresentationController {
            popoverContentController.preferredContentSize = CGSize(width: 200, height: height)
            popoverPresentationController.permittedArrowDirections = []
            popoverPresentationController.sourceView = viewHeaderTable?.btnManu
            popoverPresentationController.sourceRect = buttonFrame
            popoverPresentationController.delegate = self
            popoverPresentationController.dimmingView?.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            present(popoverContentController, animated: true, completion: nil)
            
            popoverContentController.blockSelectSection = {
                [weak self] section in
                self?.tableView.scrollToRow(at: IndexPath(row: NSNotFound, section: section), at: .middle, animated: false)
                if let cell = self?.tableView.cellForRow(at: IndexPath(row: 0, section: section)) {
                  //  self?.tableView.scrollRectToVisible(CGRect(x: 0, y: cell.frame.minY-40.0-35.0-44.0, w: cell.frame.width, h: self?.tableView.frame.height ?? 0.0), animated: false)
                }
            }
        }
    }
    
    @IBAction func menu_buttonAction(_ sender: UIButton) {
        if filterData?.count == 0 {return}
        let frame = sender.bounds
        let popoverContentController = PopOverVC.getVC(.splash)
        popoverContentController.modalPresentationStyle = .popover
        popoverContentController.filterData = filterData
        
        var height = 0
        if let data = filterData{
            height = (data.count * 50) + 50
        }

        if let popoverPresentationController = popoverContentController.popoverPresentationController {
            popoverContentController.preferredContentSize = CGSize(width: 200, height: height)
            popoverPresentationController.permittedArrowDirections = .down
            popoverPresentationController.sourceView = sender
            popoverPresentationController.sourceRect = frame
            popoverPresentationController.delegate = self
            popoverPresentationController.dimmingView?.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            present(popoverContentController, animated: true, completion: nil)
            
            popoverContentController.blockSelectSection = {
                [weak self] section in
                self?.tableView.scrollToRow(at: IndexPath(row: NSNotFound, section: section), at: .middle, animated: true)
                if let cell = self?.tableView.cellForRow(at: IndexPath(row: 0, section: section)) {
                    self?.tableView.scrollRectToVisible(CGRect(x: 0, y: cell.frame.minY-40.0-35.0-44.0, w: cell.frame.width, h: self?.tableView.frame.height ?? 0.0), animated: true)
                }
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isFilterEnable = true

        if searchText.isEmpty {
            filterData = arrayProductList
        }
        else {
            var arrTemp: [ProductList] = []
            for arr in arrayProductList ?? [] {
                var products: [ProductF] = []
                for obj in arr.productValue ?? [] {
                    if obj.name?.lowercased().contains(searchText.lowercased()) ?? false {
                        products.append(obj)
                    }
                }
                if !products.isEmpty {
                    let newObj = ProductList()
                    newObj.catName = arr.catName
                    newObj.productValue = products
                    arrTemp.append(newObj)
                }
            }
            filterData = arrTemp
        }
       // filterData = searchText.isEmpty ? arrayProductList : arrayProductList?.filter({($0.productValue?.contains(where: {($0.name?.lowercased().contains(searchText.lowercased()) ?? false)}) ?? false)})
//        filterData = searchText.isEmpty ? arrayProductList : arrayProductList?.filter { (item: ProductList) -> Bool in
//            return item.productValue?.first?.name?.lowercased().contains(searchText.lowercased()) ?? false
//        }
        print(filterData)

        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        viewHeaderTable?.searchBar.showsCancelButton = true
        isSearchBarClicked = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.view.endEditing(true)
        isFilterEnable = false
        isSearchBarClicked = false
        self.filterData = self.arrayProductList
        tableView.reloadData()
        //     viewHeaderTable.btnManu.isHidden = isFilterEnable
        //  viewHeaderTable.lblBlank.isHidden = isFilterEnable
        //   viewHeaderTable.btnSearch.isHidden = isFilterEnable
        //   viewHeaderTable.searchBar.isHidden = !isFilterEnable
    }
    
    //MARK:- ======== Functions ========
    func initalSetup() {
        
    }
    
}

extension UIPopoverPresentationController {

    var dimmingView: UIView? {
       return value(forKey: "_dimmingView") as? UIView
    }
}

//MARK:- ======== Api's ========
extension RestaurantDetailVC {
    
    func getProductListing()  {
        var lati : Double?
        var longi: Double?

        if let _ = LocationSingleton.sharedInstance.tempAddAddress?.formattedAddress{
            lati = LocationSingleton.sharedInstance.tempAddAddress?.lat ?? 0.0
            longi = LocationSingleton.sharedInstance.tempAddAddress?.long ?? 0.0
            
        } else if let _ = LocationSingleton.sharedInstance.searchedAddress?.formattedAddress{
            lati = LocationSingleton.sharedInstance.searchedAddress?.lat ?? 0.0
            longi = LocationSingleton.sharedInstance.searchedAddress?.long ?? 0.0
        }
        
        let objR = API.getProductList(supplierId: /passedData.supplierId, latitude: lati ?? nil, longitude: longi ?? nil)
        
        APIManager.sharedInstance.opertationWithRequest(isLoader: false, withApi: objR) {
            [weak self] (response) in
            guard let self = self else { return }
            
            self.stopSkeletonAnimation(self.tableView)
            switch response {
            case APIResponse.Success(let object):
                guard let objModel = object as? MenuProductSection else { return }
                self.arrayProductList = objModel.arrayProduct ?? []
                self.supplierData = objModel.supplier
                self.configureHeaderView()
                self.filterData = self.arrayProductList
                self.tileForSection = self.arrayProductList?.compactMap({ $0.catName})
                
                self.viewHeaderTable?.supplier = objModel.supplier
                self.lblTitle.text = /objModel.supplier?.name
                self.checkIsOpen()
                if let section = self.arrayProductList?.firstIndex(where: { $0.catName?.lowercased() ==  /self.passedData.categoryName?.lowercased() }) {
                    //                    self.tableView.scrollToRow(at: IndexPath(row: NSNotFound, section: section), at: .middle, animated: true)
                    
                   // self.tableView.scrollToRow(at: IndexPath(row: NSNotFound, section: section), at: .middle, animated: false)
                    if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: section)) {
                        //self.tableView.scrollRectToVisible(CGRect(x: 0, y: cell.frame.minY-40.0-35.0-44.0, w: cell.frame.width, h: self.tableView.frame.height ), animated: false)
                    }
                }
                self.menu_button.isUserInteractionEnabled = true
                break
            default :
                break
            }
        }
    }
    
    func openCustomizationView(cell:ProductListCell?,product: ProductF?,cartData: Cart?,quantity: Double?,shouldHide:Bool = false,index:Int?) {
        
        let vc = StoryboardScene.Options.instantiateCustomizationViewController()
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        vc.product = product
        vc.hideAddCustom = shouldHide
        vc.index = index
        vc.cartData = cartData
        
        vc.completionBlock = { [weak self] data in
            guard let self = self else {return}
            if let obj = data as? (Bool,ProductF) { 
                if let _ = quantity { // called when add to card button is added
                    cell?.product = obj.1
                }
            }
            self.removeViewAndSaveData()
        }
        
        self.present(vc, animated: true) {
            self.createTempView()
        }
        
    }
    
    func openCheckCustomizationController(cell:ProductListCell?,productData: ProductF?,cartData: Cart?, shouldShow: Bool, index:Int?) {
        
        let vc = StoryboardScene.Options.instantiateCheckCustomizationViewController()
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        vc.cartProdcuts = cartData
        vc.product = productData
        vc.completionBlock = {[weak self] data in
            guard let self = self else {return}
            guard let productCell = cell else {return}
            if let dataValue = data as? (Bool,ProductF) {
                productCell.product = dataValue.1
                if !dataValue.0 {
                    dataValue.1.addOnValue?.removeAll()
                    self.removeViewAndSaveData()
                }
            } else if let dataValue = data as? (ProductF,Cart,Bool),let productCell = cell{
                let obj = ProductF(cart: dataValue.1)
                dataValue.0.addOnValue?.removeAll()
                let addonId = Int(obj.addOnId ?? "0")
                self.openCustomizationView(cell: cell, product: dataValue.0,cartData: dataValue.1, quantity: productCell.stepper?.value ?? 0.0, index: addonId)
            } else if let _ = data as? Bool{
                //productCell.stepper?.stepperState = !obj ? .ShouldDecrease : .ShouldIncrease
                self.removeViewAndSaveData()
            } else if let obj = data as? ProductF {
                productCell.product = obj
            } else if let _ = data as? Int {
                self.removeViewAndSaveData()
            } else if let value = data as? (Bool,Double) {
                if value.1 == 0 {
                    self.removeViewAndSaveData()
                }
                productCell.stepper?.stepperState = .ShouldDecrease
            }
        }
        
        self.present(vc, animated: true) {
            self.createTempView()
        }
        
    }
    
    func removeViewAndSaveData() {
        self.view.subviews.forEach { (view) in
            if view.tag == 10001 {
                view.removeFromSuperview()
            }
        }
    }
    
    func createTempView(){
        let view = UIView()
        view.frame = self.view.frame
        view.backgroundColor = UIColor(white: 0.10, alpha: 0.8)
        view.tag = 10001
        self.view.addSubview(view)
    }
    
    func checkIsOpen(){
        let currentDate = Date()
        
        let calender = Calendar.current
        let week = calender.component(.weekday, from: currentDate)
        let hour = calender.component(.hour, from: currentDate)
        let minutes = calender.component(.minute, from: currentDate)
//        let seconds = calender.component(.second, from: currentDate)
         let currentSec = getdatesec(hour, minutes)
        print(week)
        let timings = self.supplierData?.timing
        var obj: Timings?
        timings?.forEach({ (timeObj) in
            if (/timeObj.week_id + 1) == week{
                obj = timeObj
            }
        })

        if let timing = obj {
            
            if timing.is_open == 1 {
                 var start = /timing.start_time
                 let startComp = start.components(separatedBy: ":")
                 start = "\(getdatesec(/startComp[0].toInt(), /startComp[1].toInt()))"
                 var end = /timing.end_time
                 let endComp = end.components(separatedBy: ":")
                 end = "\(getdatesec(/endComp[0].toInt(), /endComp[1].toInt()))"
                
                if /start.toInt() < currentSec && currentSec < /end.toInt(){
                    self.isOpen = true
                    return
                }else{
                    self.isOpen = false
                }
            }
            else {
                self.isOpen = false
            }
            
        }else{
            self.isOpen = true
        }
    }
    
}


    func getdatesec(_ hour: Int, _ minute: Int) -> Int {
    //calculate the seconds since the beggining of the day for comparisions
    let dateSeconds = hour * 3600 + minute * 60

       return dateSeconds
}

//MARK:- UITableViewDelegate , UITableViewDataSource
extension RestaurantDetailVC : UITableViewDelegate , SkeletonTableViewDataSource {
    
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return FlickeringRestraDetailTableViewCell.identifier
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return isFilterEnable ? (/filterData?.count) : (/arrayProductList?.count)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return isFilterEnable ? (filterData?[section].productValue?.count ?? 0) : (arrayProductList?[section].productValue?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductListCell.identifier) as? ProductListCell else {
            fatalError("Missing ServiceCell identifier")
        }
        cell.selectionStyle = .none
        let obj = isFilterEnable ? filterData?[indexPath.section] : arrayProductList?[indexPath.section]
        let products = obj?.productValue
        
        cell.isOpen = self.isOpen
        cell.selectedIndex = indexPath.row
        if let data = products?[indexPath.row] {
            data.supplierAddrerss = self.supplierData?.address ?? ""
            cell.product = data
            let firstIndex = products?.firstIndex(where: { $0.detailed_sub_category_id == data.detailed_sub_category_id})
            if indexPath.row == firstIndex {
                cell.headerTitle = obj?.detailedSubCategory?.first(where: { $0.id == data.detailed_sub_category_id })?.name
            }
            else {
                cell.headerTitle = nil
            }
            let purchased = data.purchasedQuantity
            let total = data.totalMaxQuantity

            if (total-purchased) == 0 {
                cell.labelOutOfStock.isHidden = false
                cell.stepper?.isHidden = true
            } else {
                cell.labelOutOfStock.isHidden = true
                 cell.stepper?.isHidden = false
            }
        }
        
//        cell.newCompletionBlock = { [weak self] data in
//            guard let _ = self else {return}
//            if let value = data as? Bool,value {
//                cell.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
//            } else {
//                cell.backgroundColor = .white
//            }
//        }
        
        cell.addonsCompletionBlock = { [weak self] value in
            guard let self = self else {return}
            GDataSingleton.sharedInstance.fromCart = false
            if let data = value as? (ProductF,Bool,Double){
                if data.1 { // data.1 == true for open customization controller
                    data.0.addOnValue?.removeAll()
                    self.openCustomizationView(cell: cell, product: data.0, cartData: nil, quantity: data.2, index: indexPath.row)
                }
            } else if let data = value as? (ProductF,Cart,Bool,Double) {
                //for open checkcustomization controller
                self.openCheckCustomizationController(cell: cell, productData: data.0,cartData: data.1, shouldShow: data.2, index: indexPath.row)
            }
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude//0.001
    }
    
    //    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //
    //        return isFilterEnable ? (filterData?[section].catName ?? "") : (arrayProductList?[section].catName ?? "")
    //    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableSectionHeader"),
            let lblTitle = cell.contentView.viewWithTag(11) as? UILabel else {
                fatalError("Missing ServiceCell identifier")
        }
        let products = isFilterEnable ? filterData?[section] : arrayProductList?[section]
        lblTitle.text = /products?.catName
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //pushNextVc()
        return
//        if SKAppType.type.isJNJ {
//            return
//        }
        //        let obj: ProductList? = isFilterEnable ? filterData?[indexPath.section] : arrayProductList?[indexPath.section]
        //        obj?.productValue?[indexPath.row].openDetail()
        
        let products = isFilterEnable ? filterData?[indexPath.section].productValue : arrayProductList?[indexPath.section].productValue
        guard let data = products?[indexPath.row].desc else { return }
               
        let vc = RestaurantDescVC.getVC(.options)
            vc.data = data
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
       
        self.present(vc, animated: true) {
           // self.createTempView()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let viewHeaderTable = viewHeaderTable else { return }
        let delta =  scrollView.contentOffset.y - oldContentOffset.y
        viewHeaderTable.frame.origin.y = scrollView.contentOffset.y

        var height = viewHeaderTable.frame.size.height

        if delta > 0 && viewHeaderTable.frame.height > topConstraintRange.lowerBound && scrollView.contentOffset.y > -topConstraintRange.upperBound {
            height -= delta
        }
        
        if delta < 0 && viewHeaderTable.frame.height < topConstraintRange.upperBound && scrollView.contentOffset.y < 0 {
            height -= delta
        }
        
        height = [height, topConstraintRange.lowerBound].max() ?? 0.0
        height = [height, topConstraintRange.upperBound].min() ?? 0.0
        if height <= topConstraintRange.lowerBound {
            viewStatusBar.alpha = 1
            backButton.isHidden = true
        }
        else {
            viewStatusBar.alpha = 0
            backButton.isHidden = false
        }
        viewHeaderTable.frame.size.height = height
//        if isSearchBarClicked {
//            scrollView.contentOffset.y =  oldContentOffset.y
//        }
        oldContentOffset = scrollView.contentOffset

        scrollView.insertSubview(viewHeaderTable, at: scrollView.subviews.count-1)
        //        viewHeaderTable.bringSubviewToFront(scrollView)
    }
}

////MARK:- UIViewControllerTransitioningDelegate
//extension RestaurantDetailVC : UIViewControllerTransitioningDelegate {
//    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
//        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
//    }
//}
