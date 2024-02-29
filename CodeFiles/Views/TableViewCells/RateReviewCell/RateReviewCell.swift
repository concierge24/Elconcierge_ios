//
//  RateReviewCell.swift
//  Sneni
//
//  Created by Mac_Mini17 on 20/03/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit
import Cosmos

enum RateType {
    case product
    case supplier
    case agent
    
    var title: String {
        switch self {
        case .product:
            return TerminologyKeys.product.localizedValue(prefix: "Rate") as? String ?? ""
        case .supplier:
            return TerminologyKeys.supplier.localizedValue(prefix: "Rate") as? String ?? ""
        case .agent:
            return TerminologyKeys.agent.localizedValue(prefix: "Rate") as? String ?? ""
        }
    }
}

class RateReviewCell: UITableViewCell {
    
    //MARK:- IBOutlet
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var supplierLabel: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var rateView: CosmosView!
    @IBOutlet weak var txtView: UITextView!{
        didSet{
            txtView.text = "Write review here..."
            txtView.textColor = UIColor.lightGray
        }
    }
    var rateType: RateType = .product
    var orderDetails : OrderDetails?
    var product:ProductF?
    var productRated: EmptyBlock?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell() {
        switch rateType {
        case .product:
            nameLabel?.text = product?.name
            supplierLabel.isHidden =  true//AppSettings.shared.isSingleVendor
            supplierLabel?.text = product?.supplierName
            itemImageView.loadImage(thumbnail: product?.images?.first, original: nil)
        case .supplier:
            nameLabel?.isHidden = true
            supplierLabel.isHidden =  false
            supplierLabel?.text = orderDetails?.supplierName
            itemImageView.loadImage(thumbnail: orderDetails?.logo, original: nil)
        case .agent:
            let cblUser = orderDetails?.agentArray?.first
            //                        lblExperience.text = "\(/cblUser?.experience) \(L11n.yearsExperience.string)"
            nameLabel?.text = cblUser?.name
            supplierLabel.isHidden =  false
            supplierLabel?.text = cblUser?.occupation
            itemImageView.loadImage(thumbnail: cblUser?.image, original: nil, placeHolder: Asset.ic_dummy_user.image)
        }
    }

}


extension RateReviewCell{
    
    @IBAction func submitBtnClick(sender:UIButton){
        
        guard rateView.rating > 0 else {
            UtilityFunctions.showAlert(message: "Please select rating.")
            return
        }
        
        switch rateType {
        case .product:
            self.webServiceRateProduct()
        case .supplier:
            return webServiceRateSupplier()
        case .agent:
            return webServiceRateAgent()
        }
    }
}

// MARK: - UITextViewDelegate
extension RateReviewCell:UITextViewDelegate{
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write review here..."
            textView.textColor = UIColor.lightGray
        }
    }
  
}

// MARK: - WebServiceProductVariantList
extension RateReviewCell{
    
    func webServiceRateProduct()  {
        APIManager.sharedInstance.opertationWithRequest(withApi: API.RateProduct(isOrder: false, value:rateView.rating.toString, product_id: product?.id, order_id: orderDetails?.orderId, reviews: txtView.text, title:/(txtField.text))) { (response) in
            
            switch response{
                
            case .Success(_):
//                self.productRated?()
                let vc = self.superview?.superview?.next as? RateReviewsVC
                vc?.delegate?.updateProductDetail()
                vc?.popVC()
                break
            default :
                break
            }
        }
    }
    
    func webServiceRateSupplier()  {
        guard let supplietId = orderDetails?.supplier_id else { return }
       
        APIManager.sharedInstance.opertationWithRequest(withApi:  API.RateSupplier(orderId: orderDetails?.orderId ?? "", supplierId: supplietId, rating:rateView.rating.toString, title: /(txtField.text), comment: txtView.text)) { (response) in
            
            switch response{
                
            case .Success(_):
                let vc = self.superview?.superview?.next as? RateReviewsVC
                vc?.delegate?.updateProductDetail()
                vc?.popVC()
                break
            default :
                break
            }
        }
    }
    
    func webServiceRateAgent()  {
        APIManager.sharedInstance.opertationWithRequest(withApi: API.RateProduct(isOrder: true, value:rateView.rating.toString, product_id: orderDetails?.orderId, order_id: orderDetails?.orderId, reviews: txtView.text, title:/(txtField.text))) { (response) in
            
            switch response{
                
            case .Success(_):
                let vc = self.superview?.superview?.next as? RateReviewsVC
                vc?.delegate?.updateProductDetail()
                vc?.popVC()
                break
            default :
                break
            }
        }
    }

}
