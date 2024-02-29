//
//  InfiniteCollectionViewDataSource.swift
//  Buraq24
//
//  Created by MANINDER on 07/08/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit

class InfiniteCollectionViewDataSource: NSObject {
    var items: Int = 99999
    var cellHeight: CGFloat = 0.0
    var cellWidth : CGFloat = 0.0
    var cellIdentifier  : String?
    var headerIdentifier: String?
    var collectionView  : UICollectionView?
    var configureCellBlock  : ListCellConfigureBlockCab?
    var willDisplay         : WillDisplay?
    var centreCellListener : DidCellIndexInCenter?
 
    
    
    init (items: Int  , collectionView: UICollectionView? , cellIdentifier: String? , headerIdentifier: String? , cellHeight: CGFloat , cellWidth: CGFloat , configureCellBlock: ListCellConfigureBlockCab? , willDisplayCell: WillDisplay?, centralCellListener : DidCellIndexInCenter?) {
        
        self.collectionView = collectionView
        self.items = items
        self.cellIdentifier = cellIdentifier
        self.headerIdentifier = headerIdentifier
        self.cellWidth  = cellWidth
        self.cellHeight = cellHeight
        self.configureCellBlock     = configureCellBlock
        self.willDisplay            = willDisplayCell
       self.centreCellListener = centralCellListener
        
    }
    
    override init() {
        super.init()
    }
}

extension InfiniteCollectionViewDataSource: UICollectionViewDelegate , UICollectionViewDataSource
{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let identifier = cellIdentifier else{
            fatalError("Cell identifier not provided")
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as UICollectionViewCell
        if let block = self.configureCellBlock {
            block(cell , nil , indexPath)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if let block = self.centreCellListener {
            block(indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let block = willDisplay {
            block(indexPath)
        }
    }
    
 
}


extension InfiniteCollectionViewDataSource: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}



