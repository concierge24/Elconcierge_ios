//
//  SupplierCollectionCell.swift
//  Clikat
//
//  Created by cblmacmini on 5/30/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import AMRatingControl
class SupplierCollectionCell: BasePageCollectionCell {

    var supplier : Supplier?{
        didSet{
            updateUI()
        }
    }
    
    
    @IBOutlet weak var labelTitle: UILabel!{
        didSet{
            labelTitle.layer.shadowRadius = 2
            labelTitle.layer.shadowOffset = CGSize(width: 0, height: 3)
            labelTitle.layer.shadowOpacity = 0.2
        }
    }
    @IBOutlet weak var imageViewSupplier: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    
    @IBOutlet weak var viewRating: UIView!{
        didSet{
            productRate = 0
        }
    }
    @IBOutlet weak var imageListView: UIView!{
        didSet{
            
        }
    }
    @IBOutlet weak var labelTitleBackground: UIView!{
        didSet{
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = labelTitleBackground.bounds
            gradientLayer.colors = [UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor,UIColor.clear.cgColor]
            labelTitleBackground.layer.insertSublayer(gradientLayer, at: 0)
        }
    }

//    let rateControl = AMRatingControl(location: CGPoint(x: 0,y: 0), empty: UIImage(asset : Asset.Ic_star_small_grey), solidImage: UIImage(asset : Asset.Ic_star_small_yellow), andMaxRating: 5)
    
    var rateControl: AMRatingControl!
    var productRate : Int = 0 {
        didSet {
            defer {
                
                if !viewRating.subviews.isEmpty {
                    
                    viewRating.subviews.forEach({ $0.removeFromSuperview() })
                    rateControl = nil
                }
                
                let imge = UIImage(asset : Asset.Ic_star_small_yellow)?.maskWithColor(color: getColor(rating: productRate))
                rateControl = AMRatingControl(location: CGPoint(x: 0,y: 0), empty: UIImage(asset : Asset.Ic_star_small_grey), solidImage: imge, andMaxRating: 5)
                rateControl.frame = viewRating.bounds
                rateControl.isUserInteractionEnabled = false
                rateControl?.rating = productRate
                rateControl?.starWidthAndHeight = 20
                viewRating.addSubview(rateControl)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateUI(){
        
        defer {
            labelName.text = supplier?.name
            labelAddress.text = supplier?.address
            labelTitle.text = supplier?.name
            configureImageListView()
        }
        
        productRate = /Int(supplier?.rating ?? "0")
        
        imageViewSupplier.loadImage(thumbnail: supplier?.logo, original: nil)
        
        
    }
    
    
    func configureImageListView(){
      
        let expandable = AZExpandableIconListView(frame: imageListView.bounds, imageUrls: supplier?.supplierImages ?? [])
        imageListView.addSubview(expandable)
    }
}
