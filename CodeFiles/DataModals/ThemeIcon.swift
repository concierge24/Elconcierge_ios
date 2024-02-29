//
//  ThemeIcon.swift
//  Sneni
//
//  Created by MAc_mini on 28/01/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import Foundation
struct ImageIcon {
    
     static let shared = ImageIcon()
    
     var btnMenu_Icon:UIImage
     var btnLanguage_Icon:UIImage
     var btnCart_Icon:UIImage
     var btnFilter_Icon:UIImage
     //var btnFav_Icon:UIImage
     var btnShare_Icon:UIImage
     var btnBack_Icon:UIImage
     var btnBarCode_Icon:UIImage
     var btnSearch_Icon:UIImage
     var btnLoc_Icon:UIImage
   
    
    private init() {
        
        self.btnMenu_Icon = UIImage(asset: Asset.Ic_menu)
        self.btnLanguage_Icon = UIImage(asset: Asset.Flag_ead)
        self.btnCart_Icon = UIImage(asset: Asset.Ic_cart)
        self.btnFilter_Icon = UIImage(asset: Asset.Ic_filter)
       // self.btnFav_Icon = UIImage(asset: Asset.Ic_share_white)
        self.btnShare_Icon = UIImage(asset: Asset.Ic_share_white)
        self.btnBack_Icon = UIImage(asset: Asset.Ic_back)
        self.btnBarCode_Icon = UIImage(asset: Asset.Ic_barcode_scan)
        self.btnSearch_Icon = UIImage(asset: Asset.Ic_search)
        self.btnLoc_Icon = UIImage(asset: Asset.Ic_sp_location)
      
        
    }

}
