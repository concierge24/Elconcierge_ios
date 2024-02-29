//
//  PorductVariantDeliveryLocationTblCell.swift
//  Sneni
//
//  Created by MAc_mini on 23/02/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class DeliveryLocationTblCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var stackAddProduct: UIStackView!
    @IBOutlet weak var stackBuyAndWish: UIStackView!
    @IBOutlet weak var stackDeliveryLocation: UIStackView!
    @IBOutlet weak var btnBuyNow: UIButton!
    @IBOutlet weak var btnAddWishList: UIButton!
    
    @IBOutlet weak var stepper: GMStepper! {
        didSet {
            stepper.btnAddToCart.fontSize = 12.0
        }
    }
    @IBOutlet weak var lblOutOfStock: UILabel! {
        didSet {
            lblOutOfStock.textColor = SKAppType.type.color
        }
    }
    
    @IBOutlet weak var heightStepper: NSLayoutConstraint!
    var blockUpdateStepper : StepperValueListener?
    var blockBuyNow : ((ProductF?) -> ())?
    var blockAddRemoveWishList : ((ProductF?) -> ())?

    var product : ProductF?{
        didSet{
            
            stepper.associatedProduct = product
            updateUI()

        }
    }
    
    private  func updateUI(){
        
        stepper.isCartView = false
        stepper.stepperValueListener = {
            [weak self] (value) in
            guard let self = self else { return }
            
            //Nitin old code
//            if let data = value as? Double {
//                self.stepper?.value = data
//                self.blockUpdateStepper?(data as AnyObject)
//            }

            self.stepper.value = value ?? 0.0
            self.blockUpdateStepper?(value)
        }
        
        self.stepper.value = 0.0
        DBManager.sharedManager.getProductToCart(productId: product?.id) { (products) in
            
            let currentProduct = products.first
            self.stepper.value = currentProduct?.quantity?.toDouble() ?? 0.0
        }
        
        stackBuyAndWish.isHidden = SKAppType.type != .eCom
        btnAddWishList.isSelected = /product?.isFavourite
        btnAddWishList.isHidden = true///product?.isFavourite
        stackDeliveryLocation.isHidden = true//SKAppType.type == .eCom
        lblOutOfStock?.isHidden = product!.isVariant || (Double(/product?.totalQuantity) - Double(/product?.purchased_quantity)) > 0
        stepper.isUserInteractionEnabled = (/lblOutOfStock?.isHidden)
        stepper.alpha = stepper.isUserInteractionEnabled ? 1 : 0.5
    }
    
    func setLocation(){
        let txt = LocationSingleton.sharedInstance.location?.getArea()?.name ?? ""
        btnLocation.setTitle(txt, for: .normal)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension DeliveryLocationTblCell{
    
    @IBAction func locationBtnClick(sender:UIButton){
        
        let vc = self.superview?.superview?.next as? ProductVariantVC
        vc?.actionArea(sender: sender)
    }
    
    @IBAction func btnClickedBuyNow(sender:UIButton){
        blockBuyNow?(product)
    }
    
    @IBAction func btnClickedWishList(sender:UIButton){
        sender.isSelected = !sender.isSelected
        blockAddRemoveWishList?(product)
    }
}
