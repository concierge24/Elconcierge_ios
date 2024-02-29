//
//  SKToast.swift
//  Sneni
//
//  Created by Sandeep Kumar on 30/05/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import Foundation

class SKToast {

    static func makeToast(_ msg: String?, duration: Double = 3.0) {
        guard let msg = msg else { return }
        let style = CSToastStyle.init(defaultStyle: ())
        style?.titleColor = UIColor.white
        style?.backgroundColor = SKAppType.type.color
        UIApplication.appDelegate?.window?.makeToast(msg, duration: duration, position: CSToastPositionBottom, style: style)
    }
    
}
