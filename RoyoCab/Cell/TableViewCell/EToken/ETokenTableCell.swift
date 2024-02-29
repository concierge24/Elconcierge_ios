//
//  ETokenTableCell.swift
//  Buraq24
//
//  Created by MANINDER on 29/08/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit

class ETokenTableCell: UITableViewCell {
    //MARK:- Outlets
    @IBOutlet var lbltotalOffersAvailable: UILabel!
    @IBOutlet var lblBrandName: UILabel!
    @IBOutlet var imgViewBrand: UIImageView!
    @IBOutlet var collectionViewTokens: UICollectionView!
    
    //MARK:- Properties
    var items : [ETokenModel]?
    var collectionDataSource : CollectionViewDataSourceCab?
    var eTokenSelected : ETokenSelected?
    

    //MARK:- View Life Cycle
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
    
    func assignData(model :Brand) {
        
        lblBrandName.text = model.brandName
        imgViewBrand.sd_setImage(with: model.imageURL, completed: nil)
        
        guard let totalBrands = model.etokensCount else{return}
        
        lbltotalOffersAvailable.text = String(totalBrands) + " offers available"
        configureCollectionView()
    }
}

extension ETokenTableCell {
    func configureCollectionView() {
        
         let identifier = R.reuseIdentifier.eTokenToBuyCell.identifier
         let cellNib = UINib.init(nibName:identifier, bundle: Bundle.main)
         collectionViewTokens.register(cellNib, forCellWithReuseIdentifier: identifier)
        let configureCellBlock : ListCellConfigureBlockCab = { (cell, item, indexPath) in
            if  let cell = cell as? ETokenToBuyCell ,let model = item as? ETokenModel {
                cell.assignData(data: model)
                cell.eTokenSelectedBlock = {[weak self] (etoken : ETokenModel) in
                    guard let callback = self?.eTokenSelected else{return}
                    callback(etoken)
                }
            }
        }
        
        collectionDataSource =  CollectionViewDataSourceCab(items: items , collectionView: collectionViewTokens, cellIdentifier: identifier, cellHeight: collectionViewTokens.frame.size.height, cellWidth: 140, configureCellBlock: configureCellBlock )
        collectionViewTokens.delegate = collectionDataSource
        collectionViewTokens.dataSource = collectionDataSource
        collectionViewTokens.reloadData()
    }
}

