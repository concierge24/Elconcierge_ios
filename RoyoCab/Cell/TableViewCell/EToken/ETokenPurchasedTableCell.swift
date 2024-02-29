//
//  ETokenPurchasedTableCell.swift
//  Buraq24
//
//  Created by MANINDER on 29/08/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit

class ETokenPurchasedTableCell: UITableViewCell {
    
    //MARK:- Outlets
    @IBOutlet var collectionViewMyToken: UICollectionView!
    
    //MARK:- Properties
    var items : [ETokenPurchased]?
    
     var selectedToken : ETokenPurchased?
    var collectionDataSource : CollectionViewDataSourceCab?
    var purchasedSelectedBlock : ETokenPurchasedSelected?
    
    //MARK:- lifecycle function

    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.main.asyncAfter(deadline: .now() ) {
           self.configureCollectionView()
        }
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    //MARK:- Functions
     func updateCollectionView() {
        self.collectionViewMyToken.reloadData()
    }
    
}


extension ETokenPurchasedTableCell {
    
        func configureCollectionView() {
            let identifier = R.reuseIdentifier.eTokenPurchasedCell.identifier
            let cellNib = UINib.init(nibName:identifier, bundle: Bundle.main)
            collectionViewMyToken.register(cellNib, forCellWithReuseIdentifier: identifier)
            
            
            let didSelectCellBlock : DidSelectedRowCab = { [weak self] (indexPath , cell, item) in
                if let model = item as? ETokenPurchased , let block = self?.purchasedSelectedBlock {
                    self?.selectedToken = model
                   block(model)
                    
                }
            }
            
            let configureCellBlock : ListCellConfigureBlockCab = { [weak self] (cell, item, indexPath) in
                let cell = cell as? ETokenPurchasedCell
                if let model = item as? ETokenPurchased {
                    
                     if let token = self?.selectedToken {
                        cell?.assignTokenData(model: model, selected: token.organisationCouponId == model.organisationCouponId)
                    }else{
                     cell?.assignTokenData(model: model, selected: false)
                    }
                    
                }
            }
            collectionDataSource =  CollectionViewDataSourceCab(items: items , collectionView: collectionViewMyToken, cellIdentifier: identifier, cellHeight: collectionViewMyToken.frame.size.height, cellWidth: 105, configureCellBlock: configureCellBlock )
            collectionDataSource?.aRowSelectedListener = didSelectCellBlock
            collectionViewMyToken.delegate = collectionDataSource
            collectionViewMyToken.dataSource = collectionDataSource
            collectionViewMyToken.reloadData()
        }
}
