//
//  ProductVariantVC.swift
//  Sneni
//
//  Created by MAc_mini on 23/02/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit
import SKPhotoBrowser
import EZSwiftExtensions

enum SectionTypes:String {
    
    case size = "Size"
    case color = "Color"
    case deliveryLocation = "Delivery Location"
    case productDescription = "Product Description"
    case ratingHeader = "Rating & Reviews"
    case ratingReview = "Ratings"
    
}

class ProductVariantVC: CategoryFlowBaseViewController {
    
    //MARK:- IBOutlet
    @IBOutlet var lblTItle: ThemeLabel!
    @IBOutlet weak var navigation_view: NavigationView!{
        didSet {
            navigation_view.btnMenu?.isHidden = /*SKAppType.type == .gym ||*/ SKAppType.type == .food || SKAppType.type == .home || SKAppType.type == .carRental || SKAppType.type == .eCom ? true : false
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnArea : UIButton!
    @IBOutlet weak var btnFav: DOFavoriteButton? {
        didSet {
            btnFav?.imageColorOff = UIColor.gray
            btnFav?.imageColorOn = SKAppType.type.color
            btnFav?.circleColor = SKAppType.type.color
            btnFav?.lineColor = SKAppType.type.color
            btnFav?.duration = 2.0 // default: 1.0
            btnFav?.image = UIImage(asset : Asset.Ic_favorite_white_normal)
            if let _ = GDataSingleton.sharedInstance.loggedInUser?.id {
                btnFav?.isHidden = /AppSettings.shared.appThemeData?.is_product_wishlist != "1"
            } else{
                btnFav?.isHidden = true
            }
        }
    }
    
    //MARK:- Variables
    var blockUpdataData : (() -> ())?
    var tableDataSource = ProductDetailDataSource()
//    var variantValueArray = [ProductVariantValue]()
//    var variantFilterArray = [ProductVariantValue]()
    var productVariantValue = [ProductVariantValue]()
//    var arrayUniqID = [Int]()
    var productSectionData : [ProductSectionData]?
    var suplierBranchId : String?
    var isPromotion : Bool = false
    var isPackage : Bool = false
    var modelData:ProductF?
    var isLiked: Bool = false {
        didSet {
            if !isLiked {
                btnFav?.image = UIImage(asset : Asset.Ic_favorite_white_normal)
                btnFav?.deselect()
                
            } else {
                btnFav?.image = UIImage(asset : Asset.Ic_favorite_white_pressed)
                btnFav?.select()
            }
        }
    }
    var is_question: Int = 0
    var product : ProductF? {
        didSet {
            if is_question == 1 {
                product?.is_question = is_question
            }
            configureTableHeaderView()
            product?.supplierBranchId = suplierBranchId
            tableDataSource.product = product
            headerView.product = product
            isLiked =  /product?.isFavourite
            self.addSupplierImage()
            ez.runThisAfterDelay(seconds: 0.001) {
                
                weak var weakSelf  = self
                weakSelf?.tableView?.reloadData()
                weakSelf?.tableView?.sizeHeaderToFit()
            }
        }
    }
    var headerView:ProductInfoHeaderView!
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if SKAppType.type == .home {
            lblTItle.text = "Service Detail".localized()
        }
        else {
            lblTItle.text = "Product Detail".localized()
        }
        
        headerView = ProductInfoHeaderView(frame: CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH, height: (UIScreen.main.bounds.width*3/4)+110))
        headerView.favPressed = { [weak self] in
            guard let `self` = self else { return }
            self.actionFav(sender: self.headerView.btnFav)
        }
        //(UIScreen.main.bounds.width*5/7)+118))
        //configureTableHeaderView()

        //Nitin
        if let name = LocationSingleton.sharedInstance.selectedAddress?.name {
            if let locality = LocationSingleton.sharedInstance.selectedAddress?.locality {
                let strArea = name + " " + locality
                btnArea?.setTitle(strArea, for: .normal)
            }
        } else if let address = LocationSingleton.sharedInstance.searchedAddress?.formattedAddress{
                btnArea?.setTitle(address, for: .normal)
        }
        
//        btnArea.setTitle(LocationSingleton.sharedInstance.location?.getArea()?.name ?? "", for: .normal)

        webServiceProductDetail()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.sizeHeaderToFit()

//        if let headerView = tableView.tableHeaderView {
//
//            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
//            var headerFrame = headerView.frame
//
//            //Comparison necessary to avoid infinite loop
//            if height != headerFrame.size.height {
//                headerFrame.size.height = height
//                headerView.frame = headerFrame
//                tableView.tableHeaderView = headerView
//            }
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadVisibleCells()
        headerView.updatePrice()
    }
 
    override func addFloatingButton(isCategoryFlow: Bool, image: String?, supplierId: String?, supplierBranchId: String?) {
        
        return
        supplierView.imageSupplier.loadImage(thumbnail: image, original: nil)

        supplierView.supplierId = supplierId
        supplierView.floatingViewTapped = {
            [weak self] in
            
            if SKAppType.type.isFood {
//                let VC = StoryboardScene.Main.instantiateSupplierInfoViewController()
//                VC.showButton = false
                let VC = RestaurantDetailVC.getVC(.splash)
                VC.passedData.supplierBranchId =  self?.product?.supplierBranchId
                
                //  VC.passedData.supplierBranchId = supplierBranchId
                VC.passedData.supplierId = self?.product?.supplierid
                VC.passedData.categoryId = self?.product?.categoryId//FilterCategory.shared.catIDString
                
                self?.pushVC(VC)
            } else {
                let VC = StoryboardScene.Main.instantiateSupplierInfoViewControllerNoFood()
                
                VC.passedData.supplierBranchId =  self?.product?.supplierBranchId
                
                //  VC.passedData.supplierBranchId = supplierBranchId
                VC.passedData.supplierId = self?.product?.supplierid
                VC.passedData.categoryId = self?.product?.categoryId//FilterCategory.shared.catIDString
                VC.showButton = false
                self?.pushVC(VC)
            }
        }
        self.view.addSubview(supplierView)
        self.view.bringSubviewToFront(supplierView)
    }
}

//MARK:- ======== UITableViewDataSource,UITableViewDelegate ========
extension ProductVariantVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let productSectionData =  self.productSectionData?[section]
        let headerView = UIView()
        
//        switch status {
//        case .ratingReview?:
//
//            if  let headerCell = tableView.dequeueReusableCell(withIdentifier: RatingHeaderCell.identifier) as? RatingHeaderCell{
//                headerCell.product = product
//                headerView.addSubview(headerCell)
//            }
//        default:
//
//            return headerView
//
//        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let productSectionData =  self.productSectionData?[section]
        let status = productSectionData?.type
        
        switch status {
        case .ratingReview?:
            return 0//100
        default: return 0
            
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return productSectionData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        let productSectionData =  self.productSectionData?[indexPath.section]
        return CGFloat(productSectionData?.rowHeight ?? 0)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let productSectionData =  self.productSectionData?[section]
        return productSectionData?.numOfRow ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let productSectionData =  self.productSectionData?[indexPath.section]
        let status = productSectionData?.type
        
        switch status {
        case .size?,.color?:
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.VairantTableViewCell, for: indexPath) as? VairantTableViewCell{
                
                let productVariantModel =  product?.variants?[indexPath.section]
                cell.level = indexPath.section
                cell.productVariantModel = productVariantModel
                cell.selectionStyle = .none
                return cell
            }
            
        case .deliveryLocation?:
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.DeliveryLocationTblCell, for: indexPath) as? DeliveryLocationTblCell{
                cell.stackAddProduct.isHidden = /(modelData?.variants?.count) != 0 || (productVariantValue.count-1) != ((product?.variants!.count)!-1)
                self.product?.selectedVariants = productVariantValue
                cell.product = self.product
                cell.selectionStyle = .none
                cell.setLocation()
                cell.blockBuyNow = {
                    [weak self] (product) in
                    guard let self = self else { return }
                    
                    if !GDataSingleton.sharedInstance.isLoggedIn {
                        let loginVc = StoryboardScene.Register.instantiateLoginViewController()
                        self.presentVC(loginVc)
                        return
                    }
                    guard let objPro = product else { return }
                    self.loadProduct(product: objPro)
                }
                
                cell.blockAddRemoveWishList = {
                    [weak self] (product) in
                    guard let self = self else { return }
                    
                    if !GDataSingleton.sharedInstance.isLoggedIn {
                        self.tableView.reloadData()

                        let loginVc = StoryboardScene.Register.instantiateLoginViewController()
                        self.presentVC(loginVc)
                        return
                    }
                    
                    self.makeProductFav(product: product)
                }
                
                cell.blockUpdateStepper = {
                    [weak self] (_) in
                    guard let self = self else { return }
                    
                    self.headerView.updatePrice()
                    
                }
                return cell
            }
        case .productDescription?:
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.SupplierDescriptionCell, for: indexPath) as? SupplierDescriptionCell {
                cell.htmlString = product?.desc
                cell.selectionStyle = .none
                return cell
            }
            
        case .ratingHeader?:
            if  let cell = tableView.dequeueReusableCell(withIdentifier: RatingHeaderCell.identifier) as? RatingHeaderCell{
                cell.product = product
                return cell
            }
            
        case .ratingReview?:
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.RatingReviewTblCell, for: indexPath) as? RatingReviewTblCell {
                cell.ratingModel = product?.ratingModel[indexPath.row]
                cell.selectionStyle = .none
                return cell
            }
            
        default:
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.VairantTableViewCell, for: indexPath) as? VairantTableViewCell{
                
                let productVariantModel =  product?.variants?[indexPath.section]
                cell.productVariantModel = productVariantModel
                cell.level = indexPath.section
                cell.selectionStyle = .none
                return cell
                
            }
        }
        
        return UITableViewCell()
        
    }
    
}

//MARK: - WebService Methods
extension ProductVariantVC {
    
    func webServiceProductDetail (){
        
        let objR = API.ProductDetail(FormatAPIParameters.ProductDetail(productId: passedData.productId,supplierBranchId: suplierBranchId,offer: isPromotion ? "3" : (isPackage ? "2" : nil)).formatParameters())
        APIManager.sharedInstance.opertationWithRequest(withApi: objR) {
            [weak self] (response) in
            guard let self = self else { return }
            switch response {
                
            case .Success(let listing):
                
                self.tableView.isHidden = false
                self.modelData = listing as? ProductF
                
                if self.modelData?.priceType == .Fixed && (/self.modelData?.fixedPrice == "0" || (self.modelData?.fixedPrice) == nil){
                    
                    self.modelData = self.product
                    UtilityFunctions.showAlert(message: L10n.Novarientfoundregardingthisporoduct.string)
                    
                    //Nitin
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                else{
                    
                    if /(self.productSectionData?.count) == 0 {
                        
                        self.product = self.modelData
                        self.productSectionData = ProductSectionData.getItems(backendObj: listing)
                    }
                    else
                    {
                        self.product?.images = self.modelData?.images
                        self.product?.id = self.modelData?.id
                        self.headerView.product = self.modelData
                        self.product?.handlingSupplier = self.modelData?.handlingSupplier
                        //handlingAdmin is same for all variants. No need to update
                        //self.product?.handlingAdmin = self.modelData?.handlingAdmin
                        self.product?.deliveryCharges = self.modelData?.deliveryCharges
                        self.product?.averageRating = self.modelData?.averageRating
                        self.product?.purchased_quantity = self.modelData?.purchased_quantity
                        self.product?.totalQuantity = self.modelData?.totalQuantity
                        self.product?.price = self.modelData?.price
                        self.product?.fixedPrice = self.modelData?.fixedPrice
                        self.product?.hourlyPrice = self.modelData?.hourlyPrice ?? []

                        if self.modelData?.ratingModel.count != 0  {
                            
                            let productSectionData  = self.productSectionData?.last
                            productSectionData?.numOfRow = self.modelData?.ratingModel.count ?? 0
                            self.product?.ratingModel = self.modelData?.ratingModel
                            
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
                
            default :
                break
            }
        }
    }
    
}

//MARK: - Add Supplier Image
extension ProductVariantVC {
    func addSupplierImage() {
        
        APIManager.sharedInstance.opertationWithRequest(withApi: API.SupplierImage(FormatAPIParameters.SupplierImage(supplierBranchId: product?.supplierBranchId).formatParameters())) {[weak self] (response) in
            switch response{
            case .Success(let object):
                guard let image = object as? String else { return }
                self?.addFloatingButton(isCategoryFlow: false, image: image.components(separatedBy :" ").first,supplierId:image.components(separatedBy: " ").last,supplierBranchId: self?.product?.supplierBranchId)
            default :
                break
            }
        }
    }
}

//MARK: - Configure TableView
extension ProductVariantVC {
    
    func configureTableHeaderView() {
        if tableView.tableHeaderView == nil {
            headerView.imageDelegate = self
            tableView.tableHeaderView = headerView
            tableView.sizeHeaderToFit()
        }
       
        
    }
}

//MARK: - Image Click Delegate
extension ProductVariantVC : ImageClickListenerDelegate {
    
    func imageCliked(atIndexPath indexPath: IndexPath, cell: UICollectionViewCell?, images: [SKPhoto]) {
        
        guard let currentCell = cell as? SupplierInfoHeaderCollectionCell , let originImage = currentCell.imageViewCover.image, images.count > 0 else{
            return
        }
        let browser = SKPhotoBrowser(originImage: originImage, photos: images, animatedFromView: currentCell)
        browser.initializePageIndex(indexPath.row)
        presentVC(browser)
        
    }
    
}

extension ProductVariantVC {
    
    func reloadVisibleCells(){
        tableView.reloadData()
    }
}


//MARK: - Button Actions
extension ProductVariantVC {
    
    @IBAction func actionFav(sender: DOFavoriteButton) {

        if !GDataSingleton.sharedInstance.isLoggedIn {
            self.tableView.reloadData()
            self.isLiked = /self.product?.isFavourite
            let loginVc = StoryboardScene.Register.instantiateLoginViewController()
            self.presentVC(loginVc)
            return
        }
        
        //btnFav?.isSelected.toggle()
        if sender.isSelected {
            btnFav?.image = UIImage(asset : Asset.Ic_favorite_white_normal)
            sender.deselect()

        } else {
            btnFav?.image = UIImage(asset : Asset.Ic_favorite_white_pressed)
            sender.select()
        }
        
        self.makeProductFav(product: product)
    }

    @IBAction func actionSideMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    @IBAction func actionBack(sender: AnyObject) {
        popVC()
    }
    
    @IBAction func actionCart(sender: AnyObject) {
        pushVC(StoryboardScene.Options.instantiateCartViewController())
    }
    
    @IBAction func actionArea(sender : UIButton) {
        
        let vc = ChooseLocationVC.getVC(.register)
        vc.delegate = self
        presentVC(vc)
    }
    
}


//MARK: - Button Actions
extension ProductVariantVC:RateReviewsVCDelegate {
    func updateProductDetail() {
        self.webServiceProductDetail()
    }
    
}

//MARK: -//MARK: - Splash Delegate
extension ProductVariantVC : SplashViewControllerDelegate {
    func locationSelected() {
        btnArea.setTitle(LocationSingleton.sharedInstance.location?.getArea()?.name ?? "", for: .normal)
        self.tableView.reloadData()
    }
}

extension ProductVariantVC {
    
    func makeProductFav(product: Cart?) {
        
        guard let product = product else {
            self.tableView.reloadData()
            self.isLiked = /self.product?.isFavourite
            return
        }

        let objR = API.makeProductFav(id: /product.id, isFav: !product.isFavourite)
        
        APIManager.sharedInstance.opertationWithRequest(isLoader: true, withApi: objR) {
            [weak self] (response) in
            guard let self = self else { return }
            
            switch response {
            case .Success(_):
                product.isFav = (!product.isFavourite).toInt
                
                if product.isFavourite {
                    SKToast.makeToast("\((TerminologyKeys.product.localizedValue() as? String) ?? "Product") added to \((TerminologyKeys.wishlist.localizedValue() as? String) ?? "Wishlist")")
                }else {
                    SKToast.makeToast("\((TerminologyKeys.product.localizedValue() as? String) ?? "Product") removed from \((TerminologyKeys.wishlist.localizedValue() as? String) ?? "Wishlist")")
                }
                
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "FavouritePressed"),object: product))
                self.tableView.reloadData()
                self.isLiked = /self.product?.isFavourite
                self.blockUpdataData?()
                
            case .Failure(let error):
                print(error.message ?? "")
                break
            }
        }
    }
    
    func loadProduct(product: ProductF) {
        
        DBManager.sharedManager.getCart(result: {
            [weak self] (array) in
            guard let self = self, let arrayD = array as? [Cart] else { return }
            
            var oldQty = 0
            if let objPro = arrayD.first(where: { $0.id == product.id }) as? Cart {
                oldQty = /objPro.quantity?.toInt()
            }
            
            var objP = product
            objP.quantity = String(1)
            DBManager.sharedManager.manageCart(product: objP, quantity: 1)
            
            DBManager.sharedManager.getCart(result: {
                [weak self] (array) in
                guard let self = self, let arrayD = array as? [Cart], let objPro = arrayD.first(where: { $0.id == objP.id }) else { return }
                
                var objP2 = product
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: CartNotification), object: self, userInfo: ["badge" : oldQty])
                objP2.quantity = String(oldQty)
                DBManager.sharedManager.manageCart(product: objP2, quantity: oldQty)
                
                self.webServiceAddToCart(product: objPro)
            })
        })
        
        
//        var objP = product
//        //                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: CartNotification), object: self, userInfo: ["badge" : quantity])
//        objP.quantity = String(1)
//        DBManager.sharedManager.manageCart(product: objP, quantity: 1)
//
//        DBManager.sharedManager.getCart(result: {
//            [weak self] (array) in
//            guard let self = self, let arrayD = array as? [Cart], let objPro = arrayD.first(where: { $0.id == objP.id }) as? Cart else { return }
//            self.webServiceAddToCart(product: objPro)
//        })
    }
    
    func webServiceAddToCart(product: Cart) {
        
        let params = FormatAPIParameters.AddToCart(cart: [product], supplierBranchId: product.supplierBranchId,promotionType: nil, remarks: "").formatParameters()
        
        APIManager.sharedInstance.opertationWithRequest(withApi: API.AddToCart(params)) {
            [weak self] (response) in
            guard let self = self else { return }
            
            switch response {
            case .Success(let object):
                
                self.handleWebService(product: product, tempCartId: object)
            case .Failure(let error):
                print(error.message ?? "")
                break
            }
        }
    }
    
    func handleWebService(product: Cart, tempCartId : Any?){
        
        let arrayCart = [product]
//        let isAgent = product.agentList == "1"
//        let isNotAgent = product.agentList == "0"
        
        if product.agentList == "1" {
            
//            var tinterval: Double = 0.0
//            arrayCart.forEach({
//                (objC) in
//                tinterval += /objC.totalDuration
//            })
//            
//            guard let cartId = (tempCartId as? String)?.components(separatedBy: "$").first else { return }
//            let VC =  AgentListingVC.getVC(.order)
//            VC.selectedDate = GDataSingleton.sharedInstance.pickupDate ?? Date()
//            VC.timeInterVal = tinterval
//            
//            VC.orderSummary = OrderSummary(items: arrayCart, promo: nil)
//            VC.orderSummary?.isBuyOnly = true
//            VC.orderSummary?.cartId = cartId
//            VC.orderSummary?.isAgent = true
//            VC.orderSummary?.minOrderAmount = (tempCartId as? String)?.components(separatedBy: "$").last
//            VC.remarks = ""
//            VC.arrayCart = arrayCart
//            self.pushVC(VC)
        }
        else
        {
            guard let cartId = (tempCartId as? String)?.components(separatedBy: "$").first else { return }
            let VC = StoryboardScene.Order.instantiateDeliveryViewController()
            VC.orderSummary = OrderSummary(items: arrayCart, promo:nil)
            VC.orderSummary?.isBuyOnly = true
            VC.orderSummary?.cartId = cartId
            VC.orderSummary?.isAgent = false
            VC.orderSummary?.minOrderAmount = (tempCartId as? String)?.components(separatedBy: "$").last
            VC.remarks = ""
            self.pushVC(VC)
        }
        
        
    }
}
