//
//  ThemeTextView.swift
//  Sneni
//
//  Created by MAc_mini on 25/01/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class ThemeTextView: UITextView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setAlignment()
    }
    
    @IBInspectable public var isVisibleTextViewClr: Bool = false{
        didSet{
            
            if isVisibleTextViewClr ==  false{
                
                
            }
            
            
        }
    }
    

   
//    @IBInspectable public var isTextVwClr: Bool = false{
//        didSet{
//            
//            if isTextVwClr ==  false {
//                
//                self.attributedText.color(ColorTheme.shared.lblSubTitleClr)
//            }
//           
//            
//        }
//    }
   

}
