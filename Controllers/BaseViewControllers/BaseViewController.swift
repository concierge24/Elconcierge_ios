//
//  BaseViewController.swift
//  Clikat
//
//  Created by Night Reaper on 27/04/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import Material

class BaseVC: UIViewController {
    var hideBackButton: Bool = false
    var isLoadingFirstTime : Bool = true
    
    @IBOutlet weak var btnBack: ThemeButton! {
        didSet {
            btnBack.imageView?.mirrorTransform()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Class : " + String(describing: type(of: self)))
    }
    //MARK:- Start Skeleton animation
    func startSkeletonAnimation(_ scrollView: UIScrollView?) {
        if isLoadingFirstTime {
            if let collectionView = scrollView as? UICollectionView {
                collectionView.prepareSkeleton { (_) in
                    collectionView.showAnimatedGradientSkeleton()
                    collectionView.collectionViewLayout.invalidateLayout()
                    collectionView.reloadData()
                    if let cell = collectionView.visibleCells.first {
                        cell.setNeedsLayout()
                        cell.layoutIfNeeded()
                    }
                }
                isLoadingFirstTime = false
            } else {
                scrollView?.showAnimatedGradientSkeleton()
                isLoadingFirstTime = false
            }
        }
    }
    
    //MARK:- Stop Skeletong Animation
    func stopSkeletonAnimation(_ scrollView: UIScrollView?) {
        scrollView?.stopSkeletonAnimation()
        scrollView?.hideSkeleton()
    }

}

class LoginRegisterBaseViewController : BaseVC {
    
    @IBOutlet weak var imgLogo: UIImageView?
    @IBOutlet weak var imgBG: UIImageView?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let urlStr = AppSettings.shared.appThemeData?.login_icon_url, urlStr != "" {
            imgBG?.loadImage(thumbnail: urlStr, original: urlStr, placeHolder: nil)
        }else {
            imgBG?.image = UIImage(named: "AppLoginBG_JNJ")
        }
        
        
        if let urlStr = AppSettings.shared.appThemeData?.logo_url, urlStr != "" {
            imgLogo?.loadImage(thumbnail: urlStr, original: urlStr, placeHolder: nil, modeType: .scaleAspectFit)
        }else {
            imgLogo?.image = nil
        }
        
        if /AppSettings.shared.appThemeData?.user_register_flow == "1" {
            imgBG?.isHidden = true
            imgLogo?.isHidden = false
        }
        
        if APIConstants.defaultAgentCode == "poneeex_0049" {
            imgBG?.isHidden = true
            imgLogo?.isHidden = false
        }
        
    }
    
    //MARK: - UITextfield Delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        let tag = textField.tag + 1
        let nextTextfield : UITextField? = self.view.viewWithTag(tag) as? UITextField
        nextTextfield != nil ? nextTextfield?.becomeFirstResponder() : textField.resignFirstResponder()
        
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.dividerColor = TextFieldTheme.shared.txtFld_DividerColor
    
    }
}

class BaseViewController: BaseVC {
    
    let supplierView = FloatingSupplierView(frame: CGRect(x: L102Language.isRTL ? 16 : ScreenSize.SCREEN_WIDTH - 80, y: ScreenSize.SCREEN_HEIGHT - 96, w: 64, h: 64))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  print(supplierView)
        
        switch self{
        case is SubcategoryViewController,is ItemListingViewController,is PackageProductListingViewController,is ProductDetailViewController,is SearchViewController:
            addSupplierImage(isCategoryFlow: true)
//        case is CartViewController,is DeliveryViewController, is PaymentMethodController:
//            addSupplierImage(isCategoryFlow: false)
        case is ProductVariantVC:
            addSupplierImage(isCategoryFlow: false)
        default:
            break
        }
    }

    func addSupplierImage(isCategoryFlow : Bool){
        if !isCategoryFlow {
            
            APIManager.sharedInstance.opertationWithRequest(withApi: API.SupplierImage(FormatAPIParameters.SupplierImage(supplierBranchId: GDataSingleton.sharedInstance.currentSupplierId).formatParameters())) {[weak self] (response) in
                switch response {
                case .Success(let object):
                    guard let image = object as? String else { return }
                    self?.addFloatingButton(isCategoryFlow: isCategoryFlow,image: image.components(separatedBy: " ").first,supplierId:image.components(separatedBy:" ").last,supplierBranchId: GDataSingleton.sharedInstance.currentSupplierId )
                default :
                    break
                }
            }
        }else {
            guard let supplier = GDataSingleton.sharedInstance.currentSupplier,let image = supplier.logo,let id = supplier.id else {
                supplierView.removeFromSuperview()
                return
            }
            addFloatingButton(isCategoryFlow: isCategoryFlow,image: image,supplierId: id,supplierBranchId: supplier.supplierBranchId)
        }
    }
    
    func addFloatingButton(isCategoryFlow : Bool,image : String?,supplierId : String?,supplierBranchId : String?){
        if self is OrderDetailController {
            return
        }
        supplierView.imageSupplier.loadImage(thumbnail: image, original: nil)
        //supplierView.supplierBranchId = supplierBranchId
        supplierView.supplierId = supplierId
        supplierView.floatingViewTapped = { [weak self] in
            
            if SKAppType.type.isFood {
//                let VC = StoryboardScene.Main.instantiateSupplierInfoViewController()
//                VC.showButton = false
                let VC = RestaurantDetailVC.getVC(.splash)
                VC.passedData.supplierBranchId = supplierBranchId
                VC.passedData.supplierId = supplierId
                if isCategoryFlow {
                    VC.passedData.categoryId = GDataSingleton.sharedInstance.currentSupplier?.categoryId
                }else {
                    VC.passedData.categoryId = GDataSingleton.sharedInstance.currentCategoryId
                }
                self?.pushVC(VC)
            } else {
                let VC = StoryboardScene.Main.instantiateSupplierInfoViewControllerNoFood()
                VC.passedData.supplierBranchId = supplierBranchId
                VC.passedData.supplierId = supplierId
                if isCategoryFlow {
                    VC.passedData.categoryId = GDataSingleton.sharedInstance.currentSupplier?.categoryId
                }else {
                    VC.passedData.categoryId = GDataSingleton.sharedInstance.currentCategoryId
                }
                VC.showButton = false
                self?.pushVC(VC)
            }
            
        }
//        self.view.addSubview(supplierView)
//        self.view.bringSubviewToFront(supplierView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.handleUrlScheme(notification:)), name: NSNotification.Name(rawValue: UrlSchemeNotification), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: UrlSchemeNotification), object: nil)
    }
    
    func openProduct(objProduct: ProductF?) {
        
        guard let objProduct = objProduct else { return }
        let productDetailVc = StoryboardScene.Main.instantiateProductVariantVC()
        productDetailVc.passedData.productId = objProduct.id
        productDetailVc.is_question = objProduct.is_question
        productDetailVc.suplierBranchId = objProduct.supplierBranchId
        self.pushVC(productDetailVc)
    }
    
}

//MARK: - Handle User Scheme
extension BaseViewController{

    @objc func handleUrlScheme(notification : NSNotification) {
        
        AdjustEvent.DeepLink.sendEvent()
        
        if SKAppType.type.isFood {
            
//            let VC = StoryboardScene.Main.instantiateSupplierInfoViewController()
//            VC.showButton = false
            let VC = RestaurantDetailVC.getVC(.splash)
            // VC.passedData.supplierBranchId = notification.userInfo?["branchId"]?.stringValue
            VC.passedData.supplierId = notification.userInfo?["supplierId"] as? String
            VC.passedData.supplierBranchId = notification.userInfo?["branchId"] as? String
            VC.passedData.categoryId = notification.userInfo?["categoryId"] as? String
            
            self.pushVC(VC)
        } else {
            let VC = StoryboardScene.Main.instantiateSupplierInfoViewControllerNoFood()
            // VC.passedData.supplierBranchId = notification.userInfo?["branchId"]?.stringValue
            VC.passedData.supplierId = notification.userInfo?["supplierId"] as? String
            VC.passedData.supplierBranchId = notification.userInfo?["branchId"] as? String
            VC.passedData.categoryId = notification.userInfo?["categoryId"] as? String
            VC.showButton = false
            self.pushVC(VC)
        }
        
        
    }
}


