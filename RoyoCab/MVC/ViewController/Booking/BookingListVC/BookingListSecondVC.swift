//
//  BookingListSecondVC.swift
//  Buraq24
//
//  Created by MANINDER on 07/09/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit

class BookingListSecondVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet var collectionViewUpcoming: UICollectionView!
    
    
    //MARK:- Properties
    var collectionViewDataSource : CollectionViewDataSourceCab?
    var arrOrderUpcoming : [OrderCab]?

   
    //MARK:- View life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- Functions
    
    private  func configureCollectionView() {
        
        let configureCellBlock : ListCellConfigureBlockCab = {(cell, item, indexPath) in
            if let cell = cell as? BookingCell , let model = item as? OrderCab {
                cell.assignData(model: model)
            }
        }
        
        let didSelectBlock : DidSelectedRowCab = { [weak self] (indexPath, cell, item) in
             if let _ = cell as? BookingCell , let item = item as? OrderCab {
                 //self?.delegate?.didTapOnBooking(item, type: .Upcoming)
            }
        }
        
        let height = collectionViewUpcoming.frame.size.width*62/100
        
        collectionViewDataSource =  CollectionViewDataSourceCab(items: arrOrderUpcoming , collectionView: collectionViewUpcoming, cellIdentifier: R.reuseIdentifier.bookingCell.identifier, cellHeight: height, cellWidth: collectionViewUpcoming.frame.size.width , configureCellBlock: configureCellBlock )
        collectionViewDataSource?.aRowSelectedListener = didSelectBlock
        collectionViewUpcoming.delegate = collectionViewDataSource
        collectionViewUpcoming.dataSource = collectionViewDataSource
        collectionViewUpcoming.reloadData()
        
    }
}


