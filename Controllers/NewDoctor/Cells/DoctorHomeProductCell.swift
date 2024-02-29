//
//  DoctorHomeProductCell.swift
//  Sneni
//
//  Created by Daman on 17/04/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit
import Cosmos

class DoctorHomeProductCell: UICollectionViewCell {
    @IBOutlet var imgProduct: UIImageView!
    @IBOutlet var lblTitle: SKThemeLabel!
    @IBOutlet var viewRating: CosmosView!
    @IBOutlet var lblReviewsCount: ThemeLabel!
    @IBOutlet var stepper: GMStepper!
    @IBOutlet var lblPrice: UILabel! {
        didSet {
            lblPrice.textColor = SKAppType.type.color
        }
    }
    @IBOutlet var lblOfferPrice: UILabel!
    @IBOutlet var stackPrice: UIStackView!
    
    var product: ProductF? {
        didSet {
            updateProductUI()
        }
    }
    
    var supplier : Supplier? {
        didSet {
            updateSupplierUI()
        }
    }
    var addonsCompletionBlock: NewListner?

    private func updateProductUI() {
        stepper.isHidden = false
        lblPrice.isHidden = false
        stackPrice.isHidden = false
        
        stepper.appType = SKAppType(rawValue: product?.type ?? 1) ?? .food
        stepper.cart_image_upload = product?.cart_image_upload
        stepper.order_instructions = product?.order_instructions
        stepper.associatedProduct = product
        stepper?.addonStepperListner = { [weak self] (value) in
            guard let self = self else { return }
            guard let block = self.addonsCompletionBlock else {return}
            
            if let data = value as? (ProductF,Bool,Double) { // for opening customization view
                block(data)
            } else if let data = value as? (ProductF,Cart,Bool,Double) { // for opening check customization view
                block(data)
            } else if let data = value as? Double {
                self.stepper?.value = data
                self.updatePrice(objModel: self.product)
            }
            
        }
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
        
        let actualPrice = (/product?.actualPrice)
        let price: Double = product?.getDisplayPrice(quantity: 1) ?? 0

        let percentage = Int(ceil(((actualPrice - price) / actualPrice) * 100))
        self.lblPrice?.text = "Upto \(percentage)% off"
        
//        updatePrice(objModel: product)
        lblOfferPrice?.isHidden = true
//        if let isOffer = product?.isOffer, isOffer {
//            let offerPrice = (/product?.actualPrice).addCurrencyLocale
//            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: offerPrice)
//            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
//
//            lblOfferPrice?.attributedText = attributeString
//            lblOfferPrice?.isHidden = false
//        }
        
          imgProduct.loadImage(thumbnail: product?.image, original: nil)//, modeType: .scaleAspectFit)
        lblTitle?.text = product?.name
        lblReviewsCount?.text = "[ \(product?.totalReview ?? 0) \("reviews".localized()) ]"
        //Double(/product?.averageRating)
      }
      
    func updatePrice(objModel: Cart?) {
//        objModel?.getPriceLabel(block: {
//            [weak self] (value) in
//            guard let self = self else { return }
//            self.lblPrice?.text = value
//        })
    }
    
      private func updateSupplierUI() {
        stepper.isHidden = true
        lblPrice.isHidden = true
        stackPrice.isHidden = true
        lblTitle?.text = supplier?.name
        ///Double(/supplier?.rating)
        imgProduct.loadImage(thumbnail: supplier?.logo, original: nil)
      }
}
