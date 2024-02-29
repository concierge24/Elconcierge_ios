//
//  MainTabBarViewController.swift
//  Sneni
//
//  Created by Apple on 18/08/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    var deliveryType: Int = 0
//    let homeItem =  UITabBarItem(title: "Home".localized(), image: #imageLiteral(resourceName: "homeUnselected"), tag: 0)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        self.tabBar.tintColor = SKAppType.type.color
        
        
        var homeVc = UIViewController()
        
       // if AppSettings.shared.app_type > 10 {
          //  homeVc = StoryboardScene.Main.instantiateHomeViewController()
       // }
       // else {
            if (AppSettings.shared.appThemeData?.show_home_screen_theme ?? "") == "1" {
                homeVc = NewHomeScreenVC.getVC(.moreScreen)
            } else {
                homeVc = SKAppType.type == .carRental ? StoryboardScene.Main.instantiateRoyorentalHomeController() : StoryboardScene.Main.instantiateEcommerceHomeViewController()
            }
       // }
        
        let homeItem =  UITabBarItem(title: "Home".localized(), image: #imageLiteral(resourceName: "homeUnselected"), tag: 0)
        homeItem.selectedImage = #imageLiteral(resourceName: "homeSelected")
        homeVc.tabBarItem = homeItem
        
        var vc = UIViewController()
        var item : UITabBarItem?
        if SKAppType.type == .carRental {
            vc = StoryboardScene.Main.instantiateRentalFavouritesController()
            item = UITabBarItem(title: "Favourites".localized(), image: #imageLiteral(resourceName: "cartUnselected"), tag: 1)
            item?.selectedImage = UIImage(named: "favouriteSelected")
        } else {
            vc = StoryboardScene.Options.instantiateCartViewController()
            item = UITabBarItem(title: "Cart".localized(), image: #imageLiteral(resourceName: "cartUnselected"), tag: 1)
            item?.selectedImage = #imageLiteral(resourceName: "cartSelected")
        }
        vc.tabBarItem = item
        
        var titl = ""
        if let term = TerminologyKeys.orders.localizedValue() as? String{
            titl = term
        }
        let vc1 = StoryboardScene.Order.instantiateOrderHistoryViewController()
        let item1 = UITabBarItem(title: titl, image: #imageLiteral(resourceName: "ordersUnselected"), tag: 2)
        item1.selectedImage = #imageLiteral(resourceName: "ordersSelected")
        vc1.tabBarItem = item1
        var vc2 = UIViewController()
        vc2 = StoryboardScene.Main.instantiateMoreViewController()

        let item2 = UITabBarItem(title: "Others".localized(), image: #imageLiteral(resourceName: "moreUnselected"), tag: 3)
        item2.selectedImage = #imageLiteral(resourceName: "moreSelected")
        vc2.tabBarItem = item2
            
        
        if AppSettings.shared.appThemeData?.is_health_theme == "1" {
            self.tabBar.tintColor = .white
            self.tabBar.unselectedItemTintColor = UIColor.white.withAlphaComponent(0.60)
            self.tabBar.barTintColor = SKAppType.type.color
            
            homeVc.tabBarItem.image = #imageLiteral(resourceName: "tab_home")
            homeVc.tabBarItem.selectedImage = #imageLiteral(resourceName: "tab_home")
            
            vc.tabBarItem.image = #imageLiteral(resourceName: "tab_cart")
            vc.tabBarItem.selectedImage = #imageLiteral(resourceName: "tab_cart")

            vc1.tabBarItem.image = #imageLiteral(resourceName: "tab_orders")
            vc1.tabBarItem.selectedImage = #imageLiteral(resourceName: "tab_orders")

            vc2.tabBarItem.image = #imageLiteral(resourceName: "tab_more")
            vc2.tabBarItem.selectedImage = #imageLiteral(resourceName: "tab_more")
            vc2.tabBarItem.title = "More".localized()
            
        }
        
        if SKAppType.type == .eCom {
            var category = ""
            if let term = TerminologyKeys.categories.localizedValue() as? String{
                category = term
            }
            let vc3 = APIConstants.defaultAgentCode == "bletani_0675" ? CategoryTabVC.getVC(.main) : CategoryTabVC.getVC(.main)
            let item3 = UITabBarItem(title: category, image: #imageLiteral(resourceName: "ic_categories_unactive"), tag: 2)
            item3.selectedImage = #imageLiteral(resourceName: "ic_categories")
            vc3.tabBarItem = item3
            
            self.viewControllers = [homeVc, vc3, vc, vc1, vc2]
        }
        else {
            self.viewControllers = [homeVc, vc, vc1, vc2]
        }
        getTermsAndConditions()
    }

     func getTermsAndConditions()  {
             let objR = API.getTermsAndConditions
             APIManager.sharedInstance.opertationWithRequest(withApi: objR) { (response) in
                 switch response{
                 case APIResponse.Success(let object):
                    if let data = object as? TermsResponse {
                        GDataSingleton.sharedInstance.termsAndConditions = data.array
                    }
                 default :
                     break
                 }
             }
    }

}

//MARK:- UITabBarControllerDelegate
extension MainTabBarViewController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: CartNotification), object: self, userInfo: nil)
        
        if tabBarController.selectedIndex != 0 {
            if let vc = tabBarController.viewControllers?[selectedIndex] as? CartViewController {
                vc.hideBackButton = true
                vc.cartProdcuts = nil
                vc.deliveryType = self.deliveryType
            } else if let vc = tabBarController.viewControllers?[selectedIndex] as? OrderSummaryController {
                vc.hideBackButton = true
            }
        }
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        switch self.selectedIndex {
        case 0:
            if let vc = self.viewControllers?[0] as? HomeViewController {
                self.deliveryType = vc.deliveryType
                //openHomeWith(category: nil, type: nil)
            }
        default:
            break
        }
    }
    
}
