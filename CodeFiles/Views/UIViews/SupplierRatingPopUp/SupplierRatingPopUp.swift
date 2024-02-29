//
//  SupplierRatingPopUp.swift
//  Clikat
//
//  Created by cblmacmini on 5/27/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import SZTextView
import AMRatingControl
import Material
import Cosmos

typealias SupplierRatingSuccessBlock = (_ rating : Int?, _ comment : String?) -> ()
class SupplierRatingPopUp: UIView {

    var view: UIView!
    var presentingViewController : UIViewController?

    @IBOutlet weak var viewRating: CosmosView!
    
    @IBOutlet weak var viewOverlay: UIView!
    @IBOutlet weak var viewContainer: View!
    @IBOutlet weak var tvComment: SZTextView!
    @IBOutlet weak var labelSupplierName: UILabel!{
        didSet{
            labelSupplierName?.text = ""
            
//            viewRating.didFinishTouchingCosmos = {
//                [weak self] rating in
//                
//            }
        }
    }
    
    var supplier : Supplier?{
        didSet{
            updateUI()
        }
    }
    var okClicked : SupplierRatingSuccessBlock?
    
//    let rateControl = AMRatingControl(location: CGPoint(x: 0,y: 0), empty: UIImage(asset : Asset.Ic_star_big_grey), solidImage: UIImage(asset : Asset.Ic_star_big_yellow), andMaxRating: 5)
    
    init(frame: CGRect,fromViewController : UIViewController?,supplier : Supplier?) {
        super.init(frame: frame)
        presentingViewController = fromViewController
        self.supplier = supplier
    }
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    
    func xibSetup() {
        
        do {
            view = try loadViewFromNib(withIdentifier: CellIdentifiers.SupplierRatingPopUp)
            view.frame = bounds
            view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
            addSubview(view)
        }
        catch let exception{
            print(exception)
        }
    }
    
    func updateUI(){
        guard let currentSupplier = supplier else { return }
        
        labelSupplierName.text = currentSupplier.name
        viewRating.rating = /supplier?.myReview?.rating?.toDouble
        self.tvComment.text = /supplier?.myReview?.comment
          self.tvComment.font = UIFont(openSans: .boldItalic, size: 15.0)
    }
    
}
//MARK: - Present and Dismiss
extension SupplierRatingPopUp {
    
    func presentRatingView(okClickListener : SupplierRatingSuccessBlock?){
        self.okClicked = okClickListener
        viewOverlay?.alpha = 0.0
        viewContainer?.transform = CGAffineTransform(translationX: 0, y: frame.size.height)
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: .curveEaseIn, animations: {
            weak var weakSelf = self
        weakSelf?.viewContainer?.transform = CGAffineTransform.identity
            weakSelf?.viewOverlay?.alpha = 0.4
            }) { (completed) in
               
        }
    }
    func dismissRatingView(){
        UIView.animate(withDuration: 0.4, animations: {
            weak var weakSelf = self
            weakSelf?.viewOverlay?.alpha = 0.4
            weakSelf?.viewContainer?.transform = CGAffineTransform(translationX: 0, y: weakSelf?.frame.size.height ?? 0)
            }) { (completed) in
                weak var weakSelf = self
                weakSelf?.removeFromSuperview()
        }
    }
}

//MARK: - Button Action
extension SupplierRatingPopUp {
    
    @IBAction func actionCancel(sender: UIButton) {
        dismissRatingView()
    }
    
    @IBAction func actionOk(sender: UIButton) {
        
        guard viewRating.rating > 0 else {
            
            UtilityFunctions.showAlert(message: "Please select rating.")
            return
        }
        guard let block = okClicked else { return }
        block(viewRating?.rating.toInt, tvComment.text)
    }
}

