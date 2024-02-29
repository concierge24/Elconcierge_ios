//
//  TempCollectionViewCell.swift
//  Sneni
//
//  Created by cbl41 on 1/22/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit
import Material
import AMRatingControl

class TempCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var labelCustomization: SKThemeLabel! {
        didSet{
           if let term = TerminologyKeys.customisable.localizedValue() as? String{
            self.labelCustomization.text = term

           }else{
            self.labelCustomization.text = "Customizable".localized()
            }
            labelCustomization.textColor = SKAppType.type.color
        }
    }
    static var size: CGSize {
        let height = CGFloat(240.0)
        let width = CGFloat(UIScreen.main.bounds.width/2-20)
        return CGSize(width: width, height: height)
    }
    @IBOutlet weak var rating_label: UILabel!
    
    //    @IBOutlet weak var priceLblH: NSLayoutConstraint!
    @IBOutlet weak var labelOfferPrice: UILabel! {
        didSet{
            labelOfferPrice.backgroundColor = SKAppType.type.alphaColor
        }
    }
   
    @IBOutlet weak var labelReview : UILabel!
    @IBOutlet weak var viewRating : UIView!{
        didSet{
            productRate = 0
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
    @IBOutlet var lblPrice: UILabel!{
        didSet{
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
    var addonsCompletionBlock: NewListner?
    
    //    let rateControl = AMRatingControl(location: CGPoint(x: 0,y: 0), empty: UIImage(asset : Asset.Ic_star_small_grey), solidImage: UIImage(asset : Asset.Ic_star_small_yellow), andMaxRating: 5)
    var rateControl: AMRatingControl!
    
    var productRate : Int = 0 {
        didSet {
            
            defer {
                if !viewRating.subviews.isEmpty {
                    
                    viewRating.subviews.forEach({ $0.removeFromSuperview() })
                    rateControl = nil
                }
                let imge = UIImage(asset : Asset.Ic_star_small_yellow)?.maskWithColor(color: getColor(rating: productRate))
                rateControl = AMRatingControl(location: CGPoint(x: 0,y: 0), empty: UIImage(asset : Asset.Ic_star_small_grey), solidImage: imge, andMaxRating: 5)
                rateControl.frame = viewRating.bounds
                rateControl?.rating = productRate
                rateControl?.starWidthAndHeight = 12
                //                rateControl?.isUserInteractionEnabled = false
                viewRating.addSubview(rateControl)
            }
        }
    }
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
        stepper?.isHide = (isHideStepper || /objProdect?.isVariant)
        stepper?.associatedProduct = objProdect
        
        stepper?.isCartView = false
        
//        stepper?.stepperValueListener = {
//            [weak self] (value) in
//            guard let self = self else { return }
//            if let data = value as? Double {
//                self.stepper?.value = data
//                self.updatePrice(objModel: objProdect)
//            }
//        }
        
        stepper?.addonStepperListner = { [weak self] (value) in
            guard let self = self else { return }
            GDataSingleton.sharedInstance.fromCart = false
            guard let block = self.addonsCompletionBlock else {return}
            
            if let data = value as? (ProductF,Bool,Double) { // for opening customization view
                block(data)
            } else if let data = value as? (ProductF,Cart,Bool,Double) { // for opening check customization view
                block(data)
            } else if let data = value as? Double { // for simply showing bottom bar without customization
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
        
        let rating = /(objProdect?.averageRating)?.toDouble
        self.rating_label.text = String(rating)
        labelOfferPrice.isHidden = true
        labelCustomization.isHidden = /objProdect?.is_product_adds_on == 1 ? false : true
        
        if let isOffer = objProdect?.isOffer, isOffer {
            let offerPrice = (/objProdect?.actualPrice).addCurrencyLocale
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: offerPrice)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))

            labelOfferPrice.attributedText = attributeString
            labelOfferPrice.isHidden = false
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
            
            if isFilterSearch == false {
                
                let unit = productListing?.measuringUnit
                let qtyText = UtilityFunctions.appendOptionalStrings(withArray: [unit], separatorString: " ")
                self.lblEmptyPrice?.text = qtyText
                guard let value = Double(productListing?.quantity ?? "0") else { fatalError("Cart Quantity is nil") }
            }
            updatePrice(objModel: productListing)
        }
        //Nitin Check

        imgProduct.loadImage(thumbnail: productListing?.image, original: nil)

    }

    private func updateProductUI(){
        self.rating_label.text = String(product?.averageRating ?? 0)

        defer {
            viewRating?.isHidden =  true
            labelReview.isHidden = true
            self.rating_label.text = String(product?.averageRating ?? 0)

            lblTitle?.text = product?.name
            lblCompany.text = "\(L10n.by.string) \(/(product?.supplierName))"

            updatePrice(objModel: product)
            //            lblPrice?.text = UtilityFunctions.appendOptionalStrings(withArray: [L10n.AED.string,product?.getDisplayPrice(quantity: 1.0),L10n.Each.string])
            let offerPrice = (/product?.offerPrice?.toDouble()).addCurrencyLocale
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: offerPrice)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            viewHolderPrice?.isHidden = false
            lblOfferPrice?.attributedText = attributeString
            labelAddress?.text = ""
            stackPrice?.isHidden = false
        }
        imgProduct.loadImage(thumbnail: product?.image, original: nil)
    }
    
    private func updateSupplierUI(){
        lblCompany?.text = /supplier?.address
        viewRating?.isHidden =  false
        labelReview.isHidden = false

        defer {
            
            lblTitle?.text = supplier?.name
            lblCompany?.isHidden = (/supplier?.address).isEmpty
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
}
