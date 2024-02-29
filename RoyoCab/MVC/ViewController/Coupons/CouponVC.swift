//
//  CouponVC.swift
//  Buraq24
//
//  Created by MANINDER on 01/10/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit

class CouponVC: BaseVCCab {

    
    //MARK:- Outlets
    
    @IBOutlet var tblCoupons: UITableView!
    
    //MARK:- Properties
    var tableDataSource : HeaderTableViewDataSource?
     lazy  var headerTitle = [String]()

    
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- Functions
    
    func configureTableView() {
        
        tblCoupons.registerNibTableCell(nibName: R.reuseIdentifier.eTokenPurchasedTableCell.identifier )
        tblCoupons.registerNibTableCell(nibName: R.reuseIdentifier.eTokenTableCell.identifier )
        let headerNib = UINib.init(nibName: "ETokenHeaderView", bundle: Bundle.main)
        tblCoupons.register(headerNib, forHeaderFooterViewReuseIdentifier: "ETokenHeaderView")
        
        let  configureCellBlock :  ListCellConfigureBlockCab? = { [weak self] ( cell , item , indexPath) in
            if  let cell = cell as? ETokenPurchasedTableCell  {
                
                
             //   cell.items = self?.token?.myTokens
             //   cell.updateCollectionView()
                
                cell.purchasedSelectedBlock = { [weak self] (token : ETokenPurchased) in
//                    self?.tokenSelected = token
//                    self?.tblTokens.reloadData()
                }
                
//                if let selectedModel = self?.tokenSelected {
//                    cell.selectedToken = selectedModel
//                }
                
            }else if let cell = cell as? ETokenTableCell , let item = item as? Brand {
//                cell.items = self?.token?.brands?[indexPath.row].brandTokens
//                cell.assignData(model: item)
//                cell.eTokenSelected = { [weak self] (token : ETokenModel) in
//                    self?.tokenToBuy = token
//                    self?.showAlert()
//                }
            }
        }
        
        let headerViewBlock : ViewForHeaderInSectionCab = { [weak self]( headerView , section) in
            if  let header = headerView as? ETokenHeaderView {
                header.lblHeaderTitle.text  = self?.headerTitle[section]
            }
        }
        
       // guard let myTokens = token?.myTokens  else {return}
       //  guard let brands = token?.brands  else {return}
        
        var tokenSections : [[Any]] = []
        var heights = [CGFloat]()
        var identifierArray = [String]()
//        if myTokens.count > 0 {
//            tokenSections.append([myTokens])
//            headerTitle.append("purchased".localizedString)
//            heights.append(CGFloat(150))
//            identifierArray.append(R.reuseIdentifier.eTokenPurchasedTableCell.identifier)
//        }
        
        
        
//        if brands.count > 0  {
//            tokenSections.append(brands)
//            headerTitle.append("offers_available_near_you".localizedString)
//            heights.append(CGFloat(235))
//            identifierArray.append(R.reuseIdentifier.eTokenTableCell.identifier)
//        }
        
        tableDataSource = HeaderTableViewDataSource(cellItems: tokenSections,
                                                    tableView: tblCoupons,
                                                    cellIdentifiers: identifierArray,
                                                    cellHeights: heights,
                                                    headerIdentifiers: ["ETokenHeaderView", "ETokenHeaderView"], sections: tokenSections.count,
                                                    headerHeight: [45,45])
        tableDataSource?.configureCellBlock = configureCellBlock
        tableDataSource?.configureHeaderBlock = headerViewBlock
        tblCoupons.delegate = tableDataSource
        tblCoupons.dataSource = tableDataSource
        tblCoupons.reloadData()
    }
    
  
    
}
//MARK:- API
extension CouponVC {
    
  
    func getCoupons() {
        
//        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
//         let obj = BookServiceEndPoint.eTokens(categoryId: categoryId, distance: 2000, take: 100, orderTimings: Date().toFormattedDateString())
//        obj.request(header: ["access_token" :  token]) { [weak self] (response) in
//            switch response {
//            case .success(let data):
//                guard let model = data as? EToken else { return }
//                self?.token = model
//                self?.configureTableView()
//                break
//            case .failure(let strError):
//                Toast.show(text: strError, type: .error)
//            }
//        }
    }

}
