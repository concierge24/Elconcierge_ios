//
//  PromoCodeTableViewCell.swift
//  Trava
//
//  Created by Apple on 02/12/19.
//  Copyright © 2019 CodeBrewLabs. All rights reserved.
//

import UIKit

protocol PromoCodeTableViewCellDelegate: class {
    func applyCodeClicked(object: Coupon?)
}

class PromoCodeTableViewCell: UITableViewCell {

    @IBOutlet weak var labelPromoName: UILabel!
    @IBOutlet weak var labelPromoDesc: UILabel!
    @IBOutlet weak var labelPromoExpiry: UILabel!
    @IBOutlet weak var buttonApply: UIButton!
    
    var indexPath: IndexPath?
    var item: Coupon?
    weak var delegate: PromoCodeTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        buttonApply.setTitleColor( UIColor(hexString: "#745BF2", alpha: 1.0), for: .normal)
        buttonApply.setButtonWithTitleColorSecondary()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func assignData(indexPath: IndexPath?, item: Coupon?) {
        self.indexPath = indexPath
        self.item = item
        
        labelPromoName.text = /item?.code
        labelPromoExpiry.text = item?.expiresAt?.getLocalDate()?.toLocalDateInString(format: "MMM dd, YYYY ")
        
        if item?.couponType == "Value" {
            labelPromoDesc.text = "Get flat \((/UDSingleton.shared.appSettings?.appSettings?.currency)) \(/item?.amountValue) Off on first \(/item?.ridesValue) rides"
        } else {
            labelPromoDesc.text = "Get \(/item?.amountValue)% Off on first \(/item?.ridesValue) rides"
        }
    }
}

extension PromoCodeTableViewCell {
    @IBAction func buttonApplyClicked(_ Sender: Any) {
        delegate?.applyCodeClicked(object: item)
    }
}
