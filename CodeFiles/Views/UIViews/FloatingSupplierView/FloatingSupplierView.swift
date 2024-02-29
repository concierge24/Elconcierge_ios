//
//  FloatingSupplierView.swift
//  Clikat
//
//  Created by cblmacmini on 7/14/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

typealias FloatingViewTapped = () -> ()

class FloatingSupplierView: UIView {


    @IBOutlet weak var imageSupplier : UIImageView!{
        didSet{
            imageSupplier.layer.cornerRadius = 32
        }
    }
    
    var floatingViewTapped : FloatingViewTapped?
    
    var view: UIView!
    var supplierId : String?
    var supplierBranchId : Int?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        xibSetup()
        let tap = UITapGestureRecognizer(target: self, action: #selector(FloatingSupplierView.handleTap(sender:)))
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
       
    }
    
    
    func xibSetup() {
        
        do {
            view = try loadViewFromNib(withIdentifier: CellIdentifiers.FloatingSupplierView)
            view.frame = bounds
            view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
            addSubview(view)
        }
        catch let exception{
            print(exception)
        }
    }
    
    @objc func handleTap(sender : UITapGestureRecognizer){
        
        guard let block = floatingViewTapped else { return }
         block()
    }
}
