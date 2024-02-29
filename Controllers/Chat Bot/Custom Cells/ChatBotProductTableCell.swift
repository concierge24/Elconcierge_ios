//
//  ChatBotProductTableCell.swift
//  Sneni
//
//  Created by Sandeep Kumar on 16/07/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

enum ChatIndexType {
    case first
    case middel
    case last
    case countOne
    case top
    case bottom
}
class ChatBotProductTableCell: UITableViewCell {
    
    //MARK:- ======== Outlets ========
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imgTitle: UIImageView!
    @IBOutlet var stepper: GMStepper?

    
    @IBOutlet weak var constraintTopStack: NSLayoutConstraint!
    @IBOutlet weak var constraintBottomStack: NSLayoutConstraint!

    //MARK:- ======== Variables ========
    var objModel: ProductF? = nil {
        didSet {
            stepper?.associatedProduct = objModel
            stepper?.isHide = true
            
            lblTitle?.text = objModel?.name
            lblSubTitle.text = "\(L10n.by.string) \(/(objModel?.supplierName))"
            imgTitle?.loadImage(thumbnail: objModel?.image, original: nil)

            objModel?.getPriceLabel(block: {
                [weak self] (value) in
                guard let self = self else { return }
                self.lblPrice?.text = value
//                self.stepper?.value = value ?? 0.0
            })
            
            stepper?.stepperValueListener = {
                [weak self] (value) in
                guard let self = self else { return }
                if let data = value as? Double {
                    self.stepper?.value = data
                }
//                self.updatePrice(type: type)
            }
            stepper?.value = 0.0
            
            DBManager.sharedManager.getProductToCart(productId: objModel?.id) {
                [weak self] (products) in
                guard let self = self else { return }
                
                let currentProduct = products.first
                self.stepper?.value = currentProduct?.quantity?.toDouble() ?? 0.0
                
            }
        }
    }
    
    var indexType: ChatIndexType = .first {
        didSet {
            
            switch indexType {
            case .first:
                constraintTopStack.constant = 0.0
                constraintBottomStack.constant = 8.0
            case .last:
                constraintTopStack.constant = 8.0
                constraintBottomStack.constant = 0.0
            case .countOne:
                constraintTopStack.constant = 8.0
                constraintBottomStack.constant = 8.0
            default:
                constraintTopStack.constant = 8.0
                constraintBottomStack.constant = 8.0
            }
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
    
    //MARK:- ======== Functions ========
    func initalSetup() {
        
    }
    
}
