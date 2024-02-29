//
//  HomeProductParentCell.swift
//  Clikat
//
//  Created by Night Reaper on 19/04/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import EZSwiftExtensions

protocol HomeProductCollectionViewDelegate : class {
    func collectionViewItemClicked(atIndexPath indexPath : IndexPath , type : Any?)
}

class HomeProductParentCell: ThemeTableCell {
    
    var isRecomented: Bool = false
    @IBOutlet var lblSubTitle: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    weak var delegate : HomeProductCollectionViewDelegate?
    
    var cellIdentifier : String?
    
    var collectionViewDataSource = CollectionViewDataSource(){
        didSet{
            collectionView.dataSource = collectionViewDataSource
            collectionView.delegate = collectionViewDataSource
        }
    }
    var products : [ProductF]? {
        didSet{
            updateUI(withContent: products)
        }
    }

    var suppliers : [Supplier]? {
        didSet{
            updateUI(withContent: suppliers)
        }
    }
    
    private func updateUI(withContent content : [AnyObject]?){
        // Reload Collection View
        //        let width = GDataSingleton.sharedInstance.app_type == 1 ? self.bounds.width * 0.45 :  self.bounds.width/2-20
        //        let height =  GDataSingleton.sharedInstance.app_type == 1 ? floor(self.bounds.width * 0.45) : 210
        let width = 152.0//((ScreenSize.SCREEN_WIDTH-16-32)/2)
        let height = (isRecomented ? 48.0 : 68.0)+8+8+(width*3/4)
        //  GDataSingleton.sharedInstance.app_type == 1 ? floor(self.bounds.width * 0.45) : 210
        
        
        collectionViewDataSource = CollectionViewDataSource(
            items: content,
            tableView: collectionView,
            cellIdentifier: CellIdentifiers.HomeProductCell,
            headerIdentifier: nil,
            cellHeight: CGFloat(height),
            cellWidth: CGFloat(width),
            configureCellBlock: {
                (cell, item) in
                (cell as? HomeProductCell)?.isHideStepper = true
                
                if let item = item as? Supplier {
                    (cell as? HomeProductCell)?.supplier = item
                } else {
                    (cell as? HomeProductCell)?.product = item as? ProductF
                }
                
        }, aRowSelectedListener: {
            [weak self] (indexPath) in
            guard let self = self else { return }
            
            ez.runThisInMainThread {
                [weak self] in
                guard let self = self else { return }
                self.delegate?.collectionViewItemClicked(atIndexPath: indexPath, type: self.collectionViewDataSource.items?[indexPath.row])
            }
            //                self.delegate?.collectionViewItemClicked(atIndexPath: indexPath, type: self.suppliers?[indexPath.row])
            
        })
        collectionView.reloadData()
    }
}
