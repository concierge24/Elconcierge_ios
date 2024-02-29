//
//  SearchTableCell.swift
//  Clikat
//
//  Created by cblmacmini on 4/29/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

protocol SearchProductDelegate {
    func productClicked(atIndexPath indexPath : IndexPath , product : ProductF?)
}

class SearchTableCell: ThemeTableCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate : SearchProductDelegate?
    
    var collectionDataSource = CollectionViewDataSource(){
        didSet{
            collectionView.register(UINib(nibName: CellIdentifiers.ProductCollectionCell,bundle: nil), forCellWithReuseIdentifier: CellIdentifiers.ProductCollectionCell)
        }
    }


    func configureCollectionView(arrProducts : [ProductF]?){
        
        guard  let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else{
            return
        }
        let height : CGFloat = SearchTableViewCellHeight - (layout.sectionInset.top + layout.sectionInset.bottom)
        let width : CGFloat = 138.0
        collectionDataSource = CollectionViewDataSource(items: arrProducts, tableView: collectionView, cellIdentifier: CellIdentifiers.ProductCollectionCell, headerIdentifier: nil, cellHeight:height , cellWidth: width, configureCellBlock: { (cell, item) in
            (cell as? ProductCollectionCell)?.product = item as? ProductF
            }, aRowSelectedListener: { (indexPath) in
                self.delegate?.productClicked(atIndexPath: indexPath, product: arrProducts?[indexPath.row])
        })
        
        collectionView.delegate = collectionDataSource
        collectionView.dataSource = collectionDataSource
    }
}
