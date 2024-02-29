//
//  DoctorCategoryParentCell.swift
//  Sneni
//
//  Created by Daman on 18/04/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit

class DoctorCategoryParentCell: UITableViewCell {

    @IBOutlet var collectionView: UICollectionView!
    
    var collectionViewDataSource = CollectionViewDataSource(){
        didSet{
            collectionView.dataSource = collectionViewDataSource
            collectionView.delegate = collectionViewDataSource
        }
    }
    var itemClickedBlock: ItemClickedBlock?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(_ arr: [ServiceType]?){
       
        let height = collectionView.frame.size.height
        let width = (UIScreen.main.bounds.width - 100)/3

        collectionViewDataSource = CollectionViewDataSource(
            items: arr,
            tableView: collectionView,
            cellIdentifier: DoctorCategoryCollectionCell.identifier,
            headerIdentifier: nil,
            cellHeight: CGFloat(height),
            cellWidth: CGFloat(width),
            configureCellBlock: {
                (cell, item) in
                
                (cell as? DoctorCategoryCollectionCell)?.type = item as? ServiceType
                
        }, aRowSelectedListener: {
            [weak self] (indexPath) in
            guard let self = self else { return }
            if let item = self.collectionViewDataSource.items?[indexPath.row] {
                self.itemClickedBlock?(item)
            }
        })
        collectionView.reloadData()
    }
}
