//
//  ProductListCell.swift
//  Sneni
//
//  Created by Apple on 03/07/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit
import Cosmos

class ProductListCell: UITableViewCell {
    
    //MARK:- IBOutlet

    @IBOutlet weak var btnFav: UIButton! {
        didSet {
            if let _ = GDataSingleton.sharedInstance.loggedInUser?.id {
                btnFav.isHidden = /AppSettings.shared.appThemeData?.is_product_wishlist != "1"
            } else{
                btnFav.isHidden = true
            }
        }
    }

    @IBOutlet var imgShadow: UIImageView!{
        didSet {
            if APIConstants.defaultAgentCode == "yummy_0122" {
                imgShadow.isHidden = false
            }
        }
    }
    @IBOutlet weak var btnMoreDetails: UIButton! {
        didSet {
            btnMoreDetails?.tintColor = SKAppType.type.color
            btnMoreDetails.setTitleColor(SKAppType.type.color, for: .normal)
            btnMoreDetails?.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -8)
        }
    }
    @IBOutlet weak var viewPrescriptionReq: UIView!

    @IBOutlet weak var stackDetails: UIStackView!
    @IBOutlet weak var labelOutOfStock: UILabel! {
        didSet{
            labelOutOfStock.backgroundColor = SKAppType.type.alphaColor
            if let headerColor = AppSettings.shared.appThemeData?.header_text_color {
                let header = UIColor(hexString: headerColor)
                labelOutOfStock.textColor = header ?? .darkGray
            }
        }
    }
    @IBOutlet weak var rating_label: UILabel!
    @IBOutlet weak var customised: UILabel! {
        didSet{
            customised.textColor = SKAppType.type.color
            
        }
    }
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var labelOfferPrice: UILabel!
    @IBOutlet weak var customizationText_label: UILabel! //Nitin
    @IBOutlet weak var lblSupplierName: UILabel?
    @IBOutlet var stepper: GMStepper? {
        didSet {
            
            stepper?.willHideRemoveCart = true
            stepper?.isCartView = false
        }
    }
    @IBOutlet weak var viewOutofStock: UIView!
    @IBOutlet weak var viewStarRating: CosmosView!
    @IBOutlet weak var viewSingleStarRating: UIStackView!
    @IBOutlet var imgBg: UIImageView! {
        didSet {
            if APIConstants.defaultAgentCode == "yummy_0122" {
                imgBg.isHidden = true
            }
        }
    }
    @IBOutlet var viewHeader: UIView!
    @IBOutlet var lblTitleHeader: UILabel!
    
    //MARK:- Variables
    var selectedIndex: Int?
    var completionBlock : AnyCompletionBlock?
    var addonsCompletionBlock: NewListner?
    var supplierData : Supplier?
    var fromCartView = false
    var index : Int?
    var isOpen:Bool = true
    var headerTitle: String? {
        didSet {
            if let title = headerTitle, !title.isEmpty {
                viewHeader.isHidden = false
                lblTitleHeader.text = title
            }
            else {
                viewHeader.isHidden = true
            }
        }
    }
    var product : ProductF? {
        didSet {
            viewHeader.isHidden = true
            if SKAppType.type == .food {
//                viewSingleStarRating.isHidden = false
                viewStarRating.isHidden = true
                if let rating = product?.averageRating {
                   let doubleRating = rating.toDouble
                   self.rating_label.text = String(doubleRating)
               } else if let rating = product?.averageRating {
                   let doubleRating = rating.toDouble
                   self.rating_label.text = String(doubleRating)
               }
            }
            else {
                viewSingleStarRating.isHidden = true
                viewStarRating.isHidden = false
                if let rating = product?.averageRating {
                    let doubleRating = rating.toDouble
                    viewStarRating.rating = doubleRating
                } else if let rating = product?.averageRating {
                    let doubleRating = rating.toDouble
                    viewStarRating.rating = doubleRating
                }
            }
           
            if fromCartView {
                var addons = ""
                for array in product?.arrayAddonValue ?? [] {
                    for addon in array {
                        if let addonName = addon.type_name {
                            addons = addons + "," + addonName
                        }
                    }
                }
                if addons.first == "," {
                    addons.removeFirst()
                }
                if addons.last == "," {
                    addons.removeLast()
                }
                
                //////////////
                if SKAppType.type.isFood {
                    let arr = addons.components(separatedBy: ",")
                    var aryDict = [[String:String]]()
                    if arr.count > 0 {
                        for addon in arr {
                            let tok =  addons.components(separatedBy:addon)
                            let dict = ["name":addon, "count":"\(tok.count-1)"] as [String : String]
                            aryDict.append(dict)
                        }
                    }
                    aryDict.removeDuplicates()
                    
                    var addonStr = ""
                    for addon in aryDict {
                        if let addonName = addon["name"] {
                            addonStr = addonStr + "," + addonName + "(\(addon["count"] ?? "1"))"
                        }
                    }
                    if addonStr.first == "," {
                        addonStr.removeFirst()
                    }
                    if addonStr.last == "," {
                        addonStr.removeLast()
                    }
                    self.customised.text = "Extras: " + addonStr
                } else {
                    self.customised.text = "Extras: " + addons
                }
                //////////////
                self.customised.isHidden = addons.count == 0 ? true : false
//                self.customised.text = "Extras: " + addons
                
            } else {
               if let term = TerminologyKeys.customisable.localizedValue() as? String{
                self.customised.text = term

               }else{
                self.customised.text = "Customizable".localized()
                }
                self.customised.isHidden = product?.adds_on?.count ?? 0 == 0 ? true : false
            }
            
            btnFav.isSelected = /product?.isFavourite

            lblProductName?.text = product?.name
            lblSupplierName?.text = product?.supplierName
            lblSupplierName?.isHidden = AppSettings.shared.isSingleVendor
            lblProductPrice?.text = product?.price
            imageProduct?.loadImage(thumbnail: product?.image, original: nil)
            self.updatePrice()
            stepper?.associatedProduct = product
            stepper?.fromCartView = self.fromCartView
                if self.isOpen{
            stepper?.addonStepperListner = { [weak self] (value) in
                guard let self = self else { return }
                guard let block = self.addonsCompletionBlock else {return}

                if let data = value as? (ProductF,Bool,Double) { // for opening customization view
                    block(data)
                } else if let data = value as? (ProductF,Cart,Bool,Double) { // for opening check customization view
                    block(data)
                } else if let data = value as? Double { // for simply showing bottom bar without customization
                    self.stepper?.value = data
                    self.updatePrice()
                    if self.fromCartView {
                        block((data,self.product))
                    }
                } else if let data = value as? (ProductF,Cart,Bool,Double,Int) { // only for cartview controller
                    block(data)
                }
            }

           
                        
                self.stepper?.stepperValueListener = {[weak self] (value) in
                guard let self = self else { return }
                guard let block = self.completionBlock else {return}

                if let data = value {
                    self.stepper?.value = data
                    self.updatePrice()
                    block(data as AnyObject)
                }
            }
                                    }
            stepper?.value = 0.0
            
            if fromCartView {
                if let quant = product?.perAddonQuantity {
                    print(quant)
                    self.stepper?.value = quant.toDouble

                } else {
                    DBManager.sharedManager.getProductToCart(productId: product?.id) {
                        [weak self] (products) in
                        guard let self = self else { return }
                        
                        let currentProduct = products.first
                        self.stepper?.value = currentProduct?.quantity?.toDouble() ?? 0.0
                    }
                }
            } else {
                DBManager.sharedManager.getProductToCart(productId: product?.id) {
                    [weak self] (products) in
                    guard let self = self else { return }
                    
                    let currentProduct = products.first
                    self.stepper?.value = currentProduct?.quantity?.toDouble() ?? 0.0

                }
            }
            
            labelOfferPrice?.isHidden = true
            if let isOffer = product?.isOffer, isOffer {
                
                let offerPrice = (/product?.actualPrice).addCurrencyLocale
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: offerPrice)
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                
                labelOfferPrice?.attributedText = attributeString
                labelOfferPrice?.isHidden = false
            }
            
            for view in stackDetails.arrangedSubviews {
                if view is VariantView {
                    view.removeFromSuperview()
                }
            }
            
            for variant in product?.selectedVariants ?? [] {
                let variantView = VariantView(frame: CGRect(x: 0, y: 0, w: stackDetails.size.width, h: 16))
                variantView.configureVariant(variant)
                stackDetails.addArrangedSubview(variantView)
            }
        }
    }

    private func updatePrice() {
        product?.getCartPriceLabel(block: {
            [weak self] (value) in
            guard let self = self else { return }
            self.lblProductPrice.text = value
            print(value)
        })
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnAddProductAction(_ sender: Any) {
        
    }
    
    
    @IBAction func btnRemoveProductAction(_ sender: Any) {
        
    }
    
    @IBAction func actionFav(_ sender: Any) {
        btnFav.isSelected = !btnFav.isSelected
        self.makeProductFav(product: product)
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
