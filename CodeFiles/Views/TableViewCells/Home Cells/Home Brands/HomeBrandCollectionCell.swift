//
//  HomeBrandCollectionCell.swift
//  Sneni
//
//  Created by Sandeep Kumar on 14/06/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class HomeBrandCollectionCell: UICollectionViewCell {

    //MARK:- ======== Outlets ========
    @IBOutlet var imgSerivce: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    
    @IBOutlet weak var btnFav: UIButton!
    //MARK:- ======== Variables ========
    let gradient = CAGradientLayer()

    var objModel : Brands? {
        didSet {
            lblTitle?.text = /objModel?.name
            if SKAppType.type != .food {
                imgSerivce.loadImage(thumbnail: objModel?.image, original: nil)//, modeType: .scaleAspectFit)
            }
            else {
                imgSerivce.loadImage(thumbnail: objModel?.image, original: nil)//modeType: .scaleAspectFit
            }
        }
    }
    
    var objModelS : Supplier? {
        didSet {
            if SKAppType.type != .food {
                imgSerivce.loadImage(thumbnail: objModelS?.logo, original: nil)//, modeType: .scaleAspectFit)
            }
            else {
                imgSerivce.loadImage(thumbnail: objModelS?.logo, original: nil)//modeType: .scaleAspectFit
            }
            lblTitle?.text = /objModelS?.name
            
            
            guard let _ = GDataSingleton.sharedInstance.loggedInUser?.id else{
                btnFav?.isHidden = true
                return
            }
            btnFav?.isHidden = /AppSettings.shared.appThemeData?.is_supplier_wishlist != "1"
            guard let favorite = objModelS?.Favourite, favorite == "1" else{
                btnFav?.isSelected = false
                return
            }
            btnFav?.isSelected = true
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
    @IBAction func actionFav(_ sender: UIButton) {
        
        if sender.isSelected {
            btnFav?.isSelected = false
            objModelS?.Favourite = "0"
            SKToast.makeToast("\((TerminologyKeys.supplier.localizedValue() as? String) ?? "Supplier") removed from \((TerminologyKeys.wishlist.localizedValue() as? String) ?? "Wishlist")")
            
            APIManager.sharedInstance.opertationWithRequest(withApi: API.UnFavoriteSupplier(FormatAPIParameters.UnFavoriteSupplier(supplierId: objModelS?.id).formatParameters()), completion: { (response) in })
            //Mark Unfavorite
            
        } else {
            btnFav?.isSelected = true
            objModelS?.Favourite = "1"

            SKToast.makeToast("\((TerminologyKeys.supplier.localizedValue() as? String) ?? "Supplier") added to \((TerminologyKeys.wishlist.localizedValue() as? String) ?? "Wishlist")")
            
            APIManager.sharedInstance.opertationWithRequest(withApi: API.MarkSupplierFav(FormatAPIParameters.MarkSupplierFavorite(supplierId: objModelS?.id).formatParameters()), completion: { (response) in })
        }
    }
    
    //MARK:- ======== Functions ========
    func initalSetup() {
//        gradient.frame = bounds
//        gradient.colors = [
//            UIColor(red:1, green:1, blue:1, alpha:0).cgColor,
//            UIColor(red:0, green:0, blue:0, alpha:0.5).cgColor
//        ]
//        gradient.locations = [0, 1]
//        gradient.startPoint = CGPoint(x: 0.5, y: 0)
//        gradient.endPoint = CGPoint(x: 0.5, y: 0.72)
//        gradient.cornerRadius = 4
//        imgSerivce.layer.addSublayer(gradient)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        gradient.frame = bounds
        
    }
}
