//
//  ContactCell.swift
//  Buraq24
//
//  Created by MANINDER on 07/09/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit

typealias  EContact = (_ model : EmergencyContact) -> ()
typealias  DelelteContact = (_ model : EmergencyContact) -> ()


class ContactCell: UITableViewCell {
    
    //MARK:-  Outlets
    @IBOutlet var lblName: UILabel!
    @IBOutlet weak var btnVontact: UIButton!
    @IBOutlet var lblContactNumber: UILabel!
    @IBOutlet var imgViewContact: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var btnCross: UIButton!
    
    
     //MARK:-  Outlets
    var callBackBtn : EContact?
    var deleteContact:DelelteContact?
    var model : EmergencyContact?
    
     //MARK:-  View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgView.setViewBorderColorSecondary()
        btnVontact.setButtonWithTintColorSecondary()
        btnCross.setButtonWithTintColorSecondary()
        lblContactNumber.setTextColorSecondary()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- Actions
    @IBAction func actionBtnCallPressed(_ sender: Any) {
        
        guard let contact = model , let callback = callBackBtn else{return}
         callback(contact)
    }
    
    @IBAction func btnCrossPressedAction(_ sender: Any) {
        
        guard let contact = model , let deleteContact = deleteContact else{return}
        deleteContact(contact)
    }
    
    
    
    func assignCellData(model : EmergencyContact) {
        
        self.model = model
        lblName.text = /model.name
        guard let phNumber = model.phoneNumber else{return}
        lblContactNumber.text = "\(phNumber)"
      //  imgViewContact.image = UIImage(named: "emergency\(/model.contactId)")
        //3April
       // APIBasePath.baseImagePath +
        if let url = URL(string: /model.image){
            
            imgViewContact.kf.setImage(with: url)
        }
    }
}
