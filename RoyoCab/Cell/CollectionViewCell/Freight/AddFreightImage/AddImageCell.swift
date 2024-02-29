//
//  AddImageCell.swift
//  Buraq24
//
//  Created by MANINDER on 05/10/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit


typealias  CellImageToBeDelete = (_ cell : AddImageCell) -> ()  // Completion Handler for Deletion Image


class AddImageCell: UICollectionViewCell {
    
    
    //MARK:- Outlets
    
    @IBOutlet var imgViewProduct: UIImageView!
    
    
    //MARK:- Properties
    
    var callBackDeletion : CellImageToBeDelete? = nil
    
    
    
    //MARK:- Actions
    
    @IBAction func actionBtnDeletePressed(_ sender: UIButton) {
        
        if let callback = self.callBackDeletion {
            callback(self)
        }
    }
    
    
    //MARK:- Functions
    
    
    func assignCellData(image : UIImage) {
        imgViewProduct.image = image
    }
    
}
