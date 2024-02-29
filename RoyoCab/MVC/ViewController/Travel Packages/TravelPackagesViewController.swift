//
//  TravelPackagesViewController.swift
//  Trava
//
//  Created by Apple on 22/11/19.
//  Copyright © 2019 CodeBrewLabs. All rights reserved.
//

import UIKit

class TravelPackagesViewController: BaseVCCab {

    //MARK:- Outlet
    @IBOutlet var tableView: UITableView?
    
    //MARK:- Properties
    var tableDataSource : TableViewDataSourceCab?
    var arrayPackages: [TravelPackages]?
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 16.0, *) {
            initialSetup()
        } else {
            // Fallback on earlier versions
        }
    }


}

// MARK:- Functions
@available(iOS 16.0, *)
extension TravelPackagesViewController {
    
    
    func initialSetup() {
        
        var imgBack = R.image.ic_back_arrow_black()
        if  let languageCode = UserDefaultsManager.languageId{
            guard let intVal = Int(languageCode) else {return}
            switch intVal{
            case 3, 5:
                imgBack = #imageLiteral(resourceName: "Back_New")
            default :
                imgBack = R.image.ic_back_arrow_black()
            }
        }
        
       // btnBack.setImage(imgBack?.setLocalizedImage(), for: .normal)
        configureTableView()
        
        apiPackages()
    }
    
    func configureTableView() {
        
       // tableView?.register(R.nib.travelPackages(), forCellReuseIdentifier: R.reuseIdentifier.travelPackagesCell.identifier )
        
        tableView?.register(UINib(nibName: R.reuseIdentifier.travelPackagesCell.identifier, bundle:nil), forCellReuseIdentifier: R.reuseIdentifier.travelPackagesCell.identifier)
        
        let  configureCellBlock : ListCellConfigureBlockCab = { ( cell , item , indexpath) in
            if let cell = cell as? TravelPackagesTableViewCell {
                
                cell.assignData(indexPath: indexpath, item: item as? TravelPackages)
            }
        }
        
        let didSelectCellBlock : DidSelectedRowCab = { [weak self] (indexPath , cell, item) in
            if cell is TravelPackagesTableViewCell {
              
                guard let vc = R.storyboard.sideMenu.packageDetailViewController() else{return}
                vc.object = item as? TravelPackages
                vc.selectedOptionIndexPath = indexPath
                self?.pushVC(vc)
                
            }
        }
        
        tableDataSource = TableViewDataSourceCab(items: arrayPackages, tableView: tableView, cellIdentifier: R.reuseIdentifier.travelPackagesCell.identifier, cellHeight: UITableView.automaticDimension)
        tableDataSource?.configureCellBlock = configureCellBlock
        tableDataSource?.aRowSelectedListener = didSelectCellBlock
        tableView?.delegate = tableDataSource
        tableView?.dataSource = tableDataSource
        tableView?.reloadData()
    }
    
    
}

extension TravelPackagesViewController {
    
    @IBAction func actionBackPressed(_ sender: Any) {
        popVC()
    }
    
}


@available(iOS 16.0, *)
extension TravelPackagesViewController {
    
    func apiPackages() {
        
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        
        let obj = BookServiceEndPoint.packageListing
        obj.request(header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token,"secretdbkey": APIBasePath.secretDBKey]) {  [weak self] (response) in
            
            switch response {
            case .success(let data):
                debugPrint("Successs")
                
                guard let model = data as? [TravelPackages] else { return }
                self?.arrayPackages = model
                
                self?.tableDataSource?.items = self?.arrayPackages
                self?.tableView?.reloadData()
                
            case .failure(let strError):
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
            }
        }
    }
    
    
}
