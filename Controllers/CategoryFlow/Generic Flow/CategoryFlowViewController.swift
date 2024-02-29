//
//  CategoryFlowViewController.swift
//  Clikat
//
//  Created by cbl73 on 5/6/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class PassedData {
    
    var productId : String?
    var supplierId : String?
    var supplier : Supplier?
    var supplierBranchId : String?
    var categoryId : String? {
        didSet {
            if mainCategoryId == nil {
                mainCategoryId = categoryId
            }
        }
    }
    var mainCategoryId: String?
    var subCategoryId : String?
    var subCategoryName : String?
    var categoryFlow : String?
    var categoryOrder : String?
    var categoryName : String?
    var hasSubCats = true
    var subCats : [Categorie]?
    var isQuestion = false

    convenience init(withCatergoryId categoryId : String? , categoryFlow : String? , supplierId : String? , subCategoryId : String? , productId : String? , branchId : String?,subCategoryName : String? ,categoryOrder : String?,categoryName : String?, hasSubCats: Bool = true, isQuestion: Bool = false){
        self.init()
       if mainCategoryId == nil {
           mainCategoryId = categoryId
       }
        self.categoryId = categoryId
        self.categoryFlow = categoryFlow
        self.supplierId = supplierId
        self.categoryId = categoryId
        self.subCategoryId = subCategoryId
        self.supplierBranchId = branchId
        self.productId = productId
        self.subCategoryName = subCategoryName
        self.categoryOrder = categoryOrder
        self.categoryName = categoryName
        self.hasSubCats = hasSubCats
        self.isQuestion = isQuestion
    }
    init(){
    }
}

class CategoryFlowBaseViewController : BaseViewController {
    
    var passedData : PassedData = PassedData()
    var laundryData : OrderSummary?
    func pushNextVc(){
        do {
            
            let nextVC = try CategoryMapping.nextViewController(withFlow: passedData.categoryFlow, hasSubCat: passedData.hasSubCats, currentViewController: self) as? CategoryFlowBaseViewController
            guard let tempNextVc = nextVC else{
                return
            }
            FilterCategory.supplierId = passedData.supplierId
//passedData.supplierBranchId
            let passedD = PassedData(withCatergoryId: passedData.categoryId , categoryFlow:  passedData.categoryFlow ,supplierId: passedData.supplierId ,subCategoryId: passedData.subCategoryId , productId: passedData.productId , branchId: nil ,subCategoryName : passedData.subCategoryName ,categoryOrder:  passedData.categoryOrder, categoryName:passedData.categoryName, hasSubCats: passedData.hasSubCats)
            passedD.mainCategoryId = passedData.mainCategoryId
            nextVC?.passedData = passedD
            if !(nextVC is ItemListingViewController) {
                nextVC?.passedData.supplierBranchId = passedData.supplierBranchId//TODO: Maybe only for .home service
            }
            nextVC?.passedData.isQuestion = passedData.isQuestion
            nextVC?.laundryData = laundryData
            
//            if SKAppType.type == .home && passedData.isQuestion {
//                    getQuestions(supplier: supplier, supplierId: supplierId, supplierBranchId: supplierBranchId)
//                }
//                else {
//                    SupplierListingViewController.showProducts(supplier: supplier, supplierId: supplierId, supplierBranchId: supplierBranchId)
//                }
//            func getQuestions(supplier: Supplier, supplierId: String, supplierBranchId: String)  {
//
//                let vc = QuestionsViewController.getVC(.options)
//                vc.categoryId =  passedData.subCategoryId ?? passedData.categoryId
//                vc.completionBlock = { questions in
//                    supplier.associatedQuestions = questions
//                }
//                vc.poppedBlock = {
//                    if (supplier.associatedQuestions?.count ?? 0) > 0 {
//                        SupplierListingViewController.showProducts(supplier: supplier, supplierId: supplierId, supplierBranchId: supplierBranchId)
//                    }
//                }
//                ez.topMostVC?.pushVC(vc)
//            }
            
            if let tempNextVc = tempNextVc as? SupplierListingViewController {
                
                func proceed(questions: [Question]? = nil) {
                    GDataSingleton.sharedInstance.currentSupplier = nil
                    self.isLoadingFirstTime = true
                    tempNextVc.startSkeletonAnimation(tempNextVc.tableView)
                    SupplierListingViewController.getSuppliers(categoryId: passedD.mainCategoryId, subCategoryId: SKAppType.type == .home ? nil : passedD.subCategoryId, order: laundryData) {
                        [weak self] (array) in
                        guard let self = self else { return }
                        array.forEach({ $0.associatedQuestions = questions })
                        if let supplierId = self.passedData.supplierId, !supplierId.isEmpty {
                            tempNextVc.suppliers = array.filter({$0.id == supplierId})
                            if (tempNextVc.suppliers?.count ?? 0) == 1 {
                                tempNextVc.view.alpha = 0.0
                                self.navigationController?.pushViewController(tempNextVc, animated: false)
                                tempNextVc.itemClicked(atIndexPath: IndexPath(row: 0, section: 0))

                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                                    if let ind = self.navigationController?.viewControllers.firstIndex(where: { $0 is SupplierListingViewController }) {
                                        self.navigationController?.viewControllers.remove(at: ind)
                                    }
                                })
                            } else {
                                self.pushVC(tempNextVc)
                            }
                        }
                        else {
                            tempNextVc.suppliers = array
                            self.pushVC(tempNextVc)
                        }
                        
                    }
                }
                
                if SKAppType.type == .home && passedData.isQuestion {
                    var questionsSelected: [Question]?
                    let vc = QuestionsViewController.getVC(.options)
                    vc.categoryId =  passedData.subCategoryId ?? passedData.categoryId
                    vc.completionBlock = { questions in
                        questionsSelected = questions
                    }
                    vc.poppedBlock = { completed in
                        if completed && (questionsSelected?.count ?? 0) > 0 {
                            proceed(questions: questionsSelected)
                        }
                        else {
                            FilterCategory.shared.arraySubCatIds.removeAll()
                            FilterCategory.shared.arraySubCatNames.removeAll()
                            FilterCategory.shared.arrayBrandId.removeAll()
                            if SKAppType.type == .home {
                                // to select questions again
                                GDataSingleton.sharedInstance.currentSupplier = nil
                            }
                        }
                    }
                    ez.topMostVC?.pushVC(vc)
                }
                else {
                    proceed()
                }
                
                return
            }
            pushVC(tempNextVc)
        }
        catch let exception{
            print(exception)
        }
    }
    
    func openCategory(category: ServiceType?) {
        
        if SKAppType.type.isJNJ {
            let VC = RestaurantDetailVC.getVC(.splash)
            // VC.passedData.supplierBranchId = notification.userInfo?["branchId"]?.stringValue
            VC.passedData.supplierId = "5"
            VC.passedData.supplierBranchId = "1"
            VC.passedData.categoryId = category?.id
            VC.passedData.categoryName = category?.name

            self.pushVC(VC)
            return
        }
        if SKAppType.type == .home {
            category?.category_flow = "Category>SubCategory>Suppliers>Pl"
        }
        if let flowComponents = category?.category_flow?.components(separatedBy: ">") {
            print(flowComponents)
            AdjustEvent.CategoryDetail.sendEvent()
            
            if flowComponents.contains(CategoryFlowMap.PickUpTime.rawValue)
                || flowComponents.contains(CategoryFlowMap.PackageProducts.rawValue)
                || flowComponents.contains(CategoryFlowMap.LaundryOrder.rawValue)
                || flowComponents.count == 0 {
                
                guard let _ = GDataSingleton.sharedInstance.loggedInUser?.id else {
                    self.presentVC(StoryboardScene.Register.instantiateLoginViewController())
                    return
                }
                
                self.passedData = PassedData(withCatergoryId: category?.id, categoryFlow: category?.category_flow,supplierId: nil ,subCategoryId: nil ,productId: nil,branchId: nil,subCategoryName: nil , categoryOrder: category?.order,categoryName : category?.name)
                self.pushNextVc()
                
            } else{
                
                ez.runThisInMainThread {
                    [weak self] in
                    guard let self = self else { return }
                    
                    //                    let category = Localize.currentLanguage() == Languages.Arabic ? self?.home?.arrayServiceTypesAR?[indexPath.row] : self?.home?.arrayServiceTypesEN?[indexPath.row]
                    
                    FilterCategory.shared.reset()
                    
                    FilterCategory.shared.arrayCatIds = [/category?.id]
                    FilterCategory.shared.arrayCatNames = [/category?.name]
                    
                    let hasSubCats = (/category?.sub_category?.count > 0) || category?.is_subcategory == 1
                    
                    //To apply filter/enable filter done button, when no sub categories available
                    if !hasSubCats {
                        FilterCategory.shared.arraySubCatIds.append(/category?.id)
                        FilterCategory.shared.arraySubCatNames.append(/category?.name)
                    }
                    
                    FilterCategory.shared.agentListFlow = category?.agent_list
                    var catFlow = category?.category_flow
                    
                    if SKAppType.type != .food {
                        let str = "SupplierInfo>"
                        let newFlow = catFlow?.replacingOccurrences(of: str, with: "")
                        print(newFlow)
                        catFlow = newFlow
                    }
                    //Nitin
                    catFlow = "Category>SubCategory>Ds-Pl"//"Category>Suppliers>SupplierInfo>SubCategory>Pl"
                    self.passedData = PassedData(withCatergoryId: category?.id, categoryFlow: catFlow,supplierId: category?.supplierId ,subCategoryId: category?.id ,productId: nil,branchId: nil,subCategoryName: nil , categoryOrder: category?.order, categoryName : category?.name, hasSubCats: hasSubCats)
                    //self.pushNextVc()
                    
                    
                    //if AppSettings.shared.appThemeData?.show_tags_for_suppliers == "1"{
                    if APIConstants.defaultAgentCode == "lconcierge_0676" /*&& SKAppType.type == .food*/{
                        let catId = AppSettings.shared.selectedCategoryId//GDataSingleton.sharedInstance.selectedCatId
                        SupplierListingViewController.getSuppliers(categoryId: catId, subCategoryId: category?.id, order: self.laundryData) {
                            [weak self] (array) in
                            guard let self = self else { return }
                            let tempNextVc = StoryboardScene.Main.instantiateSupplierListingViewController()
                            tempNextVc.laundryData = self.laundryData
                            tempNextVc.passedData = self.passedData

                            tempNextVc.suppliers = array

                            if array.count == 1 {
                                tempNextVc.view.alpha = 0.0
                                self.navigationController?.pushViewController(tempNextVc, animated: false)
                                tempNextVc.itemClicked(atIndexPath: IndexPath(row: 0, section: 0))

                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                                    if let ind = self.navigationController?.viewControllers.firstIndex(where: { $0 is SupplierListingViewController }) {
                                        self.navigationController?.viewControllers.remove(at: ind)
                                    }

                                })
                            } else {
                                self.pushVC(tempNextVc)
                            }
                        }

                    }else{
//                        let catId = AppSettings.shared.selectedCategoryId
//                        if SKAppType.type == .home {
//                            catFlow = "Category>SubCategory>Suppliers>Pl"
//                        }catId
                        let catVC = StoryboardScene.Main.instantiateSubcategoryViewController()
                        catVC.passedData = PassedData(withCatergoryId: category?.id, categoryFlow: catFlow,supplierId: category?.supplierId ,subCategoryId: category?.id ,productId: nil,branchId: nil,subCategoryName: nil , categoryOrder: category?.order, categoryName : category?.name, hasSubCats: hasSubCats)
                        catVC.supplierId = category?.supplierId
                        self.pushVC(catVC)
                    }
                    
                    
                }
                
            }
        }
    }
    
    @IBOutlet var lblPrescriptionImageName: ThemeLabel!
    @IBOutlet var btnCancel: UIButton! {
        didSet {
            btnCancel.tintColor = SKAppType.type.color
        }
    }
    @IBAction func removePrescription(_ sender: Any) {
        lblPrescriptionImageName.isHidden = true
        btnCancel.isHidden = true
    }
    @IBOutlet var imgUpload: UIImageView! {
        didSet {
            imgUpload.tintColor = SKAppType.type.elementColor
        }
    }
    
    @IBAction func uploadPrescription(_ sender: Any?) {
        guard let _ = GDataSingleton.sharedInstance.loggedInUser?.id else {
            let vc = StoryboardScene.Register.instantiateLoginViewController()
            (vc as? LoginViewController)?.delegate = self
            (vc as? SignupSelectionVC)?.delegate = self
            self.presentVC(vc)
            return
        }
        
        //if let isAdded = self.checkIfAddressAdded(),!isAdded {
        self.openAdressController { [weak self] (address) in
            self?.uploadImagePicker(deliveryId: /address.id)
        }
                   //return
             //  }
        //self.uploadImagePicker()

    }

    func uploadImagePicker(deliveryId: String) {
        guard let supplierID = passedData.supplierBranchId else { return }
        if UtilityFunctions.isCameraPermission() {
            UtilityFunctions.showActionSheet(withTitle: nil, subTitle: L10n.SelectPicture.string, vc: self, senders: [L10n.Camera.string,L10n.PhotoLibrary.string]) { (text, index) in
                
                CameraGalleryPickerBlock.sharedInstance.pickerImage(type: text as! String, presentInVc: self, pickedListner: { [weak self] (image) in
                    guard let `self` = self else { return }
                    self.lblPrescriptionImageName.isHidden = false
                    self.btnCancel.isHidden = false
                    if let sizedImage = image.resize(toWidth:300) {
                        self.uploadPrescription(image: sizedImage, supplierId: supplierID, deliveryId:deliveryId)
                    }
                }) {
                    //Cancelled
                }
            }
        }else {
            UtilityFunctions.alertToEncourageCameraAccessWhenApplicationStarts(viewController: self)
        }
    }
    
    func uploadPrescription(image: UIImage, supplierId: String, deliveryId: String){
        
        APIManager.sharedInstance.opertationWithRequest(withApi: API.uploadPrescription(FormatAPIParameters.uploadPrescription(supplierBranchId: supplierId, deliveryId: deliveryId).formatParameters()), image: image) {
            [weak self] (response) in
            guard let `self` = self else { return }
            switch response {
            case .Success(let object):
                self.removePrescription(self.btnCancel)
                UtilityFunctions.showSweetAlert(title: "Success!", message: "Prescription uploaded successfully", style: .Success)
                //SKToast.makeToast("Prescription uploaded successfully")
//                if let imageUrl = object as? String {
//                    self?.selectedImage?(imageUrl, image)
//                    self?.dismiss(animated: true, completion: nil)
//                }
                
            default:
                break
            }
        }
    }
    typealias LocationCompletion = (SearchedLocation) -> ()
    func openAdressController(completion: @escaping LocationCompletion) {
           
           let vc = NewLocationViewController.getVC(.main)
           vc.transitioningDelegate = self
           vc.modalPresentationStyle = .custom
           vc.foodDeliverycompletionBlock = { [weak self] data in
               guard let strongSelf = self else { return }
               guard let adressData = data as? Dictionary<String,AnyObject> else {return}
               if let wholeArray = adressData["arrayAddress"] as? [Address] {
                   //strongSelf.deliveryData.addresses = wholeArray
               }
            if let add = LocationSingleton.sharedInstance.searchedAddress, let id = add.id {
                print(LocationSingleton.sharedInstance.searchedAddress?.formattedAddress ?? "")
                completion(add)
            }

           }
           
           vc.completionBlock = { [weak self] value in
               guard let strongSelf = self else { return }
            if let add = LocationSingleton.sharedInstance.searchedAddress, let id = add.id {
                print(LocationSingleton.sharedInstance.searchedAddress?.formattedAddress ?? "")
                completion(add)
                       }
           }
           
           self.present(vc, animated: true, completion: nil)
           
       }
    
//    func checkIfAddressAdded() -> Bool?{
//        if let type = UserDefaults.standard.value(forKey: SingletonKeys.deliveryType.rawValue) as? Int,type == 0 {
//            guard let _ = self.selectedAddress?.id else {
//                SKToast.makeToast("Your address is not saved,please save this address and proceed further.".localized())
//                return false
//            }
//            return true
//        }
//
//        return nil
//    }
}


//MARK:- LoginViewControllerDelegate
extension CategoryFlowBaseViewController: LoginViewControllerDelegate {
    
    func userSuccessfullyLoggedIn(withUser user : User?) {
        DispatchQueue.main.async {
            self.uploadPrescription(nil)
        }
    }
    
    func userFailedLoggedIn() {
        
    }
}

//MARK:- UIViewControllerTransitioningDelegate
extension CategoryFlowBaseViewController : UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}
