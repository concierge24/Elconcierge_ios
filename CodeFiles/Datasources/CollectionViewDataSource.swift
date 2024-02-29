//
//  CollectionViewDataSource.swift
//  Whatashadi
//
//  Created by Night Reaper on 29/10/15.
//  Copyright © 2015 Gagan. All rights reserved.
//


import UIKit

typealias WillBeginDragginBlock = (_ scrollView : UIScrollView) -> ()
typealias DidEndDraggingBlock = (_ scrollView : UIScrollView) -> ()
typealias WillDisplayCellBlock = (_ cell : UICollectionViewCell) -> ()
typealias DidEndDeceleratingBlock = (_ scrollView : UIScrollView) -> ()

class CollectionViewDataSource: NSObject  {
    
    var items : Array<Any>?
    var cellIdentifier : String?
    var headerIdentifier : String?
    var tableView  : UICollectionView?
    var cellHeight : CGFloat = 0.0
    var cellWidth : CGFloat = 0.0
    var isServiceTypeCollectionView : Bool = false
    var isFilterProductListing : Bool?
    var isProductListing : Bool?

    var configureCellBlock : ListCellConfigureBlock?
    var aRowSelectedListener : DidSelectedRow?
    var willBeginDraggingListener : WillBeginDragginBlock?
    var didEndDraggingListener : DidEndDraggingBlock?
    var willDisplayCellListener : WillDisplayCellBlock?
    var didEndDeceleratingBlock : DidEndDeceleratingBlock?
    var scrollViewListener : DidEndDeceleratingBlock?
    var blockSizeCell : BlockSizeForCollectionCell?

    init (items : Array<Any>?  , tableView : UICollectionView? , cellIdentifier : String? , headerIdentifier : String? , cellHeight : CGFloat , cellWidth : CGFloat  , configureCellBlock : @escaping ListCellConfigureBlock  , aRowSelectedListener : @escaping DidSelectedRow, scrollViewListener: DidEndDeceleratingBlock? = nil)  {
        
        self.tableView = tableView
        self.items = items
        self.cellIdentifier = cellIdentifier
        
        self.headerIdentifier = headerIdentifier
        self.cellWidth = cellWidth
        self.cellHeight = cellHeight
        self.configureCellBlock = configureCellBlock
        self.aRowSelectedListener = aRowSelectedListener
        self.scrollViewListener = scrollViewListener
        
    }
    
    override init() {
        super.init()
    }
    
}

extension CollectionViewDataSource : UICollectionViewDelegate , UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let identifier = cellIdentifier else{
            fatalError("Cell identifier not provided")
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier ,
                                                      for: indexPath) as UICollectionViewCell
        if isFilterProductListing == true{
            
            if let block = self.configureCellBlock , let item: Any = isProductListing == false ? (self.items?[indexPath.section] as? DetailedSubCategories)?.arrProducts?[indexPath.row] : self.items?[indexPath.row] as? ProductF{
                block(cell , item)
            }
        }
        else{
            if let block = self.configureCellBlock , let item: Any = self.items?[indexPath.row]{
                block(cell , item)
            }
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        if self.isFilterProductListing == true{
            
            if items?.count ?? 0 > 0{
                
                if  let item: Any = isProductListing == false ? (self.items?[section] as? DetailedSubCategories)?.arrProducts : self.items{
                    return (item as AnyObject).count
                }
            }
            else{
                 return 0
            }
            
        }
      
        return self.items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let block = self.aRowSelectedListener{
            block(indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let block = willDisplayCellListener else { return }
        block(cell)
    }

}


extension CollectionViewDataSource : UICollectionViewDelegateFlowLayout{
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let block = blockSizeCell else { return CGSize(width : cellWidth, height :cellHeight) }
        return block(indexPath)
        
//        if isServiceTypeCollectionView && indexPath.row == (items?.count ?? 0) - 1  {
//            let layout = collectionViewLayout as! UICollectionViewFlowLayout
//          // layout.scrollDirection = .horizontal
//            switch (items?.count ?? 0) % 3 {
//            case 1 :
//                return CGSize(width : (collectionView.bounds.width) - (layout.sectionInset.left + layout.sectionInset.right ) , height : cellHeight)
//            case 2 :
//                  return CGSize(width : cellWidth, height :cellHeight)
//               // return CGSize(width : (cellWidth * 2) + LowPadding , height : cellHeight)
//            default:
//                return CGSize(width : cellWidth, height : cellHeight)
//
//            }
//        }
        
        
    }
}

extension CollectionViewDataSource : UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard let block = willBeginDraggingListener else { return }
        block(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard let block = didEndDraggingListener else { return }
        block(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let block = didEndDeceleratingBlock else { return }
        block(scrollView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let block = scrollViewListener else { return }
        block(scrollView)
    }
}

/*
extension CollectionViewDataSource : UIScrollViewDelegate{
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        guard let layout = self.tableView?.collectionViewLayout as? UICollectionViewFlowLayout where scrollView.contentOffset.y < 0 else{return}
        let cellWithIncludingSpace = tableViewRowWidth + layout.minimumLineSpacing
        var offset = targetContentOffset.memory
        let index = round((scrollView.contentInset.left + offset.x)/cellWithIncludingSpace)
        offset = CGPointMake(index * cellWithIncludingSpace  - scrollView.contentInset.left - (2 * layout.minimumLineSpacing) , -scrollView.contentInset.top)
        targetContentOffset.memory = offset        
    }
    
}
 */
