//
//  SupplierInfoViewControllerNoFood.swift
//  Clikat
//
//  Created by cblmacmini on 4/20/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import SKPhotoBrowser

class SupplierInfoViewControllerNoFood: CategoryFlowBaseViewController {

    //MARK:- IBOutlet
    @IBOutlet weak var constraintLabel: NSLayoutConstraint!
    @IBOutlet weak var constraintBtnMakeOrder: NSLayoutConstraint!
    @IBOutlet weak var labelTitle: UILabel!{
        didSet{
            labelTitle.layer.shadowRadius = 2
            labelTitle.layer.shadowOffset = CGSize(width: 0, height: 3)
            labelTitle.layer.shadowOpacity = 0.2
        }
    }
    @IBOutlet weak var imageViewFade: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnFav: UIButton!
    
    @IBOutlet var btnMakeOrder: UIButton?{
        didSet{
            btnMakeOrder?.setBackgroundColor(SKAppType.type.color, forState: .normal)
            btnMakeOrder?.kern(kerningValue: ButtonKernValue)
        }
    }
    @IBOutlet weak var pageControl: UIPageControl?{
        didSet{
            pageControl?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
    }
    
    //MARK:- Variables
    let headerHeight = ScreenSize.SCREEN_WIDTH * 0.7
    var transitionDriver: TransitionDriver?
    var startingPosition : CGFloat = 0.0
    var currentPosition : CGFloat = 0.0
    var maxYOffset : Int = 150
    var startingTouchLocation : CGPoint?
    var imageOfBackgroundLayer : UIImage?
    //PromotionsFlow
    var promotion : Promotion?
    let headerView = SupplierInfoHeaderView(frame: CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH, height: ScreenSize.SCREEN_WIDTH * 0.7))
    var rateSupplierView = SupplierRatingPopUp(frame: CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH, height: ScreenSize.SCREEN_HEIGHT))
    var supplier : Supplier?{
        didSet{
            labelTitle?.text = supplier?.name
           
            if let tempPromotion = promotion {
                supplier?.supplierImages = [tempPromotion.promotionImage ?? ""]
            }
            if passedData.categoryOrder == "2" {
                supplier?.status = .Online
            }
            configureTableHeaderView()
            setupUI()
            
        }
    }
    var tableDataSource: SupplierInfoDataSource? {
        didSet{
            tableView.reloadData()
        }
    }
    var showButton = true
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        webServiceSupplierInfo(selectedTab: .About)
        setupUI()
    }
    
    func setupUI(){
        if !showButton {
            constraintBtnMakeOrder.constant = 0
            self.view.layoutIfNeeded()
        }
        guard let _ = GDataSingleton.sharedInstance.loggedInUser?.id else{
            btnFav?.isHidden = true
            return
        }
        btnFav?.isHidden = /AppSettings.shared.appThemeData?.is_supplier_wishlist != "1"
        guard let favorite = supplier?.Favourite, favorite == "1" else{
            btnFav?.isSelected = false
            return
        }
        btnFav?.isSelected = true
    }

    
}


//MARK: - WebService Methods
extension SupplierInfoViewControllerNoFood {
    
    func webServiceSupplierInfo(selectedTab : SelectedTab){
        
        let objR = API.SupplierInfo(FormatAPIParameters.SupplierInfo(
            supplierId: passedData.supplierId,
            branchId: passedData.supplierBranchId,
            accessToken: GDataSingleton.sharedInstance.loggedInUser?.token,
            categoryId : passedData.categoryId).formatParameters())
        
        APIManager.sharedInstance.opertationWithRequest(withApi: objR) {
            [weak self] (response) in
            guard let self = self else { return }
            
            switch response{
                
            case .Success(let listing):
                self.supplier = listing as? Supplier
                self.configureTableView()
//                self.tableDataSource.selectedTab = .About
                
            default :
                break
            }
        }
    }
    
    func webServiceRateSupplier(rating : String?,comment : String?){
        
        let objR = API.SupplierRating(FormatAPIParameters.SupplierRating(supplierId: passedData.supplierId, rating: rating , comment: comment).formatParameters())
        APIManager.sharedInstance.opertationWithRequest(withApi: objR) {
            [weak self] (response) in
            guard let self = self else { return }
            
            switch response {
            case .Success(_):
                self.handleWebServiceRateSupplier(rating: rating)
            case .Failure(_):
                break
            }
        }
    }
    
}

extension SupplierInfoViewControllerNoFood {
    
    func configureTableView(){
        if tableDataSource == nil {
            tableDataSource = SupplierInfoDataSource(supplier: supplier, height: UITableView.automaticDimension, tableView: tableView, cellIdentifier:CellIdentifiers.SupplierInfoCell , configureCellBlock: { (cell, indexPath,selectedTab) in
                guard let c = cell as? UITableViewCell,let s = selectedTab else { return }
                self.configureTableViewCell(cell: c,indexPath: indexPath,selectedTab: s)
            }, aRowSelectedListener: { (indexPath) in
                
            }, scrollViewListener: { (scrollView) in
                self.updateHeaderView(headerView: self.headerView)
            })
        }
        
        tableView.delegate = tableDataSource
        tableView.dataSource = tableDataSource
    }
    
    func configureTableHeaderView(){
        
        headerView.supplier = supplier
        tableView.addSubview(headerView)
        headerView.imageDelegate = self
        tableView.contentInset = UIEdgeInsets(top: headerHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -headerHeight)
        pageControl?.numberOfPages = supplier?.supplierImages?.count ?? 0
        pageControl?.isHidden = /pageControl?.numberOfPages > 5 ? true : false
        headerView.collectionDataSource.scrollViewListener = { (scrollView) in
            weak var weakSelf = self
            weakSelf?.configurePageControl(scrollView: scrollView)
        }
        updateHeaderView(headerView: headerView)

    }
    func configurePageControl(scrollView : UIScrollView){
        
        let visibleRect = CGRect(origin: headerView.collectionView.contentOffset, size: headerView.collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath = headerView.collectionView.indexPathForItem(at: visiblePoint)
        pageControl?.currentPage = visibleIndexPath?.row ?? 0
    }
    
    func updateHeaderView(headerView : SupplierInfoHeaderView){
        
        var headerRect = CGRect(x: 0, y: -headerHeight, width: ScreenSize.SCREEN_WIDTH, height: headerHeight )
        if (tableView.contentOffset.y < -headerHeight) {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y <= 44 ? headerRect.size.height : -tableView.contentOffset.y
        }else {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y <= 94 ? 94 : -tableView.contentOffset.y
        }
        headerView.frame = headerRect
        
        headerView.collectionView.collectionViewLayout.invalidateLayout()
        
        configureBlurImageHeader()
    }
    
    func configureTableViewCell(cell : UITableViewCell,indexPath : IndexPath,selectedTab : SelectedTab){
        
        if let currentCell = cell as? SupplierInfoCell {
            currentCell.passedData = passedData
            currentCell.supplier = supplier
        }else if let currentCell = cell as? SupplierInfoTabCell {
            currentCell.delegate = tableDataSource
            currentCell.supplier = self.supplier
            if selectedTab == .Uniqueness {
              
                currentCell.adjustViewHighlight(tab: selectedTab)
                
                  currentCell.heightLayout.constant = 3
            }
            if selectedTab == .Review{
                currentCell.heightLayout.constant = 40
                currentCell.btnRate.isHidden = false
              
                //currentCell.
            }
            else{
                  currentCell.btnRate.isHidden = true
                   currentCell.heightLayout.constant = 0
            }
        }else if let currentCell = cell as? SupplierDescriptionCell {
            if selectedTab == .Review {
                
                currentCell.htmlString = ""
                return
            }
            
            currentCell.htmlString = selectedTab == .About ? supplier?.descriptionHTML : supplier?.about
        }else if let currentCell = cell as? MyReviewCell {
            currentCell.myReview = supplier?.myReview
            let tap = UITapGestureRecognizer(target: self, action: #selector(SupplierInfoViewControllerNoFood.handleReviewCellTap))
            guard let _ = supplier?.myReview?.rating else {
                currentCell.viewRating.isUserInteractionEnabled = true
                currentCell.viewRating.addGestureRecognizer(tap)
                return
            }
            currentCell.viewRating.isUserInteractionEnabled = false
            
        }else if let currentCell = cell as? OtherReviewCell {
            currentCell.currentReview = supplier?.reviews?[indexPath.row - 2]
        }
    }
    
    @objc func handleReviewCellTap(){
        
        guard let _ = GDataSingleton.sharedInstance.loggedInUser?.id else {
            presentVC(StoryboardScene.Register.instantiateLoginViewController())
            return
        }
        self.view.addSubview(rateSupplierView)
        rateSupplierView.presentingViewController = self
        rateSupplierView.supplier = supplier
        rateSupplierView.presentRatingView { (rating, comment) in
            weak var weakSelf = self
            weakSelf?.webServiceRateSupplier(rating: String(rating ?? 0), comment: comment)
            weakSelf?.rateSupplierView.dismissRatingView()
        }
    }
    
    func handleWebServiceRateSupplier(rating : String?){
        
        self.webServiceSupplierInfo(selectedTab: .Review)
    }
}


//MARK: - Image Click Delegate
extension SupplierInfoViewControllerNoFood : ImageClickListenerDelegate {
    
    func imageCliked(atIndexPath indexPath : IndexPath, cell: UICollectionViewCell? , images : [SKPhoto]) {
        
        guard let currentCell = cell as? SupplierInfoHeaderCollectionCell , let originImage = currentCell.imageViewCover.image, images.count > 0 else{
            return
        }
        let browser = SKPhotoBrowser(originImage: originImage, photos: images, animatedFromView: currentCell)
        browser.initializePageIndex(indexPath.row)
        presentVC(browser)
    }
}


//MARK: - Button Actions

extension SupplierInfoViewControllerNoFood{
    
    @IBAction func actionFav(_ sender: UIButton) {

        if sender.isSelected {
            
            
            APIManager.sharedInstance.opertationWithRequest(withApi: API.UnFavoriteSupplier(FormatAPIParameters.UnFavoriteSupplier(supplierId: passedData.supplierId).formatParameters()), completion: { (response) in
                
                self.supplier?.Favourite = "0"
                self.btnFav?.isSelected = false
                SKToast.makeToast("\((TerminologyKeys.supplier.localizedValue() as? String) ?? "Supplier") removed from \((TerminologyKeys.wishlist.localizedValue() as? String) ?? "Wishlist")")

                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "FavouritePressed"),object: self.supplier))
                
            })
            //Mark Unfavorite
            
        } else {
            

        
            APIManager.sharedInstance.opertationWithRequest(withApi: API.MarkSupplierFav(FormatAPIParameters.MarkSupplierFavorite(supplierId: passedData.supplierId).formatParameters()), completion: { (response) in
                
                self.supplier?.Favourite = "1"
                self.btnFav?.isSelected = true
                SKToast.makeToast("\((TerminologyKeys.supplier.localizedValue() as? String) ?? "Supplier") added to \((TerminologyKeys.wishlist.localizedValue() as? String) ?? "Wishlist")")
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "FavouritePressed"),object: self.supplier))

            })
        }
    }
    
    @IBAction func actionBack(sender: AnyObject) {
        popVC()
    }
    
    @IBAction func actionMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    @IBAction func actionShare(sender: AnyObject) {
        let iosLink = "clikat://www.clikat.com/supplier?supplierId=\(supplier?.id ?? "0")&branchId=\(/passedData.supplierBranchId)&categoryId=\(/passedData.categoryId) (iOS)"
        
        UtilityFunctions.shareContentOnSocialMedia(withViewController: self, message: UtilityFunctions.appendOptionalStrings(withArray: [L10n.IWouldLikeToRecommendUsing.string,supplier?.name,L10n.ViaClikat.string,iosLink],separatorString: " "))
    }
    
    @IBAction func actionMakeOrder(sender: AnyObject) {
        if supplier?.status == .Busy || supplier?.status == .Closed {
            UtilityFunctions.showSweetAlert(title : UtilityFunctions.appendOptionalStrings(withArray: [supplier?.name, L10n.NotAvailable.string]), message: L10n.YourOrderWillBeConfirmedDuringNextSupplierWorkingHoursDay.string, success: { [weak self] in
                self?.makeOrder()
                }, cancel: {  
                
            })
        }else { makeOrder() }
    }
    
    
    func makeOrder(){
        if let currentPromotion = promotion {
            let product = addPromotionToCart(currentPromotion: currentPromotion)
            
            UtilityFunctions.showSweetAlert(title : L10n.AreYouSure.string, message: L10n.AddingProductsFromPromotionsWillClearYourCart.string, success: { [weak self] in
                DBManager.sharedManager.cleanCart()
                
                GDataSingleton.sharedInstance.currentSupplierId = product.supplierBranchId
                let VC = StoryboardScene.Options.instantiateCartViewController()
                DBManager.sharedManager.manageCart(product: ProductF(cart:product), quantity: -1)
                GDataSingleton.sharedInstance.currentSupplierId = "-1"
                self?.pushVC(VC)
                }, cancel: {
                    
            })
            
        }else {
            
            let catVC = StoryboardScene.Main.instantiateSubcategoryViewController()
            catVC.passedData = PassedData(withCatergoryId: passedData.categoryId, categoryFlow: "Category>SubCategory>Ds-Pl",supplierId: supplier?.id ,subCategoryId: passedData.categoryId ,productId: nil,branchId: nil,subCategoryName: nil , categoryOrder: passedData.categoryOrder, categoryName : passedData.categoryName, hasSubCats: passedData.hasSubCats)
               catVC.supplierId = supplier?.id
               self.pushVC(catVC)
            
            //Nitin
           // pushNextVc()
        }
    }
    
    func addPromotionToCart(currentPromotion : Promotion) -> Cart{
        let cartProduct = Cart()
        cartProduct.id = currentPromotion.id
        cartProduct.name = currentPromotion.promotionName
        cartProduct.quantity = "-1"
        cartProduct.image = promotion?.promotionImage
        cartProduct.priceType = .Fixed
        cartProduct.fixedPrice = currentPromotion.promotionPrice
        cartProduct.displayPrice = currentPromotion.promotionPrice
        cartProduct.deliveryCharges = currentPromotion.deliveryCharges
        cartProduct.supplierBranchId = currentPromotion.supplierBranchId
        cartProduct.handlingAdmin = currentPromotion.handlingAdmin
        cartProduct.handlingSupplier = currentPromotion.handlingSupplier
        
        return cartProduct
    }
}


extension SupplierInfoViewControllerNoFood {
    
    func configureBlurImageHeader(){
        let scrollOffset = -tableView.contentOffset.y
        let yPos = scrollOffset - headerHeight
        currentPosition = yPos
        headerView.collectionView.isScrollEnabled =  yPos < -1 ? false : true
        currentPosition = currentPosition > CGFloat(maxYOffset) ? CGFloat(maxYOffset) : currentPosition
        let ht = (-yPos * 3.5)/headerHeight
        let alpha = 1.0 - ht > 1.0 ? 1.0 : 1.0 - ht
        headerView.imageViewSupplier.alpha = alpha
        headerView.imageViewSupplier.transform = CGAffineTransform(scaleX: alpha, y: alpha)
        pageControl?.alpha = alpha
        constraintLabel?.constant = scrollOffset - MidPadding < 0 ? 0 : scrollOffset - MidPadding
    }
}


// MARK: Helpers

extension SupplierInfoViewControllerNoFood {
    
    private func getScreen() -> UIImage? {
        let height = (headerHeight - tableView.contentOffset.y) < 0 ? 0 : (headerHeight - tableView.contentOffset.y)
        let backImageSize = CGSize(width: view.bounds.width, height: view.bounds.height - height)
        let backImageOrigin = CGPoint(x: 0, y: height + tableView.contentOffset.y)
        return view.takeSnapshot(CGRect(origin: backImageOrigin, size: backImageSize))
    }
}
// MARK: Public

extension SupplierInfoViewControllerNoFood {
    
    func popTransitionAnimation() {
        guard let transitionDriver = self.transitionDriver else {
            return
        }
        
        let backImage = getScreen()
        let offset = tableView.contentOffset.y > headerHeight ? headerHeight : tableView.contentOffset.y
        transitionDriver.popTransitionAnimationContantOffset(offset, backImage: backImage)
        self.navigationController?.popViewController(animated: false)
    }
    
}


