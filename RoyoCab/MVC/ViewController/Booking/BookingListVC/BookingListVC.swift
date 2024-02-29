//
//  BookingListVC.swift
//  Buraq24
//
//  Created by MANINDER on 07/09/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit

class BookingListVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet var collectionViewBookings: UICollectionView!
    
    //MARK:- Properties
    var collectionViewDataSource : CollectionViewDataSourceCab?
    var arrOrder : [OrderCab]?
    
    //MARK:- View life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- Functions
    
    private func configureCollectionView() {
        
        let configureCellBlock : ListCellConfigureBlockCab = {(cell, item, indexPath) in
            if let cell = cell as? BookingCell , let model = item as? OrderCab {
                cell.assignData(model: model)
            }
        }
        
     
        let height = collectionViewBookings.frame.size.width*62/100
        
        collectionViewDataSource =  CollectionViewDataSourceCab(items: arrOrder, collectionView: collectionViewBookings, cellIdentifier: R.reuseIdentifier.bookingCell.identifier, cellHeight: height, cellWidth: collectionViewBookings.frame.size.width , configureCellBlock: configureCellBlock )
        collectionViewBookings.delegate = collectionViewDataSource
        collectionViewBookings.dataSource = collectionViewDataSource
        collectionViewBookings.reloadData()
    }
}


