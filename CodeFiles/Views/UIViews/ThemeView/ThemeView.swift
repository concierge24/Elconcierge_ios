//
//  ThemeView.swift
//  Sneni
//
//  Created by MAc_mini on 21/01/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

 class ThemeView: UIView {

   
    @IBInspectable public var isCellView: Bool = false{
        didSet{
            if isCellView == false{
                self.backgroundColor = TableThemeColor.shared.cellThemeColor
            }
        }
    }
    
    @IBInspectable public var isView: Bool = false{
        didSet{
            if isView == false{
                self.backgroundColor = ViewThemeColor.shared.viewThemeColor
            }
        }
    }
    
    @IBInspectable public var themeView: Bool = false{
        didSet{
            if themeView {
                self.backgroundColor = ViewThemeColor.shared.viewThemeColor
            }
        }
    }
    
    @IBInspectable public var isBoaderViewColor: Bool = false {
        didSet{
            if isBoaderViewColor {
                layer.borderWidth = 1
                layer.borderColor = ViewThemeColor.shared.viewBoaderThemeColor.cgColor
            }
            else {
                layer.borderWidth = 0
            }
        }
    }
    
    @IBInspectable public var isNavViewHeader: Bool = false{
        didSet{
            if isNavViewHeader == false {
                self.backgroundColor = ViewThemeColor.shared.viewNavThemeColor
            }
            else {
                self.backgroundColor = SKAppType.type.headerColor
            }
        }
    }
    
    @IBInspectable public var isSearchView: Bool = false{
        didSet{
            if isSearchView == true{
                self.backgroundColor = UIColor.groupTableViewBackground //ViewThemeColor.shared.viewSearchThemeColor
            }
        }
    }
    
    @IBInspectable public var viewHighlightIndicator: Bool = false{
        didSet{
            if viewHighlightIndicator == true {
                self.backgroundColor = ViewThemeColor.shared.viewHighlightColor
            }
        }
    }
    
    @IBInspectable public var viewLeftMenu: Bool = false{
        didSet{
            if viewLeftMenu == true{
                self.backgroundColor = ViewThemeColor.shared.viewLeftDrawerColor
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
 
}

