//
//  HomeSearchCell.swift
//  Clikat
//
//  Created by cbl20 on 9/30/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import Material

class HomeSearchCell: ThemeTableCell {

    typealias ActionBarCode = () -> ()
    typealias ActionSerach = (_ searchKey : String?) -> ()
    
    @IBOutlet weak var tfSearch: UITextField? {
        didSet{
            
//            tfSearch?.attributedPlaceholder = NSAttributedString(string:L10n.SearchForProduct.string, attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
            tfSearch?.textAlignment = Localize.currentLanguage() == Languages.Arabic ? .right : .left
         }
    }
    @IBOutlet weak var bgView: View? {
        didSet {
            //bgView?.backgroundColor = UIColor.white.withAlphaComponent(0.25)
        }
    }
    var actionSearch : ActionSerach?
    var actionBarcode : ActionBarCode?
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

    @IBAction func actionBarcodeSearch(sender: UIButton) {
        guard let block = actionBarcode else { return }
        block()
    }
    @IBAction func actionSearch(sender: UIButton) {
        
        guard let block = actionSearch else { return }
        block(tfSearch?.text)
    }
}
