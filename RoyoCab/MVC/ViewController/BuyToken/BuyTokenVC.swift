//
//  BuyTokenVC.swift
//  Buraq24
//
//  Created by MANINDER on 29/08/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit

class BuyTokenVC: BaseVCCab {

    //MARK:- Outlets
    @IBOutlet var tblTokens: UITableView!
    @IBOutlet var btnSelect: UIButton!
    
    //MARK:- Properties
    var tableDataSource : HeaderTableViewDataSource?
    var categoryId : Int = 2
    var token : EToken?
   lazy  var headerTitle = [String]()
     var tokenToBuy : ETokenModel?
    var tokenSelected : ETokenPurchased?
      var modeBuy : PaymentScreenMode = .BookRequest
    //MARK:- View Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTokens()
        configureTableView()
       /* if let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            statusBar.backgroundColor = UIColor.clear
        } */
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

   
    //MARK: - Actions
    
    @IBAction func actionBtnSelectPressed(_ sender: Any) {
        if let eToken = tokenSelected {
            
            let nc = NotificationCenter.default
            nc.post(name: Notification.Name(rawValue: LocalNotifications.eTokenSelected.rawValue), object: eToken)
            self.popVC(to: HomeVC.self)
            
        }
        
    }
    
    //MARK:- Functions
    
    func configureTableView() {
        
        tblTokens.registerNibTableCell(nibName: R.reuseIdentifier.eTokenPurchasedTableCell.identifier )
        tblTokens.registerNibTableCell(nibName: R.reuseIdentifier.eTokenTableCell.identifier )
        let headerNib = UINib.init(nibName: "ETokenHeaderView", bundle: Bundle.main)
        tblTokens.register(headerNib, forHeaderFooterViewReuseIdentifier: "ETokenHeaderView")
       
        let  configureCellBlock :  ListCellConfigureBlockCab? = { [weak self] ( cell , item , indexPath) in
               if  let cell = cell as? ETokenPurchasedTableCell  {
                
                
                cell.items = self?.token?.myTokens
                cell.updateCollectionView()
                
                cell.purchasedSelectedBlock = { [weak self] (token : ETokenPurchased) in
                    self?.tokenSelected = token
                    self?.tblTokens.reloadData()
                }
                
                if let selectedModel = self?.tokenSelected {
                    cell.selectedToken = selectedModel
                }
                
              }else if let cell = cell as? ETokenTableCell , let item = item as? Brand {
                  cell.items = self?.token?.brands?[indexPath.row].brandTokens
                cell.assignData(model: item)
                cell.eTokenSelected = { [weak self] (token : ETokenModel) in
                    self?.tokenToBuy = token
                    self?.showAlert()
                }
            }
        }
        
        let headerViewBlock : ViewForHeaderInSectionCab = { [weak self]( headerView , section) in
            if  let header = headerView as? ETokenHeaderView {
                header.lblHeaderTitle.text  = self?.headerTitle[section]
            }
        }
        
        guard let myTokens = token?.myTokens  else {return}
         guard let brands = token?.brands  else {return}
        
        var tokenSections : [[Any]] = []
        var heights = [CGFloat]()
        var identifierArray = [String]()
        if myTokens.count > 0 {
            tokenSections.append([myTokens])
            headerTitle.append("purchased".localizedString)
            heights.append(CGFloat(150))
            identifierArray.append(R.reuseIdentifier.eTokenPurchasedTableCell.identifier)
        }
        
        if brands.count > 0  {
            
            tokenSections.append(brands)
            headerTitle.append("offers_available_near_you".localizedString)
             heights.append(CGFloat(235))
            identifierArray.append(R.reuseIdentifier.eTokenTableCell.identifier)
            
        }

        tableDataSource = HeaderTableViewDataSource(cellItems: tokenSections,
                                                    tableView: tblTokens,
                                                    cellIdentifiers: identifierArray,
                                                    cellHeights: heights,
                                                    headerIdentifiers: ["ETokenHeaderView", "ETokenHeaderView"], sections: tokenSections.count,
                                                    headerHeight: [45,45])
        tableDataSource?.configureCellBlock = configureCellBlock
        tableDataSource?.configureHeaderBlock = headerViewBlock
        tblTokens.delegate = tableDataSource
        tblTokens.dataSource = tableDataSource
        tblTokens.reloadData()
        btnSelect.isHidden = modeBuy == .SideMenu
    }
    
    func showAlert() {
        Alerts.shared.show(alert: "AppName".localizedString, message:"coming_soon".localizedString , type: .error )
    }
    
}
//MARK:- API
extension BuyTokenVC {
    
    func getTokens() {
        
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        let obj = BookServiceEndPoint.eTokens(categoryId: categoryId, distance: 2000, take: 100, orderTimings: Date().toFormattedDateString())
        obj.request(header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token, "secretdbkey": APIBasePath.secretDBKey]) { [weak self] (response) in
            switch response {
              case .success(let data):
                    guard let model = data as? EToken else { return }
                    self?.token = model
                    self?.configureTableView()
                break
            case .failure(let strError):
                Alerts.shared.show(alert: "AppName".localizedString, message:/strError , type: .error )

                //Toast.show(text: strError, type: .error)
            }
        }
    }
    
    func buyToken() {
        
         let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        guard let tokenId = tokenToBuy?.organisationCouponId else {return}
        let obj = BookServiceEndPoint.buyETokens(eTokenId: tokenId)
        
        obj.request(header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token, "secretdbkey": APIBasePath.secretDBKey]) { [weak self] (response) in
            switch response {
            case .success(_):
                self?.getTokens()
                break
            case .failure(let strError):
                Alerts.shared.show(alert: "AppName".localizedString, message:/strError , type: .error )

               // Toast.show(text: strError, type: .error)
            }
        }
    }
    
}
