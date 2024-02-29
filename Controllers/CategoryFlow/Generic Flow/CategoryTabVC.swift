//
//  CategoryTabVC.swift
//  Sneni
//
//  Created by Apple on 02/03/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit

class CategoryTabVC: CategoryFlowBaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var collectionViewDataSource: SKCollectionViewDataSource?
    var arrayItems : [ServiceType] = []
    var supplierId: String?
    var categoriesFromHome : [Categorie]?

    private var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

//        self.openCategory(category: self.arrayItems[3])

        
        // Do any additional setup after loading the view.
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if categoriesFromHome == nil {
            if refreshControl.superview == nil {
                setupRefreshControl()
            }
        }
        btnBack.isHidden = self.navigationController?.viewControllers.last is MainTabBarViewController
    }
    
    func setupView() {
        if let items = categoriesFromHome {
            arrayItems = categoriesFromHome?.map { (category) -> ServiceType in
                var service = category.toServiceType
                service.supplierId = supplierId
                return service
                } ?? []
            self.configureCollectionView()
        }
        else {
            refreshTableData()
        }
    }
    
    func setupRefreshControl() {
        refreshControl.frame = CGRect(x: 0, y: 0, w: 20, h: 20)
        refreshControl.tintColor = SKAppType.type.color
        refreshControl.addTarget(self, action: #selector(refreshTableData), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        
        refreshControl.autoresizingMask = [.flexibleRightMargin, .flexibleLeftMargin]
        refreshControl.subviews[0].frame = CGRect(x: 90, y: 20, w: 20, h: 30)
        
    }
    
    @objc func refreshTableData() {
        self.webserviceHomeData(latitude: LocationSingleton.sharedInstance.searchedAddress?.lat ?? 0.0, longitude: LocationSingleton.sharedInstance.searchedAddress?.long ?? 0.0)
    }

    
    func webserviceHomeData(latitude: Double?,longitude: Double?)  {
        APIManager.sharedInstance.showLoader()
        let objR = API.Home(latitude: latitude ?? nil, longitude: longitude ?? nil, catId: nil)
        APIManager.sharedInstance.opertationWithRequest(refreshControl: refreshControl, withApi: objR) {
            [weak self] (response) in
            APIManager.sharedInstance.hideLoader()
            guard let self = self else { return }
            
            switch response{
            case APIResponse.Success(let object):
                guard let homeObj = object as? Home else {return}
                self.arrayItems = homeObj.arrayServiceTypesEN ?? []
                self.configureCollectionView()
            default :
                break
            }
        }
    }

}
//MARK: - Configure CollectionView
extension CategoryTabVC {
 
    
    func configureCollectionView(){

        let width: CGFloat = min(CGFloat(UIScreen.main.bounds.width-(4*16))/3.0, 96)

        if collectionViewDataSource == nil {
            collectionView?.registerCells(nibNames: [HomeServiceCategoryCollectionCell.identifier])
            collectionViewDataSource = SKCollectionViewDataSource(
                items: arrayItems,
                collectionView: collectionView,
                cellIdentifier: HomeServiceCategoryCollectionCell.identifier,
                cellHeight: width + 40,
                cellWidth: width)
        }

        collectionViewDataSource?.configureCellBlock = {
            (index, cell, item) in

            if let cell = cell as? HomeServiceCategoryCollectionCell, let item = item as? ServiceType {
                cell.imgProfile.layer.cornerRadius = width/2.0
                cell.imgProfile.clipsToBounds = true
                cell.objModel = item
            }

        }

        collectionViewDataSource?.aRowSelectedListener = {
            [weak self] (indexpath, cell) in
            guard let self = self else { return }
            self.openCategory(category: self.arrayItems[indexpath.row])
        }

        collectionViewDataSource?.reload(items: arrayItems)
    }
}
