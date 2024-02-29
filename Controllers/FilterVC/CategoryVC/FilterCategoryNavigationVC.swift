//
//  FilterCategoryNavigationVC.swift
//  Sneni
//
//  Created by Sandeep Kumar on 20/06/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class FilterCategoryNavigationVC: UINavigationController {

    //MARK:- ======== Outlets ========
    
    //MARK:- ======== Variables ========
    weak var objVc: FilterVC!
    var blockUpdate: (() -> ())?
    var isReset: Bool = false
//    var objFilter: FilterCategory = FilterCategory()
    
    //MARK:- ======== LifeCycle ========
    override func viewDidLoad() {
        super.viewDidLoad()
        initalSetup()
    }
    
    //MARK:- ======== Actions ========
    
    func reset() {
        isReset = true
        popToRootViewController(animated: false)
    }
//    @IBAction func didTapSubmit(_ sender: Any) {
//        
//    }
    
    //MARK:- ======== Functions ========
    func initalSetup() {
        
    }

}
