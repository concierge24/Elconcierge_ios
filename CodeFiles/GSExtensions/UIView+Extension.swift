//
//  UIView+Extension.swift
//  Clikat
//
//  Created by cbl73 on 5/6/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import Foundation
import UIKit

enum XibError : Error {
    case XibNotFound
    case None
}



extension UIView {
    
    func loadViewFromNib(withIdentifier identifier : String) throws -> UIView? {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName:identifier, bundle: bundle)
        let xibs = nib.instantiate(withOwner: self, options: nil)
        
        if xibs.count == 0 {
            return nil
        }
        guard let firstXib = xibs[0] as? UIView else{
            throw XibError.XibNotFound
        }
        return firstXib
    }
    
}
