//
//  ServiceTypeParentCell.swift
//  Clikat
//
//  Created by Night Reaper on 19/04/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

protocol ServiceTypeDelegate {
    func categoryClicked(service: ServiceType?)
}

class ServiceTypeParentCell: ThemeTableCell {
    
    @IBOutlet var collectionView: UICollectionView!
    var delegate : ServiceTypeDelegate?
    
    var collectionViewDataSource = CollectionViewDataSource() {
        didSet {
            collectionViewDataSource.isServiceTypeCollectionView = true
            collectionView.dataSource = collectionViewDataSource
            collectionView.delegate = collectionViewDataSource
        }
    }
    var serviceTypes : [ServiceType]? {
        didSet{
            updateUI()
        }
    }
    
    var categoryTypes : [SubCategory]?{//[SubSub_Category]?{
    didSet{
    updateUI()
    }
    }
    private func updateUI(){
        // Reload Collection View
//        let isOnly2 = /serviceTypes?.count <= 2

//        let widthCell = isOnly2 ? (bounds.width-(10.0*3))/2 : (bounds.width-(10.0*5))/3
        let identifier = SKAppType.type == .food ? CellIdentifiers.ServiceTypeCellFood : CellIdentifiers.ServiceTypeCellCat
//        let heightCell = bounds.height-20.0

        let height = CGFloat(76.0)
        let width = CGFloat(height*(SKAppType.type == .food ? 1.22 : 1.85))
        
        
//        if SKAppType.type == .food{
//            //let type :[SubSub_Category]? = categoryTypes
//            let type :[SubCategory]? = categoryTypes
//        }
//        else{
//            let type :[ServiceType]? = serviceTypes
//        }
        
        collectionViewDataSource = CollectionViewDataSource(    
            items: categoryTypes,//serviceTypes,
            tableView: collectionView,
            cellIdentifier: identifier,
            headerIdentifier: nil,
            cellHeight: height,
            cellWidth: width,
            configureCellBlock: {
                (cell, item) in
                
                if let cell = cell as? ServiceTypeCell,
                    let item = item as? ServiceType
                {
                    cell.service = item
                } else if let cell = cell as? ServiceTypeCell, let item = item as? SubCategory
                {
                    cell.subCategory = item
                }
                
        }, aRowSelectedListener: {
            [weak self] (indexPath) in
            guard let self = self else { return }
            let subCategory = self.categoryTypes?[indexPath.row]

            let selectedCatId = AppSettings.shared.selectedCategoryId
            
            let VC = SupplierListingViewController.getVC(.main)
            GDataSingleton.sharedInstance.currentSupplier = nil
//            VC.showBranchList = true
//            VC.showDetailPage = true
            VC.fromCat = true
           // VC.titleStr = /subCategory?.name
            
            
            
            VC.passedData = PassedData(withCatergoryId: selectedCatId, categoryFlow: nil, supplierId: nil ,subCategoryId: /subCategory?.subCategoryId ,productId: nil,branchId: nil, subCategoryName: nil , categoryOrder: nil, categoryName : nil)
            
            ez.topMostVC?.pushVC(VC)
            //old
           // self.delegate?.categoryClicked(service : self.serviceTypes?[indexPath.row])
        })
        
//        collectionViewDataSource.blockSizeCell = {
//            (index) in
////            guard let self = self, let font = UIFont(name: "ProximaNova-Bold", size: 12.0) else { return CGSize.zero }
////            let title = /self.serviceTypes?[index.row].name
////
////            var width = title.width(font: font)+50+10
////            if !isOnly2 {
////                width = [CGFloat(50+20), title.width(font: font)].max() ?? 0.0
////            }
//            return CGSize(width: width, height: heightCell)
//        }
    }
}
