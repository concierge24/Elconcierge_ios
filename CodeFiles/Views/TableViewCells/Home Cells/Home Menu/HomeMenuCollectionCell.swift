//
//  HomeMenuCollectionCell.swift
//  Sneni
//
//  Created by Sandeep Kumar on 14/06/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class HomeMenuCollectionCell: UICollectionViewCell {
    
    //MARK:- ======== Outlets ========
    @IBOutlet var imgSerivce: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    
    //MARK:- ======== Variables ========
    var objModel : HomeMenuType? {
        didSet {
            lblTitle?.text = /objModel?.rawValue
            imgSerivce.image = objModel?.image
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
