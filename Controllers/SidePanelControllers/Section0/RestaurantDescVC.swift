//
//  RestaurantDetailVC.swift
//  Sneni
//
//  Created by Daman on 27/03/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit

class RestaurantDescVC: UIViewController {

    @IBOutlet weak var txtDesc: UITextView!
    
    var data: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        txtDesc.attributedText = data?.htmlToAttributedString(textView: txtDesc)
        txtDesc.setAlignment()

    }
    

    @IBAction func back_buttonAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
        }
    }

}
