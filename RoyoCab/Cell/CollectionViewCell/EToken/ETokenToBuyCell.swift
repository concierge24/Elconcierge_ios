//
//  ETokenToBuyCell.swift
//  Buraq24
//
//  Created by MANINDER on 29/08/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit


typealias  ETokenSelected = (_ model : ETokenModel) -> ()
typealias  ETokenPurchasedSelected = (_ model : ETokenPurchased) -> ()


class ETokenToBuyCell: UICollectionViewCell {
    //MARK:- Outlets
      @IBOutlet var lblTotalToken: UILabel!
    @IBOutlet var lblGallonPerToken: UILabel!
     @IBOutlet var btnTokenPackagePrice: UIButton!
     @IBOutlet var viewOuter: UIView!
    
    //MARK:- Properties
    var eTokenSelectedBlock : ETokenSelected?
    var model : ETokenModel?
   
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        viewOuter.setCornerRadius(radius: 3)
        // Initialization code
    }
    //MARK:- Actions
    
    @IBAction func actionBtnBuyEtokenPressed(_ sender: UIButton) {
        if let model = model , let callback = eTokenSelectedBlock {
            callback(model)
        }
    }
    
    
    
    //MARK:- Functions
    
     func assignData(data : ETokenModel) {
        
        model = data
       let price = String(/data.price) + " " + (/UDSingleton.shared.appSettings?.appSettings?.currency)
        lblTotalToken.text = String(/data.quantityToken) + " " + "e_token".localizedString
          lblGallonPerToken.text =  data.categoryBrandProductName
         btnTokenPackagePrice.setTitle( price , for: .normal)
        viewOuter.createCustomGradient(colors: [UIColor.colorSkyBlueLightGradient.cgColor , UIColor.colorSkyBlueDarkGradient.cgColor ], startPoint:  CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 0, y: 0.5))
    }
    

}
