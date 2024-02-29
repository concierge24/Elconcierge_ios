//
//  ProductListingCell.swift
//  Clikat
//
//  Created by cbl73 on 4/21/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import Material
import AMRatingControl
import Cosmos
import EZSwiftExtensions

enum ProductListingCellType {
    
    case Product
    case Cart
}


class ProductListingCell: ThemeTableCell {
    
    @IBOutlet weak var viewStarRating: UIStackView!
    @IBOutlet weak var viewRatingFiveStar: UIStackView!
    //MARK:- IBOutlet
    @IBOutlet weak var labelCustomization: UILabel! {
        didSet {
            if let term = TerminologyKeys.customisable.localizedValue() as? String{
            self.labelCustomization.text = term

            }else{
               self.labelCustomization.text = "Customizable".localized()
            }
            labelCustomization.textColor = SKAppType.type.color
        }
    }
    @IBOutlet weak var rating_label: UILabel!
    @IBOutlet weak var stackProduct: UIStackView?
    @IBOutlet var btnDelete: UIButton?
    @IBOutlet var imgProduct: UIImageView!{
         didSet{
             imgProduct.layer.borderWidth = 1
             imgProduct.layer.borderColor = UIColor.black.withAlphaComponent(0.12).cgColor
             
         }
     }
     @IBOutlet var lblTitle: UILabel!
     @IBOutlet var viewBG: UIView!
     @IBOutlet var lblLine: UILabel!
     @IBOutlet weak var leadingBGView: NSLayoutConstraint!
     @IBOutlet var lblQty: UILabel!
     @IBOutlet var lblPrice: UILabel!{
         didSet{
             lblPrice.textColor = SKAppType.type.color
         }
     }
     @IBOutlet var stepper: GMStepper?
    
     @IBOutlet weak var lblSupplierName: UILabel!
    @IBOutlet weak var lblOutOfStock: SKThemeLabel!
    @IBOutlet weak var labelOfferPrice: UILabel!{
         didSet{
//             labelOfferPrice.backgroundColor = SKAppType.type.alphaColor
//             labelOfferPrice.textColor = .white
         }
     }
     @IBOutlet weak var lblTotalReviews: UILabel!
     @IBOutlet weak var lblAgent: UILabel!
     @IBOutlet weak var ratingBgView: CosmosView!{
         didSet{
             productRate = 0
             rateControl?.isUserInteractionEnabled = false
         }
     }
     @IBOutlet weak var btnAddCart: UIButton!
    @IBOutlet weak var btnFav: UIButton!
    
//    let rateControl = AMRatingControl(location: CGPoint(x: 0,y: 0), empty: UIImage(asset : Asset.Ic_star_small_grey), solidImage: UIImage(asset : Asset.Ic_star_small_yellow), andMaxRating: 5)
    
    //MARK:- Variables
    typealias ProductClicked = (_ product : ProductF?) -> ()
    var rateControl: AMRatingControl!
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
//                rateControl.frame = ratingBgView.bounds
//                rateControl.isUserInteractionEnabled = false
//                rateControl?.rating = productRate
//                rateControl?.starWidthAndHeight = 12
//                ratingBgView.addSubview(rateControl)
//            }
        }
    }
    var isHideStepper:Bool = false {
       didSet {
           stepper?.isHide = isHideStepper
       }
    }
    var productClicked : ProductClicked?
    var category : String?
    var isForCart: Bool = true {
        didSet {
            btnDelete?.isHidden = !isForCart
        }
    }
    var categoryId : String?{
        didSet{
            stepper?.associatedProduct?.categoryId = categoryId
        }
    }
    var product : ProductF? {
        didSet {
            updateUI(type: .Product)
            let rating = /(product?.averageRating)?.toDouble
            self.rating_label.text = String(rating)
            stackProduct?.isHidden = SKAppType.type == .eCom ? true : /product?.isVariant
            lblSupplierName.isHidden = AppSettings.shared.isSingleVendor
            labelCustomization.isHidden = /product?.is_product_adds_on == 1 ? false : true
            stepper?.associatedProduct = product
            btnFav.isSelected = /product?.isFavourite

            //Daman - code copied from Home product cell
            stepper?.isCartView = false
            lblOutOfStock?.isHidden = product!.isVariant || (Double(/product?.totalQuantity) - /product?.purchasedQuantity) > 0
            ratingBgView.rating = Double(/product?.averageRating)

            stepper?.stepperValueListener = {
                [weak self] (value) in
                guard let self = self else { return }
                if let data = value {
                    self.stepper?.value = data
                    self.updatePrice(objModel: self.product)
                }
            }
            stepper?.value = 0.0
            
            DBManager.sharedManager.getProductToCart(productId: product?.id) {
                [weak self] (products) in
                guard let self = self else { return }
                
                let currentProduct = products.first
                self.stepper?.value = currentProduct?.quantity?.toDouble() ?? 0.0
                
            }
        }
    }
    var cart : Cart? {
        didSet{
            updateUI(type: .Cart)
            let cartProduct = ProductF(cart: cart)
            
            stackProduct?.isHidden = SKAppType.type == .eCom ? true : /cart?.isVariant
            stepper?.associatedProduct = cartProduct
        }
    }
    
    func updatePrice(objModel: Cart?) {
        objModel?.getPriceLabel(block: {
            [weak self] (value) in
            guard let self = self else { return }
            self.lblPrice?.text = value
            
        })
    }
    
    var addonsCompletionBlock: NewListner?

   // @IBOutlet weak var rating_label: UILabel!
    private func updateUI(type : ProductListingCellType){
//        stepper.isCartView = true
        let object : Cart? = type == .Cart ? cart : product
        if true {
            lblTitle?.text = object?.name
            let unit = object?.measuringUnit
            let sku = object?.sku
            let qtyText = UtilityFunctions.appendOptionalStrings(withArray: [unit], separatorString: " ")
            lblQty?.text = qtyText
            
            if type == .Cart{
                //                lblAgent.text =  object?.agent_list == "0" ? L10n.AgentNotAvailable.string : L10n.AgentAvailable.string
                let isAgentAvl = (/object?.agentList == "0" || /object?.agentList == "")
                
                lblAgent.text = isAgentAvl  ? "" : L10n.AgentAvailable.string
            }
            btnFav.isSelected = /object?.isFavourite
            lblSupplierName.text = "\(L10n.by.string) \(/(object?.supplierName))"
            productRate = 0
            lblTotalReviews?.text = UtilityFunctions.appendOptionalStrings(withArray: ["0" , L10n.Reviews.string])
            
            if SKAppType.type == .food {
                viewStarRating?.isHidden = false
                viewRatingFiveStar?.isHidden = true
            }
            
            if let _ = GDataSingleton.sharedInstance.loggedInUser?.id {
                btnFav.isHidden = /AppSettings.shared.appThemeData?.is_product_wishlist != "1"
            } else{
                btnFav.isHidden = true
            }
//            guard let value = Double(object?.quantity ?? "0") else { fatalError("Cart Quantity is nil") }
//
//            if GDataSingleton.sharedInstance.cart_flow == 0{
//
//                DBManager.sharedManager.getCart { [unowned self] (array) in
//                    self.btnAddCart.titleLabel?.text  =  array.count == 1 ? "Edit to Cart" : "Add to Cart"
//                    self.btnAddCart.tag = array.count == 1 ? 1 : 0
//                }
//
//            }
//            else{
//                stepper.value = value
//            }
            
            
//            lblPrice?.text = UtilityFunctions.appendOptionalStrings(withArray: [L10n.AED.string,object?.getDisplayPrice(quantity: value)])
        }
        
        
        //        let price = UtilityFunctions.appendOptionalStrings(withArray: [L10n.AED.string,object?.getDisplayPrice(quantity: 0)])
        //        print(price)
        
        labelOfferPrice.isHidden = true
        if let isOffer = product?.isOffer, isOffer {
            let offerPrice = (/product?.actualPrice).addCurrencyLocale
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: offerPrice)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            
            print(attributeString)
            labelOfferPrice.attributedText = attributeString
            labelOfferPrice.isHidden = false
        }
        
        //stepper.isHidden = object?.quantity == "-1" ? true : false
        
        updateStepper(type: type)

        guard let image = type == .Cart ? cart?.image : product?.image else{
            return
        }
        
     //   let asdas = UIImageView()
//        print(asdas.loadImage(thumbnail: image, original: nil))
        imgProduct?.loadImage(thumbnail: image, original: nil)
    }
    
    private func updatePrice(type : ProductListingCellType) {
        let object : Cart? = type == .Cart ? cart : product
        object?.getPriceLabel(block: {
            [weak self] (value) in
            guard let self = self else { return }
            self.lblPrice?.text = value
        })
    }
    
    private func updateStepper(type : ProductListingCellType){
        let object : ProductF? = type == .Cart ? ProductF(cart: cart) : product
        self.updatePrice(type: type)
        
//        stepper?.isHidden = GDataSingleton.sharedInstance.cartFlow.isOneQty
        stepper?.associatedProduct = object
//        btnAddCart.isHidden = true//!GDataSingleton.sharedInstance.cartFlow.isOneQty
        stepper?.isCartView = isForCart
        
//        stepper?.stepperValueListener = {
//            [weak self] (value) in
//            guard let self = self else { return }
//            if let data = value as? Double {
//                self.stepper?.value = data
//            }
//            self.updatePrice(type: type)
//        }
//
        stepper?.addonStepperListner = { [weak self] (value) in
            guard let self = self else { return }
            guard let block = self.addonsCompletionBlock else {return}
            
            if let data = value as? (ProductF,Bool,Double) { // for opening customization view
                block(data)
            } else if let data = value as? (ProductF,Cart,Bool,Double) { // for opening check customization view
                block(data)
            } else if let data = value as? Double { // for simply showing bottom bar without customization
                self.stepper?.value = data
                self.updatePrice(type: type)
            }
        }
        
        stepper?.value = 0.0
        
        DBManager.sharedManager.getProductToCart(productId: object?.id) {
            [weak self] (products) in
            guard let self = self else { return }
            
            let currentProduct = products.first
            self.stepper?.value = currentProduct?.quantity?.toDouble() ?? 0.0

        }
    }
}

//MARK: - Button Action
extension ProductListingCell {
    
    @IBAction func btnClick(sender: UIButton) {
        guard let block = productClicked else { return }
        block(product)
    }
    
    @IBAction func addToFav(_ sender: DOFavoriteButton) {
        if !GDataSingleton.sharedInstance.isLoggedIn {
            //            self.tableView.reloadData()
            //            self.isLiked = /self.product?.isFavourite
            let loginVc = StoryboardScene.Register.instantiateLoginViewController()
            ez.topMostVC?.presentVC(loginVc)
            return
        }
        
        btnFav.isSelected = !btnFav.isSelected
        self.makeProductFav(product: product ?? cart)
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
    
    @IBAction func btnAddtoCartClick(sender: UIButton) {
        
        stepper?.rightButtonTouchDown(button: sender)
        
    }
    
}

extension ProductListingCell{
    
    @IBAction func deleteCart(sender:UIButton){
        
        // DBManager.sharedManager.cleanCart()
        stepper?.deleteProduct(quantity: 0)
    }
    
}
