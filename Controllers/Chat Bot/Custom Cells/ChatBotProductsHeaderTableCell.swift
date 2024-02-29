//
//  ChatBotProductsHeaderTableCell.swift
//  Sneni
//
//  Created by Sandeep Kumar on 16/07/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class ChatBotProductsHeaderTableCell: UITableViewCell {
    
    //MARK:- ======== Outlets ========
    @IBOutlet weak var viewTop: UIView?
    @IBOutlet weak var viewBottom: UIView?

    //MARK:- ======== Variables ========
    var isHeader: Bool = false {
        didSet {
            viewTop?.isHidden = isHeader
            viewBottom?.isHidden = !isHeader
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
