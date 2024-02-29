//
//  HomeScreenCurrentOrdersView.swift
//  Sneni
//
//  Created by Sandeep Kumar on 25/07/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class HomeScreenCurrentOrdersView: UIView {

    //MARK:- ======== Outlets ========
    @IBOutlet weak var pageControl: UIPageControl? {
        didSet {
//            pageControl?.currentPageIndicatorTintColor = SKAppType.type.color
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            
        }
    }
    
    //MARK:- ======== Variables ========
    var blockOpenOrderDetail: ((OrderDetails) -> ())?
    var collectionViewDataSource: SKCollectionViewDataSource?
    
    var items: [OrderDetails] = [] {
        didSet {
            
            collectionViewDataSource?.reload(items: items)
            pageControl?.numberOfPages = items.count
        }
    }
    
    var currentIndex: Int = 0 {
        didSet {
            pageControl?.currentPage = currentIndex
        }
    }
    
    //MARK:- ======== LifeCycle ========
    override func awakeFromNib() {
        super.awakeFromNib()
        initalSetup()
    }
    
    //MARK:- ======== Actions ========
    @IBAction func didTapSubmit(_ sender: Any) {
        
    }
    
    //MARK:- ======== Functions ========
    func initalSetup() {
        backgroundColor = SKAppType.type.color
        configureCollectionView()
    }

}

//MARK:- ======== Handle Table View  ========
extension HomeScreenCurrentOrdersView {
    
    func configureCollectionView() {
        
        let identifier = HomeCurrentOrderCollectionCell.identifier
        collectionView.registerCells(nibNames: [identifier])
        
        collectionViewDataSource = SKCollectionViewDataSource(
            collectionView: collectionView,
            cellIdentifier: identifier,
            cellHeight: collectionView.bounds.height,
            cellWidth: UIScreen.main.bounds.width-(frame.minX*2))

        collectionViewDataSource?.configureCellBlock = {
            (index, cell, item) in
            
            if let cell = cell as? HomeCurrentOrderCollectionCell,
                let model = item as? OrderDetails
            {
                cell.objModel = model
            }
        }
        
        collectionViewDataSource?.aRowSelectedListener = {
            [weak self] (indexpath, cell) in
            guard let self = self else { return }
            
            self.blockOpenOrderDetail?(self.items[indexpath.row])

        }
        
        collectionViewDataSource?.scrollViewListener = {
            [weak self] (scrollView) in // for swipe

            guard let self = self else { return }
            self.currentIndex = Int(scrollView.contentOffset.x/scrollView.frame.width)
        }
        
        collectionViewDataSource?.reload(items: items)
    }
}

