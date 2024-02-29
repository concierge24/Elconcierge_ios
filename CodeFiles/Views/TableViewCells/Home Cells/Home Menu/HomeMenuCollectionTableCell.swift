//
//  HomeMenuCollectionTableCell.swift
//  Sneni
//
//  Created by Sandeep Kumar on 14/06/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

enum HomeMenuType: String {
    case discountItems = "Discount Products"
    case brands = "Popular Brands"
    case recommended = "Royo Recomended"
    
    var image: UIImage? {
        switch self {
        case .discountItems:
            return #imageLiteral(resourceName: "ic_discount")
        case .brands:
            return #imageLiteral(resourceName: "ic_popular")
        case .recommended:
            return #imageLiteral(resourceName: "ic_recommend")
        
        }
    }
}

class HomeMenuCollectionTableCell: UITableViewCell {
    
    //MARK:- ======== Outlets ========
    @IBOutlet weak var collectionView: UICollectionView? {
        didSet {
            configCollection()
        }
    }
    
    //MARK:- ======== Variables ========
    var collectionViewDataSource: SKCollectionViewDataSource?
    var blockSelectMenu: ((HomeMenuType) -> ())?    
    var arrayItems : [HomeMenuType] = [] {
        didSet {
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
        arrayItems = [HomeMenuType.discountItems, .brands, .recommended]
    }
    
    private func configCollection() {
        
        let identifier = HomeMenuCollectionCell.identifier
        collectionView?.registerCells(nibNames: [identifier])
        
        let width = (UIScreen.main.bounds.width-48.0)/3.0
        
        collectionViewDataSource = SKCollectionViewDataSource(collectionView: collectionView, cellIdentifier: identifier, cellHeight: 64.0, cellWidth: width)
        
        collectionViewDataSource?.configureCellBlock = {
            (indexpath, cell, item) in
            
            if let cell = cell as? HomeMenuCollectionCell, let item = item as? HomeMenuType {
                cell.objModel = item
            }
        }
        
        collectionViewDataSource?.aRowSelectedListener = {
            [weak self] (indexpath, cell) in
            guard let self = self else { return }
            
            let objB = self.arrayItems[indexpath.row]
            self.blockSelectMenu?(objB)
            
        }
        
        collectionViewDataSource?.reload(items: arrayItems)
    }
}
