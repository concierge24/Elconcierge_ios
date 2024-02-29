//
//  BannerParentCell.swift
//  Clikat
//
//  Created by Night Reaper on 19/04/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import RCPageControl

typealias BannerClickListener = (_ banner : Banner?) -> ()

class BannerParentCell: ThemeTableCell {
    
    @IBOutlet var constLeading: NSLayoutConstraint!
    @IBOutlet var constTrailing: NSLayoutConstraint!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var pgControl: UIPageControl?
    @IBOutlet weak var imgColorBG: UIImageView? {
        didSet {
//            imgColorBG?.isHidden = !(SKAppType.type == .home)
//            imgColorBG?.isHidden = !(SKAppType.type == .home || SKAppType.type == .gym)
        }
    }

    var totalPage: Int = 0 {
        didSet {
            pgControl?.pageIndicatorTintColor = UIColor.lightGray
            pgControl?.currentPageIndicatorTintColor = UIColor.white
            pgControl?.isHidden = true//totalPage < 2
            pgControl?.numberOfPages = totalPage > 5 ? 5 : 0
        }
    }
    
    var currentPage: Int = 0 {
        didSet {
            pgControl?.currentPage = currentPage > 5 ? 5 : 0
            pageControl?.currentPage = currentPage > 5 ? 5 : 0
        }
    }

    var pageControl : RCPageControl?
    
    var collectionViewDataSource = CollectionViewDataSource(){
        didSet{
            collectionView.dataSource = collectionViewDataSource
            collectionView.delegate = collectionViewDataSource
            
            //collectionView.reloadData()
        }
    }
    
    var banners : [Banner]? {
        didSet{
            totalPage = /banners?.count
            updateUI()
        }
    }
    
    var bannerClickedBlock : BannerClickListener?
    var timer = Timer()
    var fullBanner = APIConstants.defaultAgentCode == "yummy_0122"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func addShimmmer(cell:BannerCell )  {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor,UIColor.black.cgColor,UIColor.clear.cgColor]
        gradientLayer.locations = [0,0.5,1]
        gradientLayer.frame = cell.frame
        //gradientLayer.frame = CGRect(x: viewShimmer.frame.x, y: viewShimmer.frame.y, w: 10, h: viewShimmer.frame.height)
        //let angle = 45*CGFloat.pi/180
        //  gradientLayer.transform = CATransform3DMakeRotation(angle, 0, 0, 1)
        
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.fromValue = -cell.frame.width
        animation.toValue = cell.frame.width
        animation.repeatCount = Float.infinity
        animation.duration = 1.5
        gradientLayer.add(animation, forKey: "transform.translation.x")
        self.layer.mask = gradientLayer
    }
    
    override func layoutSubviews() {
           super.layoutSubviews()
           UIChanges()
       }
       
       func UIChanges() {
        if DeliveryType.shared == .delivery {
            constLeading.constant = fullBanner ? 0 : 8
                   constTrailing.constant = fullBanner ? 0 : 8
        }
        else {
            constLeading.constant = 8
                   constTrailing.constant = 8
        }

       }
    
    private func updateUI(){
        // Reload Collection View
        pgControl?.numberOfPages = (banners?.count ?? 0) > 5 ? 5 : banners?.count ?? 0
        pageControl?.numberOfPages = (banners?.count ?? 0) > 5 ? 5 : banners?.count ?? 0
        pageControl?.isHidden = /banners?.count == 0
      
        var height = (ScreenSize.SCREEN_WIDTH - 48)/2
        var width = height
        var startTimer = false
        if DeliveryType.shared == .delivery && !AppSettings.shared.halfWidthBanner {
            height = (ScreenSize.SCREEN_WIDTH - (fullBanner ? 0 : 16))/2
            width = (ScreenSize.SCREEN_WIDTH - (fullBanner ? 0 : 16))
            startTimer = true
        }
        
        UIChanges()
        self.layoutIfNeeded()
        collectionView.reloadData()
        collectionView.contentOffset = CGPoint.zero
        totalPage = /banners?.count
        
        collectionViewDataSource = CollectionViewDataSource(
            items: banners,
            tableView: collectionView,
            cellIdentifier: CellIdentifiers.BannerCell,
            headerIdentifier: nil, cellHeight: height,
            cellWidth: width
            , configureCellBlock: {
                (cell, item) in
                
            (cell as? BannerCell)?.banner = item as? Banner
                
        }, aRowSelectedListener: { [weak self] (indexPath) in
            guard let block = self?.bannerClickedBlock, let objBanner = self?.banners?[indexPath.row], let _ = objBanner.category_id else { return }
            block(objBanner)
        })
        
        collectionViewDataSource.scrollViewListener = {
            [weak self] scrollView in
            
            let page = Int(scrollView.contentOffset.x/scrollView.frame.width)
            self?.currentPage = page
            
            
        }
        if startTimer {
            addTimer()
        }
        else {
            timer.invalidate()
        }
    }
    
    deinit {
        print("Timer removed")
        timer.invalidate()
    }
    
}

protocol StringType { var get: String { get } }
extension String: StringType { var get: String { return self } }

extension Optional where Wrapped: StringType{
    func unwrap() -> String {
        return self?.get ?? ""
    }
}
//MARK: - Automatic Scrolling collectionView
extension BannerParentCell {
    
    func addTimer(){
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(BannerParentCell.nextPage), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
    }
    
    func resetIndexpath() -> IndexPath{
        let currentIndexPath = collectionView.indexPathsForVisibleItems.last
        let currentIndexpathReset = IndexPath(row: currentIndexPath?.item ?? 0, section: 0)
        
        //        collectionView.scrollToItemAtIndexPath(currentIndexpathReset, atScrollPosition: .CenteredHorizontally, animated: true)
        return currentIndexpathReset
    }
    
    @objc func nextPage(){
        if self.banners?.count == 0 {
            return
        }
        let currentIndexPathReset = resetIndexpath()
        
        var nextItem = currentIndexPathReset.item + 1
        var nextSection = currentIndexPathReset.section
        if (nextItem == self.banners?.count) {
            nextItem = 0
            nextSection = 0
        }
        let nextIndexPath = IndexPath(row: nextItem, section: nextSection)
        currentPage = nextItem

        collectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
    }
    
    func removeTimer(){
        timer.invalidate()
    }
    
}
