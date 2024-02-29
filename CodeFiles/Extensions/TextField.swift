//
//  TextField.swift
//  Clikat Supplier
//
//  Created by MAc_mini on 01/02/19.
//  Copyright © 2019 Gagan. All rights reserved.
//
import Material

extension TextField{
    
    func setThemeTextField()  {
        
        self.placeholderNormalColor = .darkGray
        self.placeholderActiveColor = TextFieldTheme.shared.txtFld_PlaceholderActiveColor
        self.textColor = TextFieldTheme.shared.txtFld_TextColor
        self.dividerActiveColor = TextFieldTheme.shared.txtFld_DividerActiveColor
        self.dividerColor = TextFieldTheme.shared.txtFld_DividerColor
        self.dividerNormalColor = TextFieldTheme.shared.txtFld_DividerColor

        if L102Language.isRTL {
            self.textAlignment = .right
            semanticContentAttribute = .forceRightToLeft
            self.rightView = nil
        }else {
            self.textAlignment = .left
            semanticContentAttribute = .forceLeftToRight
        }
    }
    
    func setNewThemeTextField()  {
        
        self.placeholderNormalColor = .lightGray
        self.placeholderActiveColor = TextFieldTheme.shared.txtFld_PlaceholderActiveColor
        self.textColor = TextFieldTheme.shared.txtFld_TextColor
        self.dividerActiveColor = UIColor.clear
        self.dividerColor = UIColor.clear
        self.dividerNormalColor = UIColor.clear
        if L102Language.isRTL {
            self.textAlignment = .right
            semanticContentAttribute = .forceRightToLeft
            self.rightView = nil
        }else {
            self.textAlignment = .left
            semanticContentAttribute = .forceLeftToRight
        }

    }
    
}

extension UITableView {
    
    func reloadTableViewData(inView view: UIView?) {
        
        guard let tempView = view else { return }
        UIView.transition(
            with: tempView,
            duration: 0.1,
            options: [.curveEaseInOut, .transitionCrossDissolve],
            animations: {
                [weak self] () -> Void in
                guard let self = self else { return }
                self.reloadData()
            }, completion: nil)
        
    }
}



