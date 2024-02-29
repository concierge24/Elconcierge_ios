//
//  PorductVariantBannerTblCell.swift
//  Sneni
//
//  Created by MAc_mini on 23/02/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit
import RCPageControl
class PorductVariantBannerTblCell: UITableViewCell {
    
    @IBOutlet var collectionView: UICollectionView!
    var collectionViewDataSource = CollectionViewDataSource(){
        didSet{
            collectionView.dataSource = collectionViewDataSource
            collectionView.delegate = collectionViewDataSource
        }
    }
    
    
    var pageControl : RCPageControl?
    
    var banners : [Banner]?{
        didSet{
            updateUI()
        }
    }
    
    private func updateUI(){
        // Reload Collection View
        
        
        pageControl?.numberOfPages =
            
            (banners?.count ?? 0) > 5 ? 5 : banners?.count ?? 0
        pageControl?.isHidden = (banners?.count ?? 0) > 5 ? true : false
        let width = bounds.width
        let height = floor(width * 0.6)
        
        
        collectionViewDataSource = CollectionViewDataSource(items: banners, tableView: collectionView, cellIdentifier: CellIdentifiers.BannerCell , headerIdentifier: nil, cellHeight: height , cellWidth: width , configureCellBlock: {
            (cell, item) in
            
            
            
            (cell as? BannerCell)?.banner = item as? Banner
        }, aRowSelectedListener: { [weak self] (indexPath) in
//            guard let block = self?.bannerClickedBlock else { return }
//            block(self?.banners?[indexPath.row])
        })
        
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
