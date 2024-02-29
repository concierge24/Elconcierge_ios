//
//  PhoneNumberTableViewCell.swift
//  Trava
//
//  Created by Apple on 09/12/19.
//  Copyright © 2019 CodeBrewLabs. All rights reserved.
//

import UIKit
import EPContactsPicker

protocol PhoneNumberTableViewCellDelegate: class {
    func crossClicked(indexPath: IndexPath? )
}

class PhoneNumberTableViewCell: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelContactNumber: UILabel!
    
    var indexPath: IndexPath?
    weak var delegate: PhoneNumberTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func assignData(item: ContactNumberModal?, indexPath: IndexPath?) {
        
        self.indexPath = indexPath
        
        labelContactNumber.text = "\(/item?.countryCode) \(/item?.contactNumber)"
        labelName.text = item?.name ?? "Annonymous"
    }
    
    @IBAction func buttonCrossClicked(_ sender: Any) {
        delegate?.crossClicked(indexPath: indexPath)
    }
}
