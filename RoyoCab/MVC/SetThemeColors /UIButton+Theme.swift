//
//  UIButton+Theme.swift
//  RoyoRide
//
//  Created by Rohit Prajapati on 11/05/20.
//  Copyright © 2020 CodeBrewLabs. All rights reserved.
//

import Foundation

class ThemeButtonCab: UIButton {
    
      var themeColor = UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.Primary_colour ?? DefaultColor.color.rawValue)

        required init?(coder aDecoder: NSCoder) {
              // set myValue before super.init is called
              super.init(coder: aDecoder)

              // set other operations after super.init, if required
              backgroundColor = themeColor
          }

    
   
     
}
