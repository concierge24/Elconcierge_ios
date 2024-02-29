//
//  SelectMainCategoryViewController.swift
//  Trava
//
//  Created by Apple on 11/11/19.
//  Copyright © 2019 CodeBrewLabs. All rights reserved.
//

import UIKit

class SelectMainCategoryViewController: UIViewController {

    enum Category: Int {
        case bookTaxi = 1
        case packagedDelivery
        case schoolRides
    }
    
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    //MARK:- Outlet
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var buttonBack: UIButton!
    
    @IBOutlet weak var constraintHeightTableView: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView! {
           didSet {
               tableView.separatorStyle = .none
           }
       }
    
    
    
    //MARK:- Properties
    var tableDataSource : TableViewDataSourceCab?
    var isFromSideMenu: Bool = false
    var arrayBanner : [BannerCab]? {
        didSet {
            
            tableDataSource?.items = self.arrayBanner
            tableView.reloadData()
            constraintHeightTableView.constant = CGFloat(/self.arrayBanner?.count * 180)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        constraintHeight.constant = UIScreen.main.bounds.size.height - 232
    }

}

extension SelectMainCategoryViewController {
    
    func initialSetup() {
        
        labelUsername.text = "Hey Welcome, ".localizedString + /UDSingleton.shared.userData?.userDetails?.user?.name
        
        buttonBack.isHidden = !isFromSideMenu
        
        configureTableView()
        apiBannerAndServices()
    }
    
    func configureTableView() {
        
        let  configureCellBlock : ListCellConfigureBlockCab = { ( cell , item , indexpath) in
            if let cell = cell as? UITableViewCell {
                let imageView = cell.viewWithTag(100) as? UIImageView
                
                let urlString = APIBasePath.baseImagePath + /(item as? BannerCab)?.image
                guard let url = URL(string: urlString) else {return}
                imageView?.kf.setImage(with: url)
            }
        }
        
        let didSelectCellBlock : DidSelectedRowCab = { (indexPath , cell, item) in
            if cell is UITableViewCell {
                
                guard let url = URL(string: /(item as? BannerCab)?.bannerUrl) else {return}
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                
            }
        }
        
        tableDataSource = TableViewDataSourceCab(items: arrayBanner, tableView: tableView, cellIdentifier: "bannerCell", cellHeight: 180)
        tableDataSource?.configureCellBlock = configureCellBlock
        tableDataSource?.aRowSelectedListener = didSelectCellBlock
        tableView.delegate = tableDataSource
        tableView.dataSource = tableDataSource
        tableView.reloadData()
    }
    
}

extension SelectMainCategoryViewController {
    
    @IBAction func buttonCategoryClicked(_ sender: UIButton) {
        
        guard let category = Category(rawValue: sender.tag) else {return}
        
        switch category {
        
        case .bookTaxi:
            debugPrint("Pass catID 7 to home vc")
            
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.setHomeAsRootVC()
            
        case .packagedDelivery:
            debugPrint("Coming Soon")
            
        case .schoolRides:
            debugPrint("Coming Soon")
        }
        
    }
    
    @IBAction func buttonBackClicked(_ sender: Any) {
        popVC()
    }
}

//MARK:- API
extension SelectMainCategoryViewController {
    
    func apiBannerAndServices() {
        
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        
        let getCreditPointsObject = BookServiceEndPoint.bannerAndServices
        getCreditPointsObject.request(isLoaderNeeded: true, header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token]) { [weak self] (response) in
            switch response {
                
            case .success(let data):
                
                guard let modal = data as? BannerServicesModal else {return}
                self?.arrayBanner = modal.banners
                
                
            case .failure(let strError):
                
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
            }
        }
    }
    
}
