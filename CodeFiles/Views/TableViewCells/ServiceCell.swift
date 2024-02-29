//
//  ServiceCell.swift
//  Clikat
//
//  Created by cbl73 on 5/7/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import Material

class ServiceBaseCell : TableViewCell {
    
}

class ServiceCell: SKSTableViewCell {

    
    var service : Laundry? {
        didSet{
            updateUI()
        }
    }
    
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblDesc : UILabel!

    
    private func updateUI(){
        
        lblTitle?.text = service?.subCategoryName
        lblDesc?.text = service?.subCategoryDesc
        
    }

}
