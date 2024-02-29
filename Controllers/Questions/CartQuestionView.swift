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


class CartQuestionView: UIView {
    
    @IBOutlet var lblQuestion: UILabel!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var lblQuestionNumber: UILabel! {
        didSet {
            lblQuestionNumber.textColor = SKAppType.type.color
        }
    }
    
    
    var view: UIView!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func configureView(question: Question, index: Int, productPrice: Double?) {
        lblQuestion.text = question.question
        lblQuestionNumber.text = "\(index + 1)."
        let myViews = stackView.subviews.filter{$0 is CartAnswerView}
        if /myViews.count > 0 {
            for productView in myViews {
                productView.removeFromSuperview()
            }
        }
        
        for question in question.optionsList ?? [] {
            let view = CartAnswerView(frame: CGRect(x: 0, y: 0, w: stackView.size.width, h: 50))
            view.configureView(question, productPrice: productPrice)
            stackView.addArrangedSubview(view)
        }
        self.layoutIfNeeded()
    }
    
    func xibSetup() {
        
        do{
            try view = loadViewFromNib(withIdentifier: "CartQuestionView")
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

