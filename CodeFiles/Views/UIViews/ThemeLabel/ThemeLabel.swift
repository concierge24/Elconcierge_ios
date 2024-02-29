//
//  ThemeLabel.swift
//  Sneni
//
//  Created by MAc_mini on 23/01/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class SKThemeLabel: UILabel {
    
    @IBInspectable public var textColorId: String = "" {
        didSet {
            guard let id = SKThemeButtonColorId(rawValue: textColorId) else { return }
            self.textColor = id.color
        }
    }
}

extension UILabel {
    open override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

class ThemeLabel: SKThemeLabel {
    
    @IBInspectable public var isVisibleNavLblTxtColor: Bool = true{
        didSet{
            if isVisibleNavLblTxtColor == true{
                self.textColor = SKAppType.type.headerTextColor //LabelThemeColor.shared.lblNavTitleThemeColor
                self.font = UIFont(openSans: .regular, size: 18.0)
            }
        }
    }
    
    @IBInspectable public var isThemeColor: Bool = true{
        didSet {
            if isThemeColor == true {
                self.textColor = SKAppType.type.color
            }
        }
    }
    
    @IBInspectable public var themeLbl: Bool = true{
        didSet{
            if themeLbl == true{
                
                
               // self.textColor = LabelThemeColor.shared.themeLblColor
                
                //self.font = UIFont(openSans: .bold, size: 15.0)
                
            }
        }
    }

    @IBInspectable public var isVisibleLblTextColor: Bool = true{
        didSet{
            if isVisibleLblTextColor == true{
                // self.textColor = LabelThemeColor.shared.lblThemeColor
                 // self.font = UIFont(openSans: .semiboldItalic, size: 15.0)
            }
          }
        }
    
    @IBInspectable public var isLblTilte: Bool = true{
        didSet{
            if isLblTilte == true{
                
               // self.textColor = LabelThemeColor.shared.lblTitleClr
               // self.font = UIFont(openSans: .boldItalic, size: 13.0)
                 
            }
        }
    }
    
    @IBInspectable public var isLblSubTilte: Bool = true{
        didSet{
            if isLblSubTilte == true{
               // self.textColor = LabelThemeColor.shared.lblSubTitleClr
                // self.font = UIFont(openSans: .semibold, size: 11.0)
            }
        }
    }
    
    @IBInspectable public var isLblLightTxt: Bool = true{
        didSet{
            if isLblLightTxt == true{
               // self.textColor = LabelThemeColor.shared.lblLightTitleClr
                // self.font = UIFont(openSans: .boldItalic, size: 11.0)
            }
        }
    }
    
    @IBInspectable public var isLblStatusColor: Bool = true{
        didSet{
            if isLblStatusColor == true{
              //  self.textColor = StatusThemeColor.shared.busyStatusColor
               // self.font = UIFont(openSans: .lightItalic, size: 11.0)
            }
        }
    }
    
    
    @IBInspectable public var isLblSectionHeader: Bool = true{
        didSet{
            if isLblSectionHeader == true{
               // self.textColor = TableThemeColor.shared.lblSectionHeaderClr
               //  self.font = UIFont(openSans: .bold, size: 15.0)
            }
        }
    }
    
    
    @IBInspectable public var isTableTitleLbl: Bool = true{
        didSet{
            if isTableTitleLbl == true{
                self.textColor = SKAppType.type.elementColor
               // self.textColor = TableThemeColor.shared.cellTblTitleClr
              //  self.font = UIFont(openSans: .boldItalic, size: 11.0)
//                self.textColor = ColorTheme.shared.lblSectionHeaderClr
//                self.font = UIFont(openSans: .bold, size: 15.0)
            }
        }
    }
    
    @IBInspectable public var isTableSubTitleLbl: Bool = true{
        didSet{
            if isTableSubTitleLbl == true{
                self.textColor = SKAppType.type.grayTextColor
              //  self.textColor = TableThemeColor.shared.cellTblSubTitleClr
                //self.font = UIFont(openSans: .semibold, size: 11.0)
//                self.textColor = ColorTheme.shared.lblSectionHeaderClr
//                self.font = UIFont(openSans: .bold, size: 15.0)
            }
        }
    }
    
    @IBInspectable public var isTableDescLbl: Bool = true{
        didSet{
            if isTableDescLbl == true{
                
             //   self.textColor = TableThemeColor.shared.cellTblDescClr
                //self.font = UIFont(openSans: .boldItalic, size: 11.0)
//                self.textColor = ColorTheme.shared.lblSectionHeaderClr
//                self.font = UIFont(openSans: .bold, size: 15.0)
            }
        }
    }
    
    @IBInspectable public var isCollectionTitleLbl: Bool = true{
        didSet{
            if isCollectionTitleLbl == true{
             //   self.textColor = CollectionThemeColor.shared.collectionTitleClr
               // self.font = UIFont(openSans: .bold, size: 11.0)
            }
        }
    }
    
    @IBInspectable public var isCollectionSubTitleLbl: Bool = true{
        didSet{
            if isCollectionSubTitleLbl == true{
             //   self.textColor = CollectionThemeColor.shared.collectionSubTitleClr
               // self.font = UIFont(openSans: .bold, size: 11.0)
            }
        }
    }
    
    @IBInspectable public var isCollectionDescLbl: Bool = true{
        didSet{
            if isCollectionDescLbl == true{
                
              //  self.textColor = CollectionThemeColor.shared.collectionDescClr
               // self.font = UIFont(openSans: .bold, size: 11.0)
            }
        }
    }
    
    @IBInspectable public var leftMenuTitleLbl: Bool = true{
        didSet{
            if leftMenuTitleLbl == true{
                
              //  self.textColor = LabelThemeColor.shared.lblMenuTitleClr
                //self.font = UIFont(openSans: .bold, size: 11.0)
            }
        }
    }
    
    @IBInspectable public var leftMenuSubTitleLbl: Bool = true{
        didSet{
            if leftMenuSubTitleLbl == true{
                
            //    self.textColor = LabelThemeColor.shared.lblMenuTitleClr
                //self.font = UIFont(openSans: .bold, size: 11.0)
            }
        }
    }

}
