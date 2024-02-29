//
//  OnboardingCollectionViewCell.swift
//  Wasaf
//
//  Created by OSX on 21/07/18.
//  Copyright © 2018 Sandeep. All rights reserved.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell{
    
    //MARK:- ======== Outlets ========
    @IBOutlet var stackContent: UIStackView!
    
    @IBOutlet weak var imgFull: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet var lblGetStarted: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!

    //MARK:- ======== Variables ========
    var onboardingData: OnboardingModel?{
        
        didSet {
        
            guard let onboardingData = onboardingData else { return }
            
            imageView.image = onboardingData.image
            
            lblTitle.text = onboardingData.title
            lblSubtitle.text = onboardingData.subtitle
            
            let isLast = onboardingData.image.hash == UIImage().hash
            
            stackContent.isHidden = isLast
            lblGetStarted.isHidden = !isLast
            
            if APIConstants.defaultAgentCode == "poneeex_0049" {
                imgFull.image = onboardingData.image
                imgFull.isHidden = false
            }

        }
    }
}
