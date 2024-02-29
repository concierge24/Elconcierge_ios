//
//  TokenListingVC.swift
//  Buraq24
//
//  Created by MANINDER on 15/11/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit
import CoreLocation


enum TokenListType : String {
    
    case new = "new"
    case purchased = "purchased"
}

struct EtokenData {
    static var coordinates :CLLocationCoordinate2D?
    static var address : String?
}

class TokenListingVC: BaseVCCab, UIScrollViewDelegate,refreshPurchasedToken {
    
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.separatorStyle = .none
        }
    }
    
    @IBOutlet weak var tableViewPurchased: UITableView!{
        didSet{
            tableViewPurchased.separatorStyle = .none
        }
    }
    
    lazy var refreshControlPast = UIRefreshControl()
    lazy var refreshControlUpcoming = UIRefreshControl()
    var isRightToLeft = false
    var listType : TokenListType = .new
    var companiesList :[companies]?
    var PurchasedList :[PurchasedTokens]?
    
    @IBOutlet weak var viewScroll: UIScrollView!
    @IBOutlet weak var btnNewToken: UIButton!
    @IBOutlet weak var btnPurchasedToken: UIButton!
    @IBOutlet weak var btnBackBase: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var viewMovingLine: UIView!
    @IBOutlet weak var bottomLineLeadingSpace: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tfAddressSearchBar: UITextField!
    
    
    //MARK:- Properties
    
    var tableDataSource : TableViewDataSourceCab?
    var tableDataSourcePurchased : TableViewDataSourceCab?
    var collectionViewDataSource : CollectionViewDataSourceCab?

    var daysDic = ["Sun":0,"Mon":1,"Tue":2,"Wed":3,"Thu":4,"Fri":5,"Sat":6]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.configureTableView()
        self.configureTableViewPurchased()
        self.configureCollectionView()
        self.setUpUI()
        self.swapStackViews()
        self.getCompanyList()
   
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- Functions
    
    func setUpUI() {
        viewScroll.delegate = self
        
        if CouponSelectedLocation.selectedAddress != ""{
        tfAddressSearchBar.text = CouponSelectedLocation.selectedAddress
        }
        
        var imgBack = #imageLiteral(resourceName: "Back")
        if  let languageCode = UserDefaultsManager.languageId{
            guard let intVal = Int(languageCode) else {return}
            switch intVal{
            case 3, 5:
                imgBack = #imageLiteral(resourceName: "Back_New")
            default :
                imgBack = #imageLiteral(resourceName: "Back")
            }
        }
        btnBackBase.setImage(imgBack.setLocalizedImage(), for: .normal)
        configureRefreshControl()
    }
    
    func toggleBtnStates() {
        
        btnNewToken.isSelected = listType == .new ? true : false
        btnPurchasedToken.isSelected = listType == .purchased ? true : false
    }
    
    func configureRefreshControl() {
        
        refreshControlPast.addTarget(self, action: #selector(TokenListingVC.refreshList(refresh:)), for: UIControl.Event.valueChanged)
        refreshControlPast.tintColor = UIColor.colorDefaultSkyBlue
        tableView.refreshControl = refreshControlPast
      
    }
    
    func animateSwipeControl(type : TokenListType) {
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            self?.bottomLineLeadingSpace.constant = self?.listType == .purchased ? 120: 0
            self?.toggleBtnStates()
            self?.view.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    @objc func refreshList(refresh : UIRefreshControl) {
        
        refresh.beginRefreshing()
        if refresh == refreshControlPast {
            self.getCompanyList()
        }else{
            self.getPurchaseList()
        }
    }
    
    func swapStackViews() {
        if isRightToLeft == true {
            if let myView = stackView.subviews.first {
                stackView.removeArrangedSubview(myView)
                stackView.setNeedsLayout()
                stackView.layoutIfNeeded()
                stackView.insertArrangedSubview(myView, at: 1)
                stackView.setNeedsLayout()
            }
        }
    }
    
    func moveToPurchasedToken(){
      self.actionPurchasedTapped(self)
    }
    
    //MARK:- Action methods

    @IBAction func actionPickAddress(_ sender: Any) {
        guard let vc = R.storyboard.drinkingWater.addressPickerVC() else{return}
        self.pushVC(vc)
    }
    
    @IBAction func actionNewTapped(_ sender: Any) {
        viewScroll.scrollTo(direction: .Left)
        listType = .new
        animateSwipeControl(type: listType)
        self.getCompanyList()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        listType = pageNumber == 0 ? .new : .purchased
        animateSwipeControl(type: listType)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if btnNewToken.isSelected{
            self.getCompanyList()
        }
        else{
            self.getPurchaseList()
        }
    }
    
    @IBAction func actionPurchasedTapped(_ sender: Any) {
        
        viewScroll.scrollTo(direction: .Right)
        listType = .purchased
        animateSwipeControl(type: listType)
        self.getPurchaseList()
    }
}

extension TokenListingVC{
    
    func getCompanyList(){
        
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        
        let companyList =   BookServiceEndPoint.getCompanyListWater(type: "New", latitude: LocationManagerCab.shared.latitude, longitude: LocationManagerCab.shared.longitude, category_brand_id: CouponSelectedLocation.categoryId, category_brand_product_id: nil,  take: 1000, skip: 0)
        
        if #available(iOS 16.0, *) {
            companyList.request(header: ["access_token" : "\(token)", "secretdbkey": APIBasePath.secretDBKey, "language_id" : LanguageFile.shared.getLanguage()]) {[weak self] (response) in
                switch response {
                    
                case .success(let resp):
                    let obj = resp as? [companies]
                    self?.companiesList = obj
                    if /self?.btnNewToken.isSelected{
                        self?.configureTableView()
                        self?.refreshControlPast.endRefreshing()
                    }
                    else{
                    }
                    
                case .failure(let strError):
                    Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func getPurchaseList(){
        
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        let purchasedTokenList = BookServiceEndPoint.getTokenPurchaseList(skip: 0, take: 1000)
        
        if #available(iOS 16.0, *) {
            purchasedTokenList.request(header: ["access_token" :  "\(token)", "secretdbkey": APIBasePath.secretDBKey, "language_id" : LanguageFile.shared.getLanguage()]) { [weak self] (response)  in
                switch response{
                case .success(let responseValue):
                    
                    self?.PurchasedList = responseValue as? [PurchasedTokens]
                    self?.configureTableViewPurchased()
                    
                case .failure(let err):
                    Alerts.shared.show(alert: "AppName".localizedString, message: /err , type: .error )
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

extension UIScrollView {
    func scrollToBottom(animated: Bool) {
        if self.contentSize.height < self.bounds.size.height { return }
        let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
        self.setContentOffset(bottomOffset, animated: animated)
    }
}

extension TokenListingVC {
    
    func configureTableView() {
        let  configureCellBlock : ListCellConfigureBlockCab = { [weak self] ( cell , item , indexpath) in
            if let cell = cell as? eTokenCellToBuy {
                
                let obj =  self?.companiesList?[indexpath.row]
                let dic = obj?.toJSON() as NSDictionary?
                var arr:[String] = []
                
                for item:String in (dic?.allKeys as? [String]?)!!{
                    if (item.contains("_service")) && ((dic?.value(forKey: item) as? String) == "1"){
                        arr.append(String(item.prefix(3)).capitalizedFirst().localizedString)
                    }
                }
                
                arr.sort(by: { (self?.daysDic[$0] ?? 7) < (self?.daysDic[$1] ?? 7) })
                cell.lblDeliveryDays.text = arr.joined(separator: ",")
                cell.lblName.text = obj?.name
                cell.imgCompany.sd_setImage(with: URL(string : /self?.companiesList?[indexpath.row].image_url), placeholderImage: #imageLiteral(resourceName: "ic_user"), options: .refreshCached, progress: nil, completed: nil)
                
                
                cell.callBackBtn = { item in
                    
                    guard let vc = R.storyboard.drinkingWater.eTokenToBuyVC() else{return}
                    vc.organisationId = /self?.companiesList?[indexpath.row].organisation_id
                    vc.daysForDelivery = /cell.lblDeliveryDays.text
                    vc.category_brand_id = CouponSelectedLocation.categoryId
                    vc.delegate = self
                    self?.pushVC(vc)
                }
            }
        }
        
        let didSelectCellBlock : DidSelectedRowCab = {  (indexPath , cell, item) in
            if let cell = cell as? eTokenCellToBuy {
                cell.setSelected(false, animated: true)
            }
        }
        
        tableDataSource = TableViewDataSourceCab(items: companiesList, tableView: tableView, cellIdentifier: R.reuseIdentifier.eTokenCellToBuy.identifier, cellHeight: 180)
        tableDataSource?.configureCellBlock = configureCellBlock
        tableDataSource?.aRowSelectedListener = didSelectCellBlock
        tableView.delegate = tableDataSource
        tableView.dataSource = tableDataSource
        tableView.reloadData()
    }
    
    func configureTableViewPurchased() {
        let  configureCellBlock : ListCellConfigureBlockCab = { [weak self] ( cell , item , indexpath) in
            if let cell = cell as? eTokenCellPurchased {
                
                guard let object = self?.PurchasedList?[indexpath.row] else  {return}
                cell.lblName.text = object.categoryBrand?.name
                cell.lblTokenQuantity.text = "\(/object.quantity)" + " tokens"
                cell.lblProductName.text = (object.categoryBrandProduct?.name)! + "/token"
                let total = /object.pendingPaymentAmount + /object.paidPaymentAmount
                cell.lblPrice.text = "\(/total) OMR"
                cell.lblTokenLeft.text =  "\(/object.quantity - /object.quantity_left)"
                cell.lblAvailableToken.text =  "\(/object.quantity_left)"
                
                let str = "http://buraq24.com/BuraqLaravel/public/Resize/"  + "\(/object.categoryBrand?.image)"
                cell.imgCompany.sd_setImage(with: URL(string : str), placeholderImage: #imageLiteral(resourceName: "ic_user"), options: .refreshCached, progress: nil, completed: nil)
            }
        }
        
        let didSelectCellBlock : DidSelectedRowCab = {  (indexPath , cell, item) in
            if let cell = cell as? eTokenCellPurchased {
                cell.setSelected(true, animated: true)
            }
        }
        
        tableDataSourcePurchased = TableViewDataSourceCab(items: PurchasedList, tableView: tableViewPurchased, cellIdentifier: R.reuseIdentifier.eTokenCellPurchased.identifier, cellHeight: 200)
        tableDataSourcePurchased?.configureCellBlock = configureCellBlock
        tableDataSourcePurchased?.aRowSelectedListener = didSelectCellBlock
        tableViewPurchased.delegate = tableDataSourcePurchased
        tableViewPurchased.dataSource = tableDataSourcePurchased
        tableViewPurchased.reloadData()
    }
    
    private func configureCollectionView() {
        
        let configureCellBlock : ListCellConfigureBlockCab = {  (cell, item, indexPath) in
            if let cell = cell as? DrinkingWaterCell, let model = item as? Brand {
                guard let brand:Brand = item as? Brand else {return}
                cell.imgViewWaterBrand.sd_setImage(with: brand.imageURL, completed: nil)
                if CouponSelectedLocation.categoryId == brand.categoryBrandId {
                    cell.imgViewWaterBrand.addBorder(width: 3, color: .colorDefaultSkyBlue)
                }
                else{
                    cell.imgViewWaterBrand.addBorder(width: 0.6, color: .gray)
                }
            }
        }
        
        let didSelectBlock : DidSelectedRowCab = { [weak self] (indexPath, cell, item) in
            if let _ = cell as? DrinkingWaterCell, let model = item as? Brand{
                
                CouponSelectedLocation.categoryId = /model.categoryBrandId
                CouponSelectedLocation.brandSelected = model
                self?.getCompanyList()
                self?.collectionView.reloadData()
            }
        }

        
        collectionViewDataSource = CollectionViewDataSourceCab(items:  CouponSelectedLocation.Brands, collectionView: collectionView, cellIdentifier: R.reuseIdentifier.drinkingWaterCell.identifier, cellHeight: collectionView.frame.size.height, cellWidth: collectionView.frame.size.width/4, configureCellBlock: configureCellBlock, aRowSelectedListener: didSelectBlock)
        collectionView.delegate = collectionViewDataSource
        collectionView.dataSource = collectionViewDataSource
        collectionView.reloadData()
    }
}



extension UIScrollView {
    func scrollTo(direction: ScrollDirection, animated: Bool = true) {
        self.setContentOffset(direction.contentOffsetWith(scrollView: self), animated: animated)
    }
}

typealias  token = (_ item : Int) -> ()

class eTokenCellToBuy:UITableViewCell{
    
    var callBackBtn : token?
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgCompany: UIImageView!
    @IBOutlet weak var lblDeliveryText: UILabel!
    @IBOutlet weak var btnViewOffer: UIButton!
    @IBOutlet weak var lblDeliveryDays: UILabel!
    
    @IBAction func actionViewOffer(_ sender: UIButton) {
        guard  let callback = callBackBtn else{return}
        callback(1)
    }
}

class eTokenCellPurchased:UITableViewCell{
    
    @IBOutlet weak var imgCompany: UIImageView!
    @IBOutlet weak var lblTokenQuantity: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblAvailableToken: UILabel!
    @IBOutlet weak var lblTokenLeft: UILabel!
}
