//
//  ThemeTextField.swift
//  Sneni
//
//  Created by MAc_mini on 23/01/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class ThemeTextField: UITextField {

    @IBInspectable public var isVisibleTextFieldColor: Bool = true{
        didSet{
            
            self.textColor = TextFieldTheme.shared.txtFldThemeColor
            self.tintColor = TextFieldTheme.shared.txtCursorColor
//            self.font = UIFont(openSans: .boldItalic, size: 11.0)
          
        }
    }

}
