//
//  CardTableViewCell.swift
//  SideDrawer
//
//  Created by Apple on 16/11/18.
//  Copyright © 2018 Codebrew Labs. All rights reserved.
//

import UIKit

protocol CardTableViewCellDelegate : class {
    func buttonDeleteClicked(index : Int?)
}

class CardTableViewCell: UITableViewCell {

    //MARK:- Outlet
    
    @IBOutlet weak var lblValidTitle: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelCardNumber: UILabel!
    @IBOutlet weak var labelExpiry: UILabel!
    
    @IBOutlet weak var imageViewDefault: UIImageView!
  //  @IBOutlet weak var imageViewCard: UIImageView!
    
    @IBOutlet weak var buttonDelete: UIButton!
    
    //MARK:- Properties
    weak var delegate : CardTableViewCellDelegate?
    
    var row : Int? {
        didSet {
            buttonDelete.tag = /row
        }
    }
    
    var obj : CardCab? {
        didSet {
             let paymentGateway = PaymentGateway(rawValue:(/UDSingleton.shared.appSettings?.appSettings?.gateway_unique_id))
              labelName.text = obj?.cardHolderName
            switch paymentGateway {
            case .stripe:
                
                labelCardNumber.text = "**** **** **** \(/obj?.lastDigit)"
                
                labelExpiry.text = (/obj?.expMonth) + "/" + (/obj?.expYear)
            case .conekta:
                          
                lblValidTitle.isHidden = true
                labelExpiry.isHidden = true
                
                 labelCardNumber.text = "**** **** **** \(/obj?.lastDigit)"
                      
            case .epayco:
                
                labelCardNumber.text = "\(/obj?.lastDigit)"
                
                labelExpiry.text = (/obj?.expMonth) + "/" + (/obj?.expYear)
                
            case .peach:
                labelCardNumber.text = "\(/obj?.last4)"
                labelExpiry.text = (/obj?.expMonth) + "/" + (/obj?.expYear)
                
            default:
                labelCardNumber.text = obj?.cardNo
                
                labelExpiry.text = (/obj?.cardExpiry)
            }
          
            
            
           // imageViewDefault.isHidden = obj?.defaultStatus == 0
          //  imageViewCard.image = CardType(rawValue: /obj?.typeOfCard)?.cardImage
        }
    }
    
    
    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- Button Selector
    @IBAction func buttonDeleteClicked(_ sender: Any) {
        delegate?.buttonDeleteClicked(index: /row)
    }
}
