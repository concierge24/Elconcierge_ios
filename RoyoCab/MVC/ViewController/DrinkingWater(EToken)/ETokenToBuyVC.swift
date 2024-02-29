//
//  ETokenToBuyVC.swift
//  Buraq24
//
//  Created by MANINDER on 27/10/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit



class ETokenToBuyVC: BaseVCCab , refreshPurchasedToken{
    
    
    //MARK:- Outlets
    
    @IBOutlet var imgViewWaterBrand: UIImageView!
    @IBOutlet var lblBrandName: UILabel!
    @IBOutlet var tblTokenListing: UITableView!
    @IBOutlet var lblQuantitySelected: UILabel!
    @IBOutlet weak var lblDaysOfDelivery: UILabel!
    
    @IBOutlet weak var imgSourceview: UIImageView!
    
    var tableDataSource : TableViewDataSourceCab?
    var organisationId :Int?
    var category_brand_id :Int?
    var tokens:[Tokens]?
    var response : CompanyTokenListing?
    var address :String?
    var daysForDelivery = String()
    
    var delegate:refreshPurchasedToken?
    //MARK:- Properties
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCompanyTokenList()
        self.setupController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- Custom Functions
    
    func setupController(){
        lblDaysOfDelivery.text = daysForDelivery
        
    }
    
    //MARK:- Actions
    @IBAction func actionBtnSelectQuantity(_ sender: UIButton) {
        
        let dataSource:[String] = Array(1...1000).map{String($0)}
        
        Utility.shared.showDropDown(anchorView: imgSourceview, dataSource:   dataSource, width: 95, handler: { [weak self] (index, strValu) in
            self?.lblQuantitySelected.text = strValu
        })
    }
    
    func dismissController() {
        self.popVC()
        delegate?.moveToPurchasedToken()
    }
}

extension ETokenToBuyVC{
    
    func configureTableView() {
        let  configureCellBlock : ListCellConfigureBlockCab = { [weak self] ( cell , item , indexpath) in
            if let cell = cell as? BrandETokenCell {
                
                cell.lblTokenPrice.text =  "\(/self?.tokens?[indexpath.row].price) OMR"
                cell.lblTotalToken.text = "\(/self?.tokens?[indexpath.row].quantity) Tokens"
                cell.lblTokenValue.text = "\(/self?.tokens?[indexpath.row].categoryBrandProduct?.name)/token"
                
                cell.callBackBtn = { item in
                    print(item)
                    guard let vc = R.storyboard.drinkingWater.bottleReturnVC() else{return}
                    vc.modalPresentationStyle = .overFullScreen
                    vc.providesPresentationContextTransitionStyle = true
                    vc.definesPresentationContext = true
                    vc.response = self?.response
                    vc.tokenIndex = indexpath.row
                    vc.delegate = self
                    vc.bottleQuantity = Int(/self?.lblQuantitySelected.text)
                    self?.present(vc, animated: true, completion: nil)
                }
            }
        }
        
        let didSelectCellBlock : DidSelectedRowCab = {(indexPath , cell, item) in
            if let cell = cell as? BrandETokenCell {
                cell.setSelected(false, animated: true)
            }
        }
        
        tableDataSource = TableViewDataSourceCab(items: self.tokens, tableView: tblTokenListing, cellIdentifier: R.reuseIdentifier.brandETokenCell.identifier, cellHeight: 110)
        tableDataSource?.configureCellBlock = configureCellBlock
        tableDataSource?.aRowSelectedListener = didSelectCellBlock
        tblTokenListing.delegate = tableDataSource
        tblTokenListing.dataSource = tableDataSource
        tblTokenListing.reloadData()
    }
}

extension ETokenToBuyVC{
    
    func getCompanyTokenList(){
        
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        let list = BookServiceEndPoint.getTokenList(organisation_id: organisationId!, category_brand_id:/category_brand_id ,skip: 0, take: 100)
        
        if #available(iOS 16.0, *) {
            list.request(header: ["access_token" :  "\(token)", "secretdbkey": APIBasePath.secretDBKey, "language_id" : LanguageFile.shared.getLanguage()]) {[weak self] (response) in
                switch response {
                case .success(let resp):
                    
                    self?.tokens = (resp as? CompanyTokenListing)?.eTokens
                    self?.response = resp as? CompanyTokenListing
                    self?.configureTableView()
                    
                    let orgObject = (resp as? CompanyTokenListing)?.organisation
                    
                    self?.imgViewWaterBrand.sd_setImage(with: URL(string : /orgObject?.image_url), placeholderImage: #imageLiteral(resourceName: "ic_user"), options: .refreshCached, progress: nil, completed: nil)
                    self?.lblBrandName.text = "\(/orgObject?.name)"
                    
                case .failure(let strError):
                    Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
}
