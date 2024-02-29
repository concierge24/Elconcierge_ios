//
//  MenuModal.swift
//  Clikat
//
//  Created by cblmacmini on 4/19/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

protocol MenuBluePrint {
    
    func getTitle() -> String?
    func getImageName() -> Asset
    
}

class GenericMenu : MenuBluePrint{
    
    var title : String?
    var imageName : Asset
    
    func getImageName() -> Asset {
        return imageName
    }
    
    func getTitle() -> String? {
        return title
    }
    
    
    init (title : String?  , imageName : Asset){
        self.title = title
        self.imageName = imageName
    }
}

class MenuModal : NSObject {

        let numberOfSections = 2
        var sectionData : [[GenericMenu]] {
            return getSettingsData()
        }
        
        func getSettingsData () -> [[GenericMenu]] {
            var settingsArray = [[GenericMenu]]()
            
            
            var list = [
                GenericMenu(title: L10n.Home.string ,imageName: Asset.Ic_sp_home ),
//                GenericMenu(title: L10n.LiveSupport.string ,imageName: Asset.Ic_sp_support),
                GenericMenu(title: L10n.Cart.string ,imageName: Asset.Ic_sp_cart),
            ]
            if !SKAppType.type.isJNJ {
                list += [
                    GenericMenu(title: L10n.Promotions.string ,imageName: Asset.Ic_sp_promotions),
                    GenericMenu(title: L10n.Notifications.string, imageName: Asset.Ic_sp_notifications),
                    GenericMenu(title: L10n.CompareProducts.string, imageName: Asset.Ic_compare)
                ]
            }
            
            if SKAppType.type == .eCom {
                list.insert(GenericMenu(title: L11n.wishList.string ,imageName: Asset.Ic_favorite_white_normal), at: 2)
            }
            settingsArray.append(list)
            
            list = [
//                GenericMenu(title: L10n.MyFavorites.string ,imageName: Asset.Ic_sp_favorites),
                GenericMenu(title: L11n.currentOrders.string ,imageName: Asset.Ic_my_order),
//                GenericMenu(title: L10n.ScheduledOrders.string ,imageName: Asset.Ic_sp_order_history),
//                GenericMenu(title: L10n.TrackMyOrder.string ,imageName: Asset.Ic_sp_order_track),
                GenericMenu(title: L10n.RateMyOrder.string ,imageName: Asset.Ic_sp_order_rate),
                GenericMenu(title: L10n.OrderHistory.string, imageName: Asset.Ic_sp_order_upcoming),
            ]
            
            if !SKAppType.type.isJNJ {
                list.append(GenericMenu(title: L10n.LoyalityPoints.string, imageName: Asset.Ic_sp_loyalty))
            }
            list += [
                GenericMenu(title: L10n.ShareApp.string ,imageName:Asset.Ic_sp_share),
                GenericMenu(title: L10n.TermsAndConditions.string ,imageName:Asset.Ic_terms),
                GenericMenu(title: L10n.AboutUs.string ,imageName:Asset.Ic_about_Us),
                GenericMenu(title: L10n.Settings.string ,imageName: Asset.Ic_sp_settings)
            ]
            settingsArray.append(list)
            return settingsArray
        }
}
