//
//  HomeServiceCategoriesTableCell.swift
//  Sneni
//
//  Created by Sandeep Kumar on 27/06/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class HomeServiceCategoriesTableCell: UITableViewCell {
    
    //MARK:- ======== Outlets ========
    @IBOutlet weak var constraintHeightCollection: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView? {
        didSet {
            configCollection()
        }
    }
    
    //MARK:- ======== Variables ========
    var type: HomeScreenSection = .None
    var collectionViewDataSource: SKCollectionViewDataSource?
    var delegate : ServiceTypeDelegate?
    var blockSelect: ((ServiceType) -> ())?
    
    var arrayItems : [ServiceType]? {
        didSet {
            let size = HomeServiceCategoryCollectionCell.size(row: 0, type: type)
            var rows = /arrayItems?.count
            
            //Nitin
            rows = rows%4 > 0 ? rows+1 : rows
            rows /= 4
            
//            rows = rows%2 > 0 ? rows+1 : rows
//            rows /= 2
            let height = size.height*CGFloat(rows)
//            if type == .listCategories1st2, rows > 1 {
//                let sizeA = HomeServiceCategoryCollectionCell.size(row: 2, type: type)
//                rows = (/arrayItems?.count) - 2
//                rows = rows%3 > 0 ? rows+(rows%3) : rows
//                rows /= 3
//                height = size.height+CGFloat(rows)*sizeA.height
//                rows += 1
//            }
            
            constraintHeightCollection.constant = height+5*CGFloat(rows+1)
            collectionViewDataSource?.reload(items: arrayItems)
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
        
        let identifier = HomeServiceCategoryCollectionCell.identifier
        collectionView?.registerCells(nibNames: [identifier])
        
        collectionViewDataSource = SKCollectionViewDataSource(collectionView: collectionView, cellIdentifier: identifier, cellHeight: size.height, cellWidth: size.width)
        collectionViewDataSource?.blockSizeConfigure = {
            [weak self] index in
            guard let self = self else { return .zero }
            let size = HomeServiceCategoryCollectionCell.size(row: index.row, type: self.type)
            return CGSize(width: size.width, height: size.height)
        }
        
        collectionViewDataSource?.configureCellBlock = {
            (indexpath, cell, item) in
            
            if let cell = cell as? HomeServiceCategoryCollectionCell, let item = item as? ServiceType {
                cell.objModel = item
            }
        }
        
        collectionViewDataSource?.aRowSelectedListener = {
            [weak self] (indexpath, cell) in
            guard let self = self else { return }
            
            if let objB = self.arrayItems?[indexpath.row] {
                self.delegate?.categoryClicked(service : objB)
            }
        }
        
        collectionViewDataSource?.reload(items: [])
    }
}
