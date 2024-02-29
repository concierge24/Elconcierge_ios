//
//  HeadingCollectionCell.swift
//  Knowmoto
//
//  Created by cbl16 on 02/08/19.
//  Copyright © 2019 Codebbewlabs. All rights reserved.
//

import UIKit
import Kingfisher

class WalkthroughCollectionViewCell: UICollectionViewCell {
        
    //MARK:- OUTLETS
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var imageViewScreens: UIImageView!
    
    var model:Any?{
        didSet{
            configureCell()
        }
    }
    
    
    func configureCell(){
        
        guard let _model = model as? Walkthrough else {return}
        
       // imageViewScreens?.image = _model.image
        
        
        
        lblTitle?.text = _model.value
        lblSubtitle?.text = _model.description
        lblSubtitle?.setLineSpacing(lineSpacing: 4.0)
        
        guard let url = URL(string: /_model.image_url) else {return}
        imageViewScreens.kf.setImage(with: url)
        
    }
}
