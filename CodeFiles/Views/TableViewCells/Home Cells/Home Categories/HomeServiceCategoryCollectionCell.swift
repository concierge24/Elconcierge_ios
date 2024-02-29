//
//  HomeServiceCategoryCollectionCell.swift
//  Sneni
//
//  Created by Sandeep Kumar on 27/06/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class HomeServiceCategoryCollectionCell: UICollectionViewCell {

    //MARK:- ======== Outlets ========
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblTitle: UILabel! {
        didSet {
            if SKAppType.type.isJNJ {
                lblTitle.textAlignment = .center
            }
        }
    }

    //MARK:- ======== Variables ========
    static func size(row: Int, type: HomeScreenSection) -> CGSize {
        
        //Nitin
        let width = (UIScreen.main.bounds.width-32.0-60.0)/4.0
//        if row > 1 && type == .listCategories1st2 {
//            width = (UIScreen.main.bounds.width-32.0-(8.0*2.0))/3.0
//        }
        return CGSize(width: width, height: width+20)
        
//        var width = (UIScreen.main.bounds.width-32.0-8.0)/2.0
//        if row > 1 && type == .listCategories1st2 {
//            width = (UIScreen.main.bounds.width-32.0-(8.0*2.0))/3.0
//        }
//        return CGSize(width: width, height: (width*3/4)+8+32)
    }
//    static var size: CGSize {
//        let width = (UIScreen.main.bounds.width-32.0-8.0)/2.0
//        return CGSize(width: width, height: (width*3/4)+8+32)
//    }
    
    var objModel: ServiceType? = nil {
        didSet {
            if SKAppType.type == .home {
                imgProfile.loadImage(thumbnail: objModel?.icon, original: nil, modeType: .scaleAspectFit)
            }
            else {
                imgProfile.loadImage(thumbnail: objModel?.image, original: nil)
            }
            lblTitle.text = /objModel?.name
            lblDetail.text = /objModel?.desc
            lblDetail.isHidden = SKAppType.type.isJNJ
        }
    }
    
    //MARK:- ======== LifeCycle ========
    override func awakeFromNib() {
        super.awakeFromNib()
        initalSetup()
    }
    
    //MARK:- ======== Actions ========
    @IBAction func didTapSubmit(_ sender: Any) {
        
    }
    
    //MARK:- ======== Functions ========
    func initalSetup() {
        
    }

}
