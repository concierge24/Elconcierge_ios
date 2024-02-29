//
//  HomeBrandsCollectionTableCell.swift
//  Sneni
//
//  Created by Sandeep Kumar on 14/06/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class HomeBrandsCollectionTableCell: UITableViewCell {

    //MARK:- ======== Outlets ========
    @IBOutlet weak var collectionView: UICollectionView? {
        didSet {
            configCollection()
        }
    }
    
    //MARK:- ======== Variables ========
    var collectionViewDataSource: SKCollectionViewDataSource?
    
    var isBrand: Bool = SKAppType.type == .eCom
    var blockSelectBrand: ((Brands) -> ())?
    var blockSelectSupplier: ((Supplier) -> ())?

    var arrayBrands : [Brands]? {
        didSet {
            collectionViewDataSource?.reload(items: arrayBrands)
        }
    }
    
    var arraySuppliers : [Supplier]? {
        didSet {
            collectionViewDataSource?.reload(items: arraySuppliers)
        }
    }

    //MARK:- ======== LifeCycle ========
    override func awakeFromNib() {
        super.awakeFromNib()
        initalSetup()
    }
    
    //MARK:- ======== Actions ========
    
    //MARK:- ======== Functions ========
    func initalSetup() {
        
    }
    
    private func configCollection() {
        
        let identifier = HomeBrandCollectionCell.identifier
        collectionView?.registerCells(nibNames: [identifier])
        
        collectionViewDataSource = SKCollectionViewDataSource(collectionView: collectionView, cellIdentifier: identifier, cellHeight: 104.0, cellWidth: 128.0)
        
        collectionViewDataSource?.configureCellBlock = {
            (indexpath, cell, item) in
            
            if let cell = cell as? HomeBrandCollectionCell {
                if let item = item as? Brands {
                    cell.objModel = item
                } else if let item = item as? Supplier {
                    cell.objModelS = item
                }
            }
        }
        
        collectionViewDataSource?.aRowSelectedListener = {
            [weak self] (indexpath, cell) in
            guard let self = self else { return }
            
            if let objB = self.isBrand ? self.arrayBrands?[indexpath.row] : self.arraySuppliers?[indexpath.row] {
                self.isBrand ? self.blockSelectBrand?(objB as! Brands) : self.blockSelectSupplier?(objB as! Supplier)
            }
        }
        
        collectionViewDataSource?.reload(items: [])
    }
}
