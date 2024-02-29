//
//  OrderDeliveryDetailView.swift
//  Clikat
//
//  Created by cblmacmini on 6/1/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

enum DeliveryDetailType {
    case Delivery
    case Pickup
}

class OrderDeliveryDetailView: UIView {

    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelAddresseName: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    
    var detailType : DeliveryDetailType = .Delivery
    var address : Address?
    var date : Date?
    var view : UIView!
    
    convenience init(frame: CGRect,type : DeliveryDetailType,address : Address?,date : Date?) {
        self.init(frame: frame)
        self.address = address
        self.date = date
        self.detailType = type
        updateUI()
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    
    func xibSetup() {
        
        do {
            view = try loadViewFromNib(withIdentifier: CellIdentifiers.OrderDeliveryDetailView)
            view.frame = bounds
            view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
            addSubview(view)
        }
        catch let exception{
            print(exception)
        }
    }

    
    func updateUI(){
        labelTime.text = UtilityFunctions.getTimeFormatted(format: DateFormat.TimeFormatUI, date: date ?? Date())
        labelDate.text = UtilityFunctions.getDateFormatted(format: DateFormat.DateFormatUI, date: date ?? Date())
//        labelAddresseName.text = address?.name
//        labelAddress.text = address?.addressString
        labelAddresseName.text = address?.area
        labelAddress.text = address?.address

        labelTitle.text = "Order to"
        //labelTitle.text = detailType == .Delivery ? L10n.Delivery.string : L10n.Pickup.string
    }

}
