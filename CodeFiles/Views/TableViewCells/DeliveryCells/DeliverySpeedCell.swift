//
//  DeliverySpeedCell.swift
//  Clikat
//
//  Created by cblmacmini on 5/19/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

class DeliverySpeedCell: ThemeTableCell {

    @IBOutlet weak var imageViewChecked: UIImageView!
    @IBOutlet weak var labelDeliveryType: UILabel!
    @IBOutlet weak var labelDeliveryCharges: UILabel!
    @IBOutlet weak var labelDeliveryDesc : UILabel!
    
    var deliverySpeed : DeliverySpeed?{
        didSet{
            updateUI()
        }
    }
    var deliveryData : Delivery?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI(){
        guard let speed = deliverySpeed else { return }
        
        labelDeliveryType.text = speed.name
        imageViewChecked.image =  UIImage(asset: speed.selected ? Asset.Radio_on : Asset.Radio_off)
        imageViewChecked.setImageColor()
        labelDeliveryDesc.text = speed.type == .Postpone ? L10n.DeliveryChargesApplicableAccordingly.string : L10n.DeliveryCharges.string
        guard let type = deliverySpeed?.type else { return }
        
        switch type {
        case .Postpone, .scheduled:
            labelDeliveryCharges.text = ""
        case .Standard:
            labelDeliveryCharges.text = (/deliveryData?.deliveryCharges?.toDouble()).addCurrencyLocale
        case .Urgent:
            
            let urgentCharges = deliveryData?.urgentPrice?.toDouble() ?? 0
            labelDeliveryCharges.text = urgentCharges.addCurrencyLocale
        }
    }

}
