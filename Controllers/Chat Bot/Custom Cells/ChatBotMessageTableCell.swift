//
//  ChatBotMessageTableCell.swift
//  Sneni
//
//  Created by Sandeep Kumar on 16/07/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class ChatBotMessageTableCell: UITableViewCell {
    
    //MARK:- ======== Outlets ========
    
    @IBOutlet weak var viewSender: UIView?
    @IBOutlet weak var lblSender: UILabel?
    
    @IBOutlet weak var viewReciver: UIView?
    @IBOutlet weak var lblReciver: UILabel?

    //MARK:- ======== Variables ========
    var isSender: Bool = false {
        didSet  {
            viewSender?.isHidden = !isSender
            viewReciver?.isHidden = isSender
        }
    }
    
    var message: String = "" {
        didSet  {
            lblSender?.text = message
            lblReciver?.text = message
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
        isSender = true
    }
    
}
