//
//  SupplierInfoHeaderView.swift
//  Clikat
//
//  Created by cblmacmini on 5/3/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class SupplierInfoHeaderView: UIView {
    
    @IBOutlet weak var constraintLeadingImage: NSLayoutConstraint!
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var imageViewSupplier : UIImageView!
    var imageDelegate : ImageClickListenerDelegate?
    
    @IBOutlet weak var pageControl: UIPageControl!{
        didSet{
            pageControl.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            pageControl.isHidden = !AppSettings.shared.isFoodApp
        }
    }
    
    var supplier : Supplier?{
        didSet{
            configureCollectionView()
        }
    }
    
    var collectionDataSource = SupplierInfoHeaderDataSource()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        xibSetup()
        collectionView.register(UINib(nibName: CellIdentifiers.SupplierInfoHeaderCollectionCell,bundle: nil), forCellWithReuseIdentifier: CellIdentifiers.SupplierInfoHeaderCollectionCell)
        
        constraintLeadingImage.constant = AppSettings.shared.isFoodApp ? 16.0 : (UIScreen.main.bounds.width/2.0)-(imageViewSupplier.frame.width/2.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    var view: UIView!
    
    func xibSetup() {
        
        do{
            try view = loadViewFromNib(withIdentifier: CellIdentifiers.SupplierInfoHeaderView)
            view.frame = bounds
            view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
            addSubview(view)
        }
        catch let exception{
            print(exception)
        }
        
        
    }
    
    func configureCollectionView(){
        
        imageViewSupplier.loadImage(thumbnail: supplier?.logo, original: nil)
        //        let pages = supplier?.supplierImages?.count ?? 0
        
        let images = supplier?.supplierImages ?? []
        pageControl?.numberOfPages = images.count
        
        collectionDataSource = SupplierInfoHeaderDataSource(
            items: images,
            tableView: collectionView,
            cellIdentifier: CellIdentifiers.SupplierInfoHeaderCollectionCell,
            headerIdentifier: nil,
            cellHeight: collectionView.frame.size.height,
            cellWidth: ScreenSize.SCREEN_WIDTH,
            configureCellBlock: {
                (cell, item) in
                
                if let cell = cell as? SupplierInfoHeaderCollectionCell,
                    let imageUrl = item as? String
                {
                    cell.imageViewCover.loadImage(thumbnail: imageUrl, original: nil)
                }
                
        }, aRowSelectedListener: {
            [weak self] (indexPath) in
            guard let self = self else { return }
            
            self.imageDelegate?.imageCliked(atIndexPath: indexPath, cell: self.collectionView?.cellForItem(at: indexPath), images: self.imagesToSKPhotoArray(withImages: images, caption: nil) ?? [])
            
        }) { [weak self] (scrollView) in
            guard let self = self else { return }
            
            self.configurePageControl(scrollView: scrollView)
        }
//        collectionDataSource = SupplierInfoHeaderDataSource(
//            items: images,
//            tableView: collectionView,
//            cellIdentifier: CellIdentifiers.SupplierInfoHeaderCollectionCell,
//            headerIdentifier: nil,
//            cellHeight: collectionView.frame.size.height,
//            cellWidth: ScreenSize.SCREEN_WIDTH,
//            configureCellBlock: {
//                (cell, item) in
//
//                if let cell = cell as? SupplierInfoHeaderCollectionCell,
//                    let imageUrl = item as? String
//                {
//                    cell.imageViewCover.yy_setImage(with: URL(string: imageUrl), options: .setImageWithFadeAnimation)
//                }
//
//        }, aRowSelectedListener: {
//            [weak self] (indexPath) in
//            guard let self = self else { return }
//
//            self.imageDelegate?.imageCliked(atIndexPath: indexPath, cell: self.collectionView?.cellForItem(at: indexPath), images: self.imagesToSKPhotoArray(withImages: images, caption: nil) ?? [])
//
//            }) { [weak self] (scrollView) in
//                guard let self = self else { return }
//
//                self.configurePageControl(scrollView: scrollView)
//        }
        
        collectionView.delegate = collectionDataSource
        collectionView.dataSource = collectionDataSource
    }
    
    @IBAction func actionBack(_ sender: AnyObject) {
        ez.topMostVC?.popVC()
    }
}

extension SupplierInfoHeaderView {
    
    func configurePageControl(scrollView : UIScrollView){
        
        let page = Int(collectionView.contentOffset.x/collectionView.frame.width)
        
//        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
//        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
//        let visibleIndexPath = collectionView.indexPathForItem(at: visiblePoint)
        pageControl.currentPage = page
    }
}

class SupplierInfoHeaderDataSource: CollectionViewDataSource {
    
    
    
//    init(items : Array<Any>?  , tableView : UICollectionView? , cellIdentifier : String? , headerIdentifier : String? , cellHeight : CGFloat , cellWidth : CGFloat  , configureCellBlock : @escaping ListCellConfigureBlock  , aRowSelectedListener : @escaping DidSelectedRow,scrollViewListener : DidEndDeceleratingBlock?) {
//
//        super.init(items: items, tableView: tableView, cellIdentifier: cellIdentifier, headerIdentifier: headerIdentifier, cellHeight: cellHeight, cellWidth: cellWidth, configureCellBlock: configureCellBlock, aRowSelectedListener: aRowSelectedListener, scrollViewListener: scrollViewListener)
//
//
//    }
//    override init() {
//        super.init()
//    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: cellWidth, height: collectionView.frame.height)
    }
    
    
    
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        guard let block = scrollViewListener else { return }
//        block(scrollView)
//    }
}
