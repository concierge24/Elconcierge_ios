//
//  CollectionViewDataSource.swift
//  SafeCity
//
//  Created by Aseem 13 on 29/10/15.
//  Copyright © 2015 Taran. All rights reserved.
//


import UIKit

//typealias ScrollViewScrolled = (UIScrollView) -> ()
typealias WillDisplay = (_ indexPath: IndexPath) -> ()
typealias EndDisplay = (_ indexPath: IndexPath,_ cell:UICollectionViewCell) -> ()

class CollectionViewDataSourceCab: NSObject  {
  
  var items: Array<Any>?
    
  var cellHeight: CGFloat = 0.0
  var cellWidth : CGFloat = 0.0
    
  var cellIdentifier  : String?
  var headerIdentifier: String?
    
  var collectionView  : UICollectionView?
    
  var scrollViewListener  : ScrollViewScrolled?
  var configureCellBlock  : ListCellConfigureBlockCab?
  var aRowSelectedListener: DidSelectedRowCab?
  var willDisplay         : WillDisplay?
  var endDisplay         : EndDisplay?
  var centreCellListener : DidCellIndexInCenter?
  
  
  init (items: Array<Any>?  , collectionView: UICollectionView? , cellIdentifier: String? , headerIdentifier: String? = nil , cellHeight: CGFloat , cellWidth: CGFloat , configureCellBlock: ListCellConfigureBlockCab? , aRowSelectedListener:  DidSelectedRowCab? = nil , willDisplayCell: WillDisplay? = nil , scrollViewDelegate: ScrollViewScrolled? = nil)  {
    
    self.collectionView = collectionView
    self.items = items
    self.cellIdentifier = cellIdentifier
    self.headerIdentifier = headerIdentifier
    self.cellWidth  = cellWidth
    self.cellHeight = cellHeight
    self.configureCellBlock     = configureCellBlock
    self.aRowSelectedListener   = aRowSelectedListener
    self.willDisplay            = willDisplayCell
    self.scrollViewListener     = scrollViewDelegate
    
  }
  
  override init() {
    super.init()
  }
}

extension CollectionViewDataSourceCab: UICollectionViewDelegate , UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let identifier = cellIdentifier else {
      fatalError("Cell identifier not provided")
    }
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as UICollectionViewCell
    if let block = self.configureCellBlock , let item: Any = self.items?[indexPath.row] {
     
        block(cell , item , indexPath)
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.items?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
  {
    
    if let block = self.aRowSelectedListener,let cell = collectionView.cellForItem(at: indexPath), let item: Any = self.items?[(indexPath).row] {
        block(indexPath , cell , item)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if let block = willDisplay {
      block(indexPath)
    }
  }
    
  
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let block = endDisplay {
          block(indexPath,cell)
        }
        
    }
    
    
  
    //MARK:- ScrollView Delegates
    
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    if let block = self.scrollViewListener {
      block(scrollView)
    }
  }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        snapToCenter()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            snapToCenter()
        }
    }
    func snapToCenter() {
        if let centerIndex =  collectionView?.getVisibleIndexOnScroll() {
            if let block = self.centreCellListener {
                block(centerIndex)
            }
        }
    }
 }
extension CollectionViewDataSourceCab: UICollectionViewDelegateFlowLayout{
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    print(cellHeight)
    return CGSize(width: cellWidth, height: cellHeight)
  }
}

