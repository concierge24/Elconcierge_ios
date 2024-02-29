//
//  HomeBrandsCollectionCollectionCell.swift
//  Sneni
//
//  Created by Sandeep Kumar on 24/06/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class HomeBrandsCollectionCollectionCell: UICollectionViewCell {
    
    //MARK:- ======== Outlets ========
    @IBOutlet weak var collectionView: UICollectionView? {
        didSet {
            configCollection()
        }
    }
    
    //MARK:- ======== Variables ========
    var collectionViewDataSource: SKCollectionViewDataSource?
    
    var blockSelectBrand: ((Brands) -> ())?
    
    var arrayBrands : [Brands]? {
        didSet {
            collectionViewDataSource?.reload(items: arrayBrands)
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
            
            if let cell = cell as? HomeBrandCollectionCell, let item = item as? Brands {
                cell.objModel = item
            }
        }
        
        collectionViewDataSource?.aRowSelectedListener = {
            [weak self] (indexpath, cell) in
            guard let self = self else { return }
            
            if let objB = self.arrayBrands?[indexpath.row] {
                self.blockSelectBrand?(objB)
            }
        }
        
        collectionViewDataSource?.reload(items: [])
    }
}
