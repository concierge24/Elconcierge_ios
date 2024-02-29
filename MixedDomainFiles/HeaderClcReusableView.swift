//
//  HeaderClcReusableView.swift
//  Sneni
//
//  Created by Prashant on 09/09/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit

class HeaderClcReusableView: UICollectionReusableView {
   
    
    let pageWidth: CGFloat = UIScreen.main.bounds.width - 20

    @IBOutlet weak var heightconstraints_HorizantalCV: NSLayoutConstraint!
    @IBOutlet weak var banner_Horizantol_CV: UICollectionView!{
        didSet{
            banner_Horizantol_CV.dataSource = self
            banner_Horizantol_CV.delegate = self
                NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("ReloadMixedHomeHeader"), object: nil)
                
        }
    }
    @objc func methodOfReceivedNotification(notification: Notification) {
        self.banner_Horizantol_CV.reloadData()
    }
    
    
        
}

extension HeaderClcReusableView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"MixedHomeBannerCell", for: indexPath) as! MixedHomeBannerCell
            if let banners = GDataSingleton.arrayMixedBanners {
                if let cell = cell as? MixedHomeBannerCell, let banner = banners[indexPath.item] as? Banner {
                    cell.banner = banner
                }
            }
            return cell
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GDataSingleton.arrayMixedBanners?.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue:  "BannerTap"), object: nil, userInfo: ["index":indexPath.row] )
    }
    
}

extension HeaderClcReusableView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: pageWidth, height: collectionView.frame.size.height)
        
    }
}
