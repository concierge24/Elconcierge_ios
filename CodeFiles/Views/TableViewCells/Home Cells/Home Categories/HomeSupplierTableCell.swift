//
//  HomeFoodRestaurantTableCell.swift
//  Sneni
//
//  Created by Sandeep Kumar on 02/07/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class HomeSupplierTableCell: UITableViewCell {
    
    //MARK:- ======== Outlets ========
    @IBOutlet weak var imgPic: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var viewRating: HomeRateTextView!
    @IBOutlet weak var background_view: UIView!{
        didSet{
            //background_view.backgroundColor = SKAppType.type.alphaColor
        }
    }
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var labelStatus: UILabel!
    
    //MARK:- ======== Variables ========
    var blockSelect: ((_ supplier : Supplier?) -> ())?
    
    var objModel: Supplier? {
        didSet {
            
            lblTitle?.text = /objModel?.name
            lblSubTitle?.text = /objModel?.address
            imgPic.loadImage(thumbnail: objModel?.logo, original: nil)
            viewRating.rating = /objModel?.rating?.toDouble()
        }
    }
    
    //MARK:- ======== LifeCycle ========
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imgPic.isSkeletonable = true
        self.lblTitle.isSkeletonable = true
        self.lblSubTitle.isSkeletonable = true
        initalSetup()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(btnClick(_:)))
        addGestureRecognizer(tap)
    }
    
    //MARK:- ======== Actions ========
    @IBAction func btnClick(_ sender: Any) {
        guard let block = blockSelect else { return }
        block(objModel)
    }
    
    
    //MARK:- ======== Functions ========
    func initalSetup() {
        selectedBackgroundView = UIView()
    }
    
}
