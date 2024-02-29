//
//  PrescriptionRequestCell.swift
//  Sneni
//
//  Created by Daman on 01/05/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit

enum PrescriptionStatus: Int {
    case pending = 0
    case approved
    case rejectedByAdmin
    case cancelledByUser
    case orderCreated
    
    var title: String {
        switch self {
        case .pending:
            return "Pending".localized()
        case .approved:
            return "Approved".localized()
        case .rejectedByAdmin:
            return "Rejected by Admin".localized()
        case .cancelledByUser:
            return "Cancelled by User".localized()
        case .orderCreated:
            return "Order Created".localized()
        }
    }
}

class PrescriptionRequestCell: UITableViewCell {

    @IBOutlet var lblStatus: ThemeLabel!
    @IBOutlet var imgPres: UIImageView!
    @IBOutlet var lblRequestId: ThemeLabel!
    @IBOutlet var lblCreatedOn: ThemeLabel!
    @IBOutlet var lblTitleSupplier: ThemeLabel!
    @IBOutlet var lblSupplierName: ThemeLabel!
    @IBOutlet var btnCancel: ThemeButton!
    
    var cancelPressed: EmptyBlock?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(_ model: RequestModel) {
        btnCancel.isHidden = model.status != .pending
        lblStatus.text = model.status.title
        imgPres.loadImage(thumbnail: model.image, original: nil)
        lblSupplierName.text = model.supplierName
        lblRequestId.text = "\(/model.requestId)"
        lblCreatedOn.text = model.createdAt
        lblTitleSupplier.text = "\(TerminologyKeys.supplier.localizedValue() as? String ?? "") \("Name:".localized())"
    }
    
    @IBAction func cancelRequest(_ sender: Any) {
        cancelPressed?()
    }
    
}
