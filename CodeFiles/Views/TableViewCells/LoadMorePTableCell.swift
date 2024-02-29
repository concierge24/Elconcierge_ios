//
//  LoadMorePTableCell.swift
//  Sneni
//
//  Created by Sandeep Kumar on 07/06/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class LoadMorePTableCell: UITableViewCell {

    //MARK:- ======== Outlets ========
//    @IBOutlet weak var tableView: UITableView?
    
    //MARK:- ======== Variables ========
    
    
    //MARK:- ======== LifeCycle ========
    override func awakeFromNib() {
        super.awakeFromNib()
        initalSetup()
    }
    
    //MARK:- ======== Actions ========
    @IBAction func didTapViewMore(_ sender: Any) {
        let VC = ItemListingViewController.getVC(.main)
        VC.isOffers = true
        ez.topMostVC?.pushVC(VC)
    }
    
    //MARK:- ======== Functions ========
    func initalSetup() {
        
    }
}
