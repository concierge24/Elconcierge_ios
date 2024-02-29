//
//  ThemeTableView.swift
//  Sneni
//
//  Created by MAc_mini on 25/01/19.
//  Copyright © 2019 Taran. All rights reserved.
//
class ThemeTableView: UITableView {
  
    override func awakeFromNib() {
        
        self.backgroundColor = TableThemeColor.shared.tblBgClr
    }
//    @IBInspectable public var isTableVwThemeClr: Bool = false{
//        didSet{
    
        // }
    //}
}
