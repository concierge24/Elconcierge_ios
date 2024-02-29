//
//  SupplierInfoTabCell.swift
//  Clikat
//
//  Created by cblmacmini on 5/4/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

protocol SupplierInfoTabCellDelegate {
    func changeSupplierInfoTab(selectedTab : SelectedTab)
}

enum SelectedTab : Int {
    case Uniqueness = 2
    case Review = 3
    case About = 1
    static func selectedTab(index : Int) -> SelectedTab {
        switch index {
        case SelectedTab.Review.rawValue:
            return .Review
        case SelectedTab.About.rawValue:
            return .About
        default:
            return .Uniqueness
        }
    }
}

class SupplierInfoTabCell: ThemeTableCell {

    var delegate : SupplierInfoTabCellDelegate?
    
    @IBOutlet weak var viewHighlight: UIView! {
        didSet {
            viewHighlight.backgroundColor  = ButtonThemeColor.shared.btnSelectedColor
        }
    }
    
    @IBOutlet weak var constraintLeadingViewHighlight: NSLayoutConstraint!
    
    @IBOutlet weak var btnAbout: UIButton!
    @IBOutlet weak var btnUnique: UIButton!
    @IBOutlet weak var btnReview: UIButton!
    @IBOutlet weak var btnRate: UIButton! {
        didSet {
            btnRate.setTitle("\(L11n.rate.string) \(SKAppType.type.supplier)", for: .normal)
        }
    }
    
    @IBOutlet weak var vwRate: UIView!
    
     @IBOutlet weak var rateLbl: UILabel!
     @IBOutlet weak var totalReviewLbl: UILabel!
    
    @IBOutlet weak var heightLayout: NSLayoutConstraint!
    
    var supplier : Supplier?{
        didSet{
            updateUI()
        }
    }
    
    private func updateUI(){
        
        totalReviewLbl.isHidden = (/supplier?.totalReviews?.toInt()) == 0
        totalReviewLbl.text = "\(/supplier?.totalReviews) \(L11n.reviews.string)"
        rateLbl.text = supplier?.rating
        
    }
    
    @IBAction func actionTabSelected(sender: UIButton) {
        
//        constraintLeadingViewHighlight.constant = sender.frame.minX
//        UIView.animate(withDuration: 0.2) {
//
//        }
        
        self.layoutIfNeeded()
        let tab = SelectedTab.selectedTab(index: sender.tag)
        adjustViewHighlight(tab: tab)
        self.delegate?.changeSupplierInfoTab(selectedTab: tab)
    }
    
     @IBAction func actionRateSupplier(sender: UIButton) {
        
        if let vc = UIApplication.topViewController() as? SupplierInfoViewController {
            vc.handleReviewCellTap()

        } else if let vc = UIApplication.topViewController() as? SupplierInfoViewControllerNoFood {
            vc.handleReviewCellTap()
        }
    }
    
    func adjustViewHighlight(tab : SelectedTab){
        
        btnAbout.isSelected = false
        btnReview.isSelected = false
        btnUnique.isSelected = false
        
        var x: CGFloat = 0.0
        var hightReview: CGFloat = 0.0
        switch tab {
        case .About:
            x = btnAbout.frame.minX
            btnAbout.isSelected = true
        case .Review:
            x = btnReview.frame.minX
            btnReview.isSelected = true
            hightReview = 44.0
        case .Uniqueness:
            x = btnUnique.frame.minX
            btnUnique.isSelected = true
        }
        heightLayout.constant = hightReview
        constraintLeadingViewHighlight.constant = x

        self.layoutIfNeeded()

    }
    
    

}
