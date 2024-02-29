//
//  HomeCurrentOrderCollectionCell.swift
//  Sneni
//
//  Created by Sandeep Kumar on 25/07/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class HomeCurrentOrderCollectionCell: UICollectionViewCell {
    
    //MARK:- ======== Outlets ========
    @IBOutlet weak var lblOrderNo: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnView: UIButton! {
        didSet {
            btnView.isUserInteractionEnabled = false
        }
    }
    
    //MARK:- ======== Variables ========
    var objModel: OrderDetails? {
        didSet {
            lblOrderNo.text = "\(L10n.OrderNo.stringFor(appType: objModel?.appType)) : " + /objModel?.orderId
            lblSubTitle.text = objModel?.status.stringValue(deliveryType: objModel?.deliveryStatus ?? .delivery, appType: objModel?.appType)
            lblPrice.text = "\("Order Price".localized()) : " + /objModel?.netAmount?.toDouble()?.addCurrencyLocale
//            lblSubTitle.textColor = objModel?.status.color()
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
        backgroundColor = UIColor.clear

    }

}
