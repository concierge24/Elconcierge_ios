//
//  HomeFoodItemCollectionCell.swift
//  Sneni
//
//  Created by Sandeep Kumar on 03/07/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class HomeFoodItemCollectionCell: UICollectionViewCell {

    //MARK:- ======== Static Variables ========
    static var size: CGSize {
        let height = CGFloat(UIScreen.main.bounds.width*0.60)
        let width = CGFloat(UIScreen.main.bounds.width*0.455)
        return CGSize(width: width, height: height)
    }
    
    //MARK:- ======== Outlets ========
    @IBOutlet weak var imgPic: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel! {
        didSet {
            lblSubTitle.isHidden = AppSettings.shared.isSingleVendor ? true : false
        }
    }
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var stepper: GMStepper! {
        didSet{
            //stepper?.willHideRemoveCart = true
            stepper?.btnAddToCart.isHidden = true
        }
    }
    @IBOutlet weak var labelCustomization: UILabel! {
        didSet{
            if let term = TerminologyKeys.customisable.localizedValue() as? String{
             self.labelCustomization.text = term

            }else{
             self.labelCustomization.text = "Customizable".localized()
             }
            labelCustomization.textColor = SKAppType.type.color
        }
    }
    @IBOutlet weak var totalPrice_label: UILabel!
    @IBOutlet weak var rating_label: UILabel!
    
    //MARK:- ======== Static Variables ========
    var selectedIndex: Int?
    var completionBlock : AnyCompletionBlock?
    var newCompletionBlock : AnyCompletionBlock?
    var addonsCompletionBlock: NewListner?
    
    //MARK:- ======== Variables ========
    var objModel: ProductF? {
        didSet {
            lblTitle?.text = objModel?.name
            lblSubTitle.text = "\(L10n.by.string) \(/(objModel?.supplierName))"
            if let rating = objModel?.averageRating{
                self.rating_label.text = String(rating.toDouble)
            }
//(thumbnail: objModel?.image, original: nil)
            //imgPic.loadImage(thumbnail: objModel?.image, original: nil, placeHolder: nil, modeType: .scaleAspectFit)
            imgPic.loadImage(thumbnail: objModel?.image, original: nil)

            self.labelCustomization.isHidden = /objModel?.adds_on?.count == 0 ? true : false

            stepper?.associatedProduct = objModel
           // stepper?.isCartView = false
            self.updatePrice()
            
            stepper?.addonStepperListner = { [weak self] (value) in
                guard let self = self else { return }
                guard let block = self.addonsCompletionBlock else {return}
                
                if let data = value as? (ProductF,Bool,Double) { // for opening customization view
                    block(data)
                } else if let data = value as? (ProductF,Cart,Bool,Double) { // for opening check customization view
                    block(data)
                } else if let data = value as? Double {
                    self.stepper?.value = data
                    self.updatePrice()
                }
                
            }
            
            stepper?.value = 0.0
            
            DBManager.sharedManager.getProductToCart(productId: objModel?.id) {
                [weak self] (products) in
                guard let self = self else { return }
                
                let currentProduct = products.first
                self.stepper?.value = currentProduct?.quantity?.toDouble() ?? 0.0
            }
            
            totalPrice_label?.isHidden = true
            if let isOffer = objModel?.isOffer, isOffer {
                let offerPrice = (Double(/objModel?.offerPrice))!.addCurrencyLocale
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: offerPrice)
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                
                totalPrice_label?.attributedText = attributeString
                totalPrice_label?.isHidden = false
            }
        }
    }
    
    private func updatePrice() {
        objModel?.getPriceLabel(block: {
            [weak self] (value) in
            guard let self = self else { return }
            self.lblPrice?.text = value
        })
    }
    
    //MARK:- ======== LifeCycle ========
    override func awakeFromNib() {
        super.awakeFromNib()
        initalSetup()
    }
    
    //MARK:- ======== Actions ========
    @IBAction func didTapSubmit(_ sender: Any) {
        
    }
    
    //MARK:- ======== Functions ========
    func initalSetup() {
        
    }

}
