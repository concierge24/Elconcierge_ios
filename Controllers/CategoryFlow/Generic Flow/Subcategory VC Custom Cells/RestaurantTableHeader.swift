//
//  myView.swift
//  testing
//
//  Created by Apple on 04/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class RestaurantTableHeader: UIView {
    
    //MARK:- IBOutlet
    @IBOutlet weak var buttonBack: ThemeButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblClosed: UILabel!{
        didSet{
            if let term = TerminologyKeys.unserviceable.localizedValue() as? String{
                self.lblClosed?.text = term
            }else{
                self.lblClosed?.text = "Unserviceable".localized()
            }
        }
    }
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var imgTitle: UIImageView!
    @IBOutlet weak var imgRating: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!{
        didSet{
            pageControl.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            pageControl.isHidden = !AppSettings.shared.isFoodApp
        }
    }
    @IBOutlet weak var btnManu: UIButton! {
        didSet {
            if APIConstants.defaultAgentCode == "yummy_0122" {
                btnManu.isHidden = false
            }
            btnManu.setBackgroundColor(SKAppType.type.color, forState: .normal)
           // btnManu.isUserInteractionEnabled = false
            if let term = TerminologyKeys.catalogue.localizedValue() as? String{
                btnManu.setTitle(term, for: .normal)
            }
        }
    }
    @IBOutlet weak var lblBlank: UILabel!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.tintColor = SKAppType.type.color
            searchBar.placeholder = "Search".localized()
            searchBar.setAlignment()
        }
    }
    @IBOutlet weak var favourite_button: UIButton!
    @IBOutlet var viewUploadPrescription: UIView!
    @IBOutlet var constraintImgCenterY: NSLayoutConstraint!
    
    @IBOutlet var lblPrescriptionImageName: ThemeLabel!
    @IBOutlet var btnCancel: UIButton! {
        didSet {
            btnCancel.tintColor = SKAppType.type.color
        }
    }
    @IBAction func removePrescription(_ sender: Any) {
        lblPrescriptionImageName.isHidden = true
        btnCancel.isHidden = true
    }
    @IBOutlet var imgUpload: UIImageView! {
        didSet {
            imgUpload.tintColor = SKAppType.type.elementColor
        }
    }
    @IBOutlet var btnUploadAction: ThemeButton!
    
    
    
    //MARK:- Variables
    var imageDelegate : ImageClickListenerDelegate?
    var collectionDataSource = SupplierInfoHeaderDataSource()
    var supplier : Supplier? {
        didSet{
            
            configureCollectionView()
            lblLocation.text = /supplier?.address
            lblRating.text = "\(/supplier?.rating?.toDouble())"
            lblTitle.text = /supplier?.name
            
//            let imge = UIImage(asset : Asset.Ic_star_small_yellow)?.maskWithColor(color: getColor(rating: /supplier?.rating?.toInt()))
//            imgRating.image = imge
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        commonInit()
        collectionView.register(UINib(nibName: CellIdentifiers.SupplierInfoHeaderCollectionCell,bundle: nil), forCellWithReuseIdentifier: CellIdentifiers.SupplierInfoHeaderCollectionCell)

    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit(){
        Bundle.main.loadNibNamed("RestaurantTableHeader", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        
    }
    
    @IBAction func favourite_buttonAction(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {

            APIManager.sharedInstance.opertationWithRequest(withApi: API.UnFavoriteSupplier(FormatAPIParameters.UnFavoriteSupplier(supplierId: supplier?.id).formatParameters()), completion: { [weak self] (response) in
                
                guard let self = self else { return }
                
                print(response)

                switch response{
                case APIResponse.Success( _):
                    print("Done")
                    
                default : sender.isSelected = !sender.isSelected

                }
            })
            
        } else {

            APIManager.sharedInstance.opertationWithRequest(withApi: API.MarkSupplierFav(FormatAPIParameters.MarkSupplierFavorite(supplierId: supplier?.id).formatParameters()), completion: { [weak self] (response) in

                guard let self = self else { return }

                print(response)
                
                switch response{
                case APIResponse.Success( _):
                    print("Done")
                    
                default : sender.isSelected = !sender.isSelected
                    
                }
            })
        }
        
    }
}

extension RestaurantTableHeader {
    
    func configurePageControl(scrollView : UIScrollView){
        
        let page = Int(collectionView.contentOffset.x/collectionView.frame.width)
        pageControl.currentPage = page
    }
}

extension RestaurantTableHeader {
    
    func configureCollectionView(){
        
        imgTitle.loadImage(thumbnail: supplier?.logo, original: nil)
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
        
        collectionView.delegate = collectionDataSource
        collectionView.dataSource = collectionDataSource
    }
}
