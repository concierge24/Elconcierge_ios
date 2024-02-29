//
//  LiveSupportControllerExtension.swift
//  Clikat
//
//  Created by cblmacmini on 6/9/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import EZSwiftExtensions
extension LiveSupportViewController {

    //MARK: -  Keyboard Notifications
    
    func setUpKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(LiveSupportViewController.keyboardWillShow(n:)), name: UIResponder.keyboardWillShowNotification, object: self.view?.window)
        NotificationCenter.default.addObserver(self, selector: #selector(LiveSupportViewController.keyboardWillHide(n:)), name: UIResponder.keyboardWillHideNotification, object: self.view?.window)
    }
    
    @objc func keyboardWillShow(n : NSNotification){
        if let userInfo = n.userInfo{
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue)
            let rect = keyboardFrame.cgRectValue
            self.setOffset(hide: false,height: CGFloat(rect.height))
        }
    }
    @objc func keyboardWillHide (n : NSNotification){
        self.setOffset(hide: true,height: 0)
    }
    
    func setOffset (hide : Bool,height : CGFloat){
        
        if hide{
            
            self.constraintBottomTableView?.constant = 0
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                 weak var weakSelf = self
                weakSelf?.view.layoutIfNeeded()
                }, completion: { (animated) -> Void in
            })
        }
        else{
            self.constraintBottomTableView?.constant = height ;
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                 weak var weakSelf = self
                weakSelf?.view.layoutIfNeeded()
                }, completion: { (animated) -> Void in
                    weak var weakSelf = self
                    weakSelf?.scrollToBottom(animate: true)
            })
        }
    }
    
    func scrollToBottom(animate : Bool){
        guard let count = messages?.count else { return }
        if count > 0 {
            tableView?.scrollToRow(at: IndexPath(row: count - 1, section: 0), at: .top, animated: animate)
        }
    }
    
}
