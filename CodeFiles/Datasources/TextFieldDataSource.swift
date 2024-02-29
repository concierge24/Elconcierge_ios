//
//  TextFieldDataSource.swift
//  Clikat
//
//  Created by cblmacmini on 5/13/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

typealias TextFieldReturn = (_ textField : UITextField) -> ()

class TextFieldDataSource: NSObject {

    var textField : UITextField?
    var textFieldReturnBlock : TextFieldReturn?
    var viewController : UIViewController?
    
    init(textField : UITextField,sender : UIViewController) {
        super.init()
        self.textField = textField
        self.viewController = sender
        self.textField?.delegate = self
    }
    
    override init() {
        super.init()
    }
}

extension TextFieldDataSource : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewController?.view.endEditing(true)
        return true
//        guard let block = textFieldReturnBlock else {
//            return false
//        }
//        block(textField: textField)
//        return true
    }
}

