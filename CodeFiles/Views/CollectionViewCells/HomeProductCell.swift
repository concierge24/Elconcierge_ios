//
//  HomeProductCell.swift
//  Clikat
//
//  Created by Night Reaper on 20/04/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import Material
import AMRatingControl
import EZSwiftExtensions
import Cosmos

//Anil
class HomeProductCell: ThemeCollectionViewCell {
    
    static var size: CGSize {
        let height: CGFloat = 200
        let width = CGFloat(UIScreen.main.bounds.width/2-20)
        return CGSize(width: width, height: height)
    }
    @IBOutlet weak var rating_label: UILabel!
    
    //    @IBOutlet weak var priceLblH: NSLayoutConstraint!
    @IBOutlet weak var lblOutOfStock: UILabel!
//    @IBOutlet weak var labelOfferPrice: UILabel! {
//        didSet{
//            labelOfferPrice.backgroundColor = SKAppType.type.alphaColor
//        }
//    }
    @IBOutlet weak var labelReview : UILabel!
    @IBOutlet weak var viewRating : CosmosView!{
        didSet{
            //productRate = 0
        }
    }
    
    @IBOutlet weak var labelSupplierName : UILabel!
    @IBOutlet weak var stackSupplier : UIStackView!
    
    @IBOutlet var stackRating: UIStackView! {
        didSet{
            stackRating.isHidden = SKAppType.type.isJNJ
        }
    }
    @IBOutlet var imgProduct: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblCompany: UILabel!
    @IBOutlet var lblOfferPrice: UILabel!
    @IBOutlet var lblEmptyPrice: UILabel?
    @IBOutlet var lblPrice: UILabel! {
        didSet {
            lblPrice.textColor = SKAppType.type.color
        }
    }
    @IBOutlet var stackPrice: UIStackView?
    @IBOutlet weak var testing_label: UILabel!
    @IBOutlet var viewHolderPrice: UIStackView!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var stepper: GMStepper?
    var isHideStepper: Bool = false    
    var isFilterSearch:Bool = false
    @IBOutlet var btnFav: UIButton!
    @IBOutlet weak var stackViewRating: UIStackView! {
        didSet {
            stackViewRating.isHidden = true//SKAppType.type.isHome ? true : false
        }
    }
    
    //    let rateControl = AMRatingControl(location: CGPoint(x: 0,y: 0), empty: UIImage(asset : Asset.Ic_star_small_grey), solidImage: UIImage(asset : Asset.Ic_star_small_yellow), andMaxRating: 5)
    var rateControl: AMRatingControl!
//
//    var productRate : Int = 0 {
//        didSet {
//
//            defer {
//                if !viewRating.subviews.isEmpty {
//
//                    viewRating.subviews.forEach({ $0.removeFromSuperview() })
//                    rateControl = nil
//                }
//                let imge = UIImage(asset : Asset.Ic_star_small_yellow)?.maskWithColor(color: getColor(rating: productRate))
//                rateControl = AMRatingControl(location: CGPoint(x: 0,y: 0), empty: UIImage(asset : Asset.Ic_star_small_grey), solidImage: imge, andMaxRating: 5)
//                rateControl.frame = viewRating.bounds
//                rateControl?.rating = productRate
//                rateControl?.starWidthAndHeight = 12
//                //                rateControl?.isUserInteractionEnabled = false
//                viewRating.addSubview(rateControl)
//            }
//        }
//    }
    var product: ProductF? {
        didSet {
            lblCompany.isHidden = false
            updateProductUI()
            updateStepper(objProdect: product)

        }
    }
    
    var supplier : Supplier? {
        didSet {
            updateSupplierUI()
        }
    }
    
    var productListing : ProductF? {
        didSet {
            updateProductListingUI()
            updateStepper(objProdect: productListing)
            
        }
    }
    
    private func updateStepper(objProdect: ProductF?) {
        stepper?.isHide = SKAppType.type != .home //(isHideStepper || /objProdect?.isVariant)
        stepper?.associatedProduct = objProdect
        
        stepper?.isCartView = false

        stepper?.stepperValueListener = {
            [weak self] (value) in
            guard let self = self else { return }
            if let data = value {
                self.stepper?.value = data
                self.updatePrice(objModel: objProdect)
            }
        }
        stepper?.value = 0.0
        
        DBManager.sharedManager.getProductToCart(productId: objProdect?.id) {
            [weak self] (products) in
            guard let self = self else { return }
            
            let currentProduct = products.first
            self.stepper?.value = currentProduct?.quantity?.toDouble() ?? 0.0
            
        }
        
        lblOfferPrice?.isHidden = true
        if let isOffer = objProdect?.isOffer, isOffer {
            let offerPrice = (/objProdect?.actualPrice).addCurrencyLocale
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: offerPrice)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))

            lblOfferPrice?.attributedText = attributeString
            lblOfferPrice?.isHidden = false
        }
    }
    
    func updatePrice(objModel: Cart?) {
        objModel?.getPriceLabel(block: {
            [weak self] (value) in
            guard let self = self else { return }
            self.lblPrice?.text = value
            
        })
    }
    
    private func updateProductListingUI(){
        
        defer {

            lblTitle?.text = productListing?.name
            labelSupplierName.text = "\(L10n.by.string) \(/(productListing?.supplierName))"
            labelSupplierName.isHidden = AppSettings.shared.isSingleVendor
            if let _ = GDataSingleton.sharedInstance.loggedInUser?.id {
                btnFav.isHidden = /AppSettings.shared.appThemeData?.is_product_wishlist != "1"
            } else{
                btnFav.isHidden = true
            }
            if isFilterSearch == false {
                
                let unit = productListing?.measuringUnit
                let qtyText = UtilityFunctions.appendOptionalStrings(withArray: [unit], separatorString: " ")
                self.lblEmptyPrice?.text = qtyText
                guard let value = Double(productListing?.quantity ?? "0") else { fatalError("Cart Quantity is nil") }
            }
            updatePrice(objModel: productListing)
            btnFav?.isSelected = /productListing?.isFavourite
            viewRating?.rating = Double(/productListing?.averageRating)

        }
        //Nitin Check
        if let image = productListing?.image {
            imgProduct.loadImage(thumbnail: image, original: nil)//, modeType: .scaleAspectFit)
        }
        lblOutOfStock?.isHidden = productListing!.isVariant || (Double(/productListing?.totalQuantity) - /productListing?.purchasedQuantity) > 0
    }

    private func updateProductUI(){
        self.rating_label.text = String(product?.averageRating ?? 0)

        defer {
            viewRating?.isHidden =  true
            labelReview.isHidden = true
            self.rating_label.text = String(product?.averageRating ?? 0)
            if let _ = GDataSingleton.sharedInstance.loggedInUser?.id {
                btnFav.isHidden = /AppSettings.shared.appThemeData?.is_product_wishlist != "1"
            } else{
                btnFav.isHidden = true
            }
            lblTitle?.text = product?.name
            lblCompany.text = "\(L10n.by.string) \(/(product?.supplierName))"
            btnFav.isSelected = /product?.isFavourite
            viewRating.rating = Double(/product?.averageRating)

            updatePrice(objModel: product)
            //            lblPrice?.text = UtilityFunctions.appendOptionalStrings(withArray: [L10n.AED.string,product?.getDisplayPrice(quantity: 1.0),L10n.Each.string])
            let offerPrice = (/product?.actualPrice).addCurrencyLocale
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: offerPrice)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            viewHolderPrice?.isHidden = false
            lblOfferPrice?.attributedText = attributeString
            labelAddress?.text = ""
            stackPrice?.isHidden = false
        }
        imgProduct.loadImage(thumbnail: product?.image, original: nil)//, modeType: .scaleAspectFit)
    }
    
    private func updateSupplierUI(){
        lblCompany?.text = /supplier?.address
        viewRating?.isHidden =  false
        labelReview.isHidden = false

        defer {
            
            lblTitle?.text = supplier?.name
            lblCompany?.isHidden = (/supplier?.address).isEmpty
            viewRating.rating = Double(/supplier?.rating)!
            //productRate = /supplier?.rating
            labelSupplierName?.text = supplier?.name
            labelReview.text =  (supplier?.totalReviews ?? "0") + L10n.Reviews.string
            lblPrice?.isHidden = false
            viewHolderPrice?.isHidden = true
            labelAddress?.text = supplier?.address
            stackPrice?.isHidden = true
            imgProduct.loadImage(thumbnail: supplier?.logo, original: nil)
        }
    }
    
    //For e commerce
    @IBAction func addToFav(_ sender: UIButton) {
        
        if !GDataSingleton.sharedInstance.isLoggedIn {
//            self.tableView.reloadData()
//            self.isLiked = /self.product?.isFavourite
            let loginVc = StoryboardScene.Register.instantiateLoginViewController()
            ez.topMostVC?.presentVC(loginVc)
            return
        }
        btnFav?.isSelected = !(/btnFav?.isSelected)
        self.makeProductFav(product: product ?? productListing)
    }
    
    func makeProductFav(product: Cart?) {
        
        guard let product = product else {
            //self.tableView.reloadData()
            //self.isLiked = /self.product?.isFavourite
            return
        }
        
        let objR = API.makeProductFav(id: /product.id, isFav: !product.isFavourite)
        
        APIManager.sharedInstance.opertationWithRequest(isLoader: true, withApi: objR) {
            [weak self] (response) in
            guard let self = self else { return }
            
            switch response {
            case .Success(_):
                product.isFav = (!product.isFavourite).toInt
                
                if product.isFavourite {
                    SKToast.makeToast("\((TerminologyKeys.product.localizedValue() as? String) ?? "Product") added to \((TerminologyKeys.wishlist.localizedValue() as? String) ?? "Wishlist")")
                }else {
                    SKToast.makeToast("\((TerminologyKeys.product.localizedValue() as? String) ?? "Product") removed from \((TerminologyKeys.wishlist.localizedValue() as? String) ?? "Wishlist")")
                }
                
                NotificationCenter.default.post(name: NSNotification.Name("FavouritePressed"), object: product)
                //self.tableView.reloadData()
                //self.isLiked = /self.product?.isFavourite
                //self.blockUpdataData?()
                
            case .Failure(let error):
                print(error.message ?? "")
                break
            }
        }
    }
}
