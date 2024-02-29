//
//  UIButton+Kerning.swift
//  Clikat
//
//  Created by Night Reaper on 20/05/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import Foundation
import UIKit


extension UIButton {
    
    func kern(kerningValue:CGFloat) {
        let attributedText =  NSAttributedString(string: /self.titleLabel?.text, attributes: [NSAttributedString.Key.kern:kerningValue, NSAttributedString.Key.font:self.titleLabel?.font ?? UIFont(), NSAttributedString.Key.foregroundColor:self.titleLabel?.textColor ?? UIColor.clear])
        self.setAttributedTitle(attributedText, for: .normal)
    }
}


extension UILabel{
    func kern(kerningValue:CGFloat){
        let attributedString = NSMutableAttributedString(string: self.text!)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(kerningValue), range: NSRange(location: 0, length: self.text!.count))
        self.attributedText = attributedString
    }
}
