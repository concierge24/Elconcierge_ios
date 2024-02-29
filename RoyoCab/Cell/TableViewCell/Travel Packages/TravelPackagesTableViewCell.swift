//
//  TravelPackagesTableViewCell.swift
//  Trava
//
//  Created by Apple on 22/11/19.
//  Copyright © 2019 CodeBrewLabs. All rights reserved.
//

import UIKit

enum PackageType: Int {
    case hour = 1
    case day
    case month
    
    func getText() -> String? {
        
        switch self {
        case .hour:
            return "Hours".localizedString
            
        case .day:
            return "Days".localizedString
            
        case .month:
            return "Months".localizedString
        }
    }
}

class TravelPackagesTableViewCell: UITableViewCell {

     //MARK:- Outlet
    @IBOutlet var collectionView: UICollectionView?
    @IBOutlet weak var constraintCollectionWidth: NSLayoutConstraint!
    
    @IBOutlet weak var labelTravelDistance: UILabel!
    @IBOutlet weak var labelPackageName: UILabel!

    @IBOutlet weak var packageCost: UILabel!
    @IBOutlet weak var labelDescWithDistance: UILabel!
    @IBOutlet weak var labelPackageValidity: UILabel!
    @IBOutlet weak var buttonViewPackage: UIButton!
    @IBOutlet weak var imageViewBG: UIImageView!
    
    //MARK:- Properties
    var collectionViewDataSource : CollectionViewDataSourceCab?
    var indexPath: IndexPath?
    var item: TravelPackages?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func assignData(indexPath: IndexPath?, item: TravelPackages?, isDetailPage: Bool = false, isGreenImageBG : Bool = false) {
        self.indexPath = indexPath
        self.item = item
        
        buttonViewPackage.isHidden = isDetailPage
        
        if isDetailPage {
            imageViewBG.image = isGreenImageBG ? R.image.package_bg_green() : R.image.package_bg_red()
        } else {
            imageViewBG.image = /indexPath?.row % 2 == 0 ? R.image.package_bg_green() : R.image.package_bg_red()
        }
        
        labelTravelDistance.text = "Taxi Package for \(/item?.package?.distanceKms) KM"
        labelPackageName.text = item?.name
        packageCost.text = (/UDSingleton.shared.appSettings?.appSettings?.currency) + " " + String(/item?.package?.packagePricings?.first?.distancePriceFixed)
        labelDescWithDistance.text = "for first \(/item?.package?.distanceKms) km per ride"
        
        let text = PackageType(rawValue: (/item?.package?.packageType?.toInt()))?.getText()
        labelPackageValidity.text =   "Valid for \(/item?.package?.validity) \(/text)"
        
        
        
        configureCollectionView()
    }

}

extension TravelPackagesTableViewCell {
    
    func configureCollectionView() {
        
        let items = item?.package?.packagePricings
        
        collectionView?.register(UINib(nibName: R.reuseIdentifier.vehicleImageCollectionCell.identifier, bundle:nil), forCellWithReuseIdentifier: R.reuseIdentifier.vehicleImageCollectionCell.identifier)
        
        let configureCellBlock : ListCellConfigureBlockCab = { (cell, item, indexPath) in
            
            let imageView = ((cell as? UICollectionViewCell)?.viewWithTag(100) as? UIImageView)
            
            guard let imageString = (item as? PackagePricing)?.categoryBrandProduct?.image,
                  let url = URL(string: imageString) else {
                imageView?.image = R.image.ic_car_white()
                return
            }
            
            imageView?.sd_setImage(with: url, completed: nil)
            
        }
        
        let didSelectBlock : DidSelectedRowCab = { (indexPath, cell, item) in
            
           /* if let _ = cell as? SelectBrandCell, let model = item as? ProductF {
                self?.request?.selectedProduct = model
                self?.collectionViewProduct.reloadData()
            } */
        }
        
        
        collectionViewDataSource = CollectionViewDataSourceCab(items: items, collectionView: collectionView, cellIdentifier: R.reuseIdentifier.vehicleImageCollectionCell.identifier, cellHeight:  30.0, cellWidth: 30.0 , configureCellBlock: configureCellBlock, aRowSelectedListener: didSelectBlock)
        collectionView?.delegate = collectionViewDataSource
        collectionView?.dataSource = collectionViewDataSource
        collectionView?.reloadData()
        
        // Set width of collectionview
        let width = collectionView?.collectionViewLayout.collectionViewContentSize.width
        constraintCollectionWidth.constant = /width
        self.layoutIfNeeded()
    }
}

extension TravelPackagesTableViewCell {
    
    @IBAction func buttonViewPackageClicked(_ sender: Any) {
        guard let vc = R.storyboard.sideMenu.packageDetailViewController() else {return}
        vc.object = item
        UIApplication.topViewController()?.pushVC(vc)
    }
    
}
