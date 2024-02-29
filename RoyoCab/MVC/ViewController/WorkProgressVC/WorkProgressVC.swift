//
//  WorkProgressVC.swift
//  Buraq24
//
//  Created by MANINDER on 27/10/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit

class WorkProgressVC: UIViewController,UITextViewDelegate {

    //MARK:- Outlets
    
    @IBOutlet var txtViewNotice: UITextView!
    @IBOutlet var lblAppName: UILabel!
    @IBOutlet var btnOk: UIButton!

    @IBOutlet var viewOuter: UIView!
    
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- Actions
    
    @IBAction func actionBtnOkPressed(_ sender: UIButton) {
        dismissVC(completion: nil)
    }
    
    
    //MARK:- Functions
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            let hitView = self.view.hitTest(firstTouch.location(in: self.view), with: event)
            if hitView === viewOuter {
                dismissVC(completion: nil)
            }
        }
    }
    
    func setUp() {
        lblAppName.text = "AppName".localizedString
        txtViewNotice.delegate = self
        let strNotice = "work_in_progress".localizedString + " " + customerCare1 + ", " + customerCare2
        txtViewNotice.text =  strNotice
        btnOk.setTitle("Ok".localizedString  , for: .normal)
     }
  
    
    //MARK:- TextView Delegate
    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        if (url.scheme?.contains(customerCare1))!{
            self.callToNumber(number: customerCare1)
        }else  if (url.scheme?.contains(customerCare2))!{
            self.callToNumber(number: customerCare2)
        }
        return true
    }
    

}
