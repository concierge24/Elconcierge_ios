//
//  CutomizationTableHeaderView.swift
//  Sneni
//
//  Created by Apple on 26/09/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class CutomizationTableHeaderView: UIView {

    //MARK:- IBOutlet
    @IBOutlet weak var option_label: UILabel!{
        didSet{
            option_label.text = "Please select option".localized()
        }
    }
    @IBOutlet weak var choise_label: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadFromNib()
    }
    
    func loadFromNib() {
        let view = UINib(nibName: "CutomizationTableHeaderView", bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.addSubview(view)
    }

}
