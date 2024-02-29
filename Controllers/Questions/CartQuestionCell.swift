//
//  CartQuestionCell.swift
//  Sneni
//
//  Created by Daman on 08/04/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit

class CartQuestionCell: UITableViewCell {

    @IBOutlet var lblQuestion: UILabel!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var lblQuestionNumber: UILabel! {
        didSet {
            lblQuestionNumber.textColor = SKAppType.type.color
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(question: Question, index: Int, productPrice: Double?) {
        lblQuestion.text = question.question
        lblQuestionNumber.text = "\(index + 1)."
        let myViews = stackView.subviews.filter{$0 is CartAnswerView}
        if /myViews.count > 0{
            for productView in myViews {
                productView.removeFromSuperview()
            }
        }
        
        for question in question.optionsList ?? [] {
            let view = CartAnswerView(frame: CGRect(x: 0, y: 0, w: stackView.size.width, h: 100))
            view.configureView(question, productPrice: productPrice)
            stackView.addArrangedSubview(view)
        }
        self.layoutIfNeeded()
    }
    
}
