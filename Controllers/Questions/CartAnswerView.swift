//
//  ProductInfoHeaderView.swift
//  Clikat
//
//  Created by cbl73 on 5/6/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import SKPhotoBrowser
import AMRatingControl
import Cosmos


class CartAnswerView: UIView {
    
    @IBOutlet var lblOption: UILabel!
    @IBOutlet var lblPrice: UILabel!

    var view: UIView!

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func configureView(_ model: QuestionOption, productPrice: Double?) {
        lblOption.text = "• \(/model.optionLabel)"
        lblPrice.text = model.displayValue(productPrice: productPrice)
    }
    
    func xibSetup() {
        
        do{
            try view = loadViewFromNib(withIdentifier: "CartAnswerView")
            view.frame = bounds
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
            NSLayoutConstraint.activate([

                      view.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
                      view.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
                      view.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
                      view.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
                      ])
        }
        catch let exception{
            print(exception)
        }
        
        
    }
}
 
