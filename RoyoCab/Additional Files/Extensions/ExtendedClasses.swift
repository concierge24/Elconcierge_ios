//
//  UITextViewPlaceholder.swift
//  Merge
//
//  Created by Apple on 25/06/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation



//MARK: -----> Check Box
class CheckBox: UIButton {
    
    // Images
    @IBInspectable var checkedImage: UIImage?
    @IBInspectable var uncheckedImage: UIImage?
    @IBInspectable var selectedBackgroundColor: UIColor = UIColor.clear
    @IBInspectable var unSelectedBackgroundColor: UIColor = UIColor.clear
    @IBInspectable var selectedTextColor: UIColor = UIColor.clear
    @IBInspectable var unSelectedTextColor: UIColor = UIColor.clear
    
    
    // Bool property
    @IBInspectable var isChecked: Bool = false {
        didSet{
            if isChecked {
                setImage(checkedImage, for: .normal)
                backgroundColor = selectedBackgroundColor
                setTitleColor(selectedTextColor, for: .normal)
                
            }else {
                setImage(uncheckedImage, for: .normal)
                backgroundColor = unSelectedBackgroundColor
                setTitleColor(unSelectedTextColor, for: .normal)
                
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(buttonClicked), for: UIControl.Event.touchUpInside)
        self.isChecked = false
        
    }
    
    @objc func buttonClicked(sender: UIButton) throws {
        switch sender == self {
        case true:
            isChecked = !isChecked
        default: break
        }
    }
}

//MARK: -----> TextView With Placeholder
typealias TextViewShouldChangeBlock = (String, CGFloat) -> ()
class TextViewplaceholder: UITextView, UITextViewDelegate {
    
    @IBInspectable var placeholder: String?
    @IBInspectable var placeholderColor: UIColor?
    @IBInspectable var maxLimit: Int = 10000000
    
    @IBInspectable var textValue: String {
        get {
            if self.text == placeholder {
                return ""
            }
            return self.text
        }
        set {
            text = newValue
        }
    }
    
    var textViewShouldChangeBlock: TextViewShouldChangeBlock?
    
    override func awakeFromNib() {
        delegate = self
        textColor = UIColor.lightGray
        text = (textValue == "") ? placeholder : textValue
        textColor = (placeholderColor != nil) ? placeholderColor : UIColor.lightGray
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if text == placeholder {
            text = ""
            textColor = UIColor.black
            
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if text == "" {
            text = placeholder
            textColor = (placeholderColor != nil) ? placeholderColor : UIColor.lightGray
            
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if let str = textView.text, let textRange = Range(range, in: str) {
            let updatedText = str.replacingCharacters(in: textRange, with: text)
            
            if let block = textViewShouldChangeBlock {
                block(updatedText, textView.contentSize.height)
                
            }
            
            return updatedText.count < maxLimit
        }
        
        return true
    }
}
