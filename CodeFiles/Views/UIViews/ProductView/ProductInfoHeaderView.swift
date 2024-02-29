//
//  ProductInfoHeaderView.swift
//  Clikat
//
//  Created by cbl73 on 5/6/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import SKPhotoBrowser
import AMRatingControl
import Cosmos

protocol ImageClickListenerDelegate {
    
    func imageCliked(atIndexPath indexPath : IndexPath , cell : UICollectionViewCell?, images : [SKPhoto])
    
}
extension UIImage {
    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
}

typealias EmptyBlock = () -> ()

class ProductInfoHeaderView: UIView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var constWidth: NSLayoutConstraint! {
        didSet {
            constWidth.constant = ScreenSize.SCREEN_WIDTH
        }
    }
    
    @IBOutlet weak var pgControl: UIPageControl! {
        didSet {//Nitin
            pgControl.currentPageIndicatorTintColor = SKAppType.type.color
        }
    }
    
    var totalPage: Int = 0 {
        didSet {
            pgControl.isHidden = totalPage < 2
            pgControl.numberOfPages = totalPage
        }
    }
    
    var currentPage: Int = 0 {
        didSet {
            pgControl.currentPage = currentPage
        }
    }

    @IBOutlet weak var lblTotalReviews: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSupplierName: UILabel!
    @IBOutlet weak var lblPrice: UILabel! {
        didSet {
            lblPrice?.textColor = SKAppType.type.color
        }
    }
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    

    @IBOutlet weak var ratingBgView: CosmosView!{
        didSet{
            rateControl?.rating = 0
        }
    }
    
    @IBOutlet weak var btnFav: DOFavoriteButton!
    
    
    var imageDelegate : ImageClickListenerDelegate?
    var favPressed: EmptyBlock?
    
    var collectionDataSource = ProductDetailHeaderDataSource()
    var view: UIView!
    var rateControl: AMRatingControl!
    var cellHeight: CGFloat = 0
    var productRate : Int = 0 {
        didSet {
            
//            defer {
//                if !ratingBgView.subviews.isEmpty {
//
//                    ratingBgView.subviews.forEach({ $0.removeFromSuperview() })
//                    rateControl = nil
//                }
//                let imge = UIImage(asset : Asset.Ic_star_small_yellow)?.maskWithColor(color: getColor(rating: productRate))
//                rateControl = AMRatingControl(location: CGPoint(x: 0,y: 0), empty: UIImage(asset : Asset.Ic_star_small_grey), solidImage: imge, andMaxRating: 5)
//
////                rateControl = AMRatingControl(location: CGPoint(x: 0,y: 0), empty: UIColor.gray, solidColor: getColor(rating: productRate), andMaxRating: 5)
//                rateControl.frame = ratingBgView.bounds
//                rateControl.isUserInteractionEnabled = false
//                rateControl?.rating = productRate
//                rateControl?.starWidthAndHeight = 12
//                ratingBgView.addSubview(rateControl)
//
////                ratingBgView.backgroundColor = .red
//            }
//            rateControl = AMRatingControl(location: CGPoint(x: 0,y: 0), empty: UIImage(asset : Asset.Ic_star_small_grey), solidImage: UIImage(asset : Asset.Ic_star_small_yellow), andMaxRating: 5)
            
            ratingBgView?.rating = Double(productRate)

        }
    }
    
    var product : ProductF?{
        didSet {
            productRate = /product?.averageRating
            
            lblTotalReviews?.text = UtilityFunctions.appendOptionalStrings(withArray: ["0" , L10n.Reviews.string])
            lblName.text = product?.name
            let prefix = TerminologyKeys.supplier.localizedValue() as? String ?? ""
            lblSupplierName.text = "\("\(prefix):") \(/(product?.supplierName))"
            lblSupplierName.isHidden = AppSettings.shared.isSingleVendor
            
            if let _ = product?.brandname{
                brandLabel.text = "\(L10n.by.string) \(/(product?.brandname))"
            }
            else{
                brandLabel.isHidden = true
            }
            
            if let _ = GDataSingleton.sharedInstance.loggedInUser?.id {
                btnFav?.isHidden = /AppSettings.shared.appThemeData?.is_product_wishlist != "1"
            } else{
                btnFav?.isHidden = true
            }
            btnFav.isSelected = /product?.isFavourite
            // "\(L10n.by.string) \(/(product?.supplierName))"
            
            updatePrice()
            lblDiscount.isHidden = !(/product?.isOffer)
            
            if !lblDiscount.isHidden {
                
                let offerPrice = (/product?.actualPrice).addCurrencyLocale
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: offerPrice)
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                lblDiscount?.attributedText = attributeString
            }
            
            configureCollectionView()
        }
    }
    
    func updatePrice() {
        product?.getPriceLabel(block: {
            [weak self] (price) in
            guard let self = self else { return }
            self.lblPrice?.text = price
        })
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        xibSetup()
        collectionView.register(UINib(nibName: CellIdentifiers.SupplierInfoHeaderCollectionCell,bundle: nil), forCellWithReuseIdentifier: CellIdentifiers.SupplierInfoHeaderCollectionCell)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.reloadData()
//        if cellHeight != collectionView.frame.size.height {
//            cellHeight = collectionView.frame.size.height
//            collectionView.reloadData()
//        }
    }
    
    func xibSetup() {
        
        do{
            try view = loadViewFromNib(withIdentifier: CellIdentifiers.ProductInfoHeaderView)
            view.frame = bounds
//            view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
            NSLayoutConstraint.activate([

                      view.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
                      view.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
                      view.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
                      view.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
                      ])
        }
        catch let exception{
            print(exception)
        }
        
        
    }
    
    @IBAction func addTofav(_ sender: Any) {
        favPressed?()
    }
    
    func configureCollectionView(){
        totalPage = /product?.images?.count
        
        guard let images = product?.images else{
            return
        }
        cellHeight = ScreenSize.SCREEN_WIDTH * (3.0/4.0)//collectionView.frame.size.height
        collectionDataSource = ProductDetailHeaderDataSource(items: images, tableView: collectionView, cellIdentifier: CellIdentifiers.SupplierInfoHeaderCollectionCell, headerIdentifier: nil, cellHeight: collectionView.frame.size.height, cellWidth: ScreenSize.SCREEN_WIDTH, configureCellBlock: {
            (cell, item) in
            
            guard let c = cell as? SupplierInfoHeaderCollectionCell  else{ return }
            c.imageViewCover.loadImage(thumbnail: (item as? String), original: nil, modeType: .scaleAspectFit)
            
        }, aRowSelectedListener: {
            [weak self] (indexPath) in
            guard let self = self else { return }
            
            self.imageDelegate?.imageCliked(atIndexPath: indexPath , cell: self.collectionView?.cellForItem(at: indexPath) ,images: self.imagesToSKPhotoArray(withImages: images, caption: self.product?.name) ?? [])
            
        })
        
        collectionDataSource.scrollViewListener = {
            [weak self] scrollView in
            
            let page = Int(scrollView.contentOffset.x/scrollView.frame.width)
            self?.currentPage = page
            
            
        }
        
        collectionView.delegate = collectionDataSource
        collectionView.dataSource = collectionDataSource
    }
}


extension UIView {
    
    func imagesToSKPhotoArray (withImages images : [String] , caption : String?) -> [SKPhoto] {
        
        var skImages : [SKPhoto] = []
        for image in images {
            let photo = SKPhoto.photoWithImageURL(image)
            photo.caption = caption ?? ""
            photo.shouldCachePhotoURLImage = false // you can use image cache by true(NSCache)
            skImages.append(photo)
        }
        return skImages
    }
    
}

class ProductDetailHeaderDataSource : CollectionViewDataSource {
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: collectionView.frame.height)
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
}
